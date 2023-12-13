//
//  ApiClient.swift
//  schedule
//
//  Created by Флоранс on 05.12.2023.
//

import Foundation
import UIKit
import CoreLocation

class ApiClient {
    
    static let shared = ApiClient()
    
    let urlString2 = "https://api.rasp.yandex.net/v3.0/stations_list/?apikey=c1c3c337-25ac-43e7-96d8-b4b906744736&lang=ru_RU&format=json"
    
    lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    
    func getSchedule(date: String = "", transport: String = "", from: String, to: String, completion: @escaping (ScheduleData) -> Void) {
        let when = (date == "На все дни") ? "" : "&date=\(date)"
        let transfer = transport.isEmpty ? "" : "&transport_types=\(transport)"
       
        //let url = URL(string:"https://api.rasp.yandex.net/v3.0/search/?apikey=c1c3c337-25ac-43e7-96d8-b4b906744736&format=json&from=c45&to=c20074&lang=ru_RU&page=1" + when + transfer)!
        
        let url5 = URL(string:"https://api.rasp.yandex.net/v3.0/search/?apikey=c1c3c337-25ac-43e7-96d8-b4b906744736&format=json&from=\(from)&to=\(to)&lang=ru_RU&page=1" + when + transfer)!
        
        var request = URLRequest(url: url5)
        //print(url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                
                if let scheduleData = try? decoder.decode(ScheduleData.self, from: data) {
                    print(scheduleData)
                    completion(scheduleData)
                } else {
                    print("fail")
                }
                
                let scheduleData = try decoder.decode(ScheduleData.self, from: data)
                completion(scheduleData)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func getAllStations(date: String = "", transport: String = "", completion: @escaping ([Country]) -> Void) {
        let url = URL(string: urlString2)!
        var request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            if let stationsData = try? decoder.decode(StationsData.self, from: data) {
                print("success3")
                completion(stationsData.countries)
            } else {
                print("failToDecode")
            }
        }
        task.resume()
    }
}
