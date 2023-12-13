

import Foundation

// MARK: - ScheduleData
struct ScheduleData: Decodable {
    let search: Search
    let segments: [Segment]
    let interval_segments: [IntervalSegment]?
    let pagination: Pagination
    
    // MARK: - Search
    
    struct Search: Decodable {
        let from: Location
        let to: Location
        let date: String?
        
        struct Location: Decodable {
            let code: String?
            let shortTitle, popularTitle: String?
            let type: String?
            let title: String?
            let stationType: StationType?
            let stationTypeName: String?
            let transportType: String?
        }
    }
    
    // MARK: - Segment
    
    struct Segment: Decodable {
        let thread: Thread
        let from, to: Location
        let departurePlatform, arrivalPlatform, departure_terminal, arrival_terminal: String?
        let stops: String?
        let duration: Int
        let startDate: String?
        let departure_platform, arrival_platform: Date?
        let hasTransfers: Bool?
        let tickets_info: TicketsInfo?
        
        
        struct Thread: Decodable {
            let uid, title: String
            let interval: Interval?
            let number, shortTitle, threadMethodLink: String
            let carrier: Carrier
            let transportType, vehicle: String?
            let transportSubtype: TransportSubtype
            let expressType: String?
            
            struct Interval: Decodable {
                let density: String
                let endTime, beginTime: String
                
            }
            struct Carrier: Decodable {
                let code: Int
                let contacts, url: String
                let logoSVG: String?
                let title, phone: String
                let codes: Codes?
                let address: String?
                let logo: String?
                let email: String?
                
                struct Codes: Decodable {
                    let icao: String?
                    let sirena, iata: String?
                }
            }
            
            struct TransportSubtype: Decodable {
                let color, code, title: String?
            }
        }
                
        struct Location: Decodable {
            let code: String?
            let shortTitle, popularTitle: String?
            let type: String?
            let title: String?
            let stationType: StationType?
            let stationTypeName: String?
            let transportType: String?
        }
        
        struct TicketsInfo: Decodable {
            let etMarker: Bool
            let places: [Place]
            
            struct Place: Decodable {
                let currency: String
                let price: Price
                let name: String
                
                struct Price: Decodable {
                    let cents, whole: Int
                }
            }
        }
    }
    
    struct IntervalSegment: Decodable {
        let from: Location
        let thread: Thread
        let departurePlatform, stops, departureTerminal: String?
        let to: Location
        let hasTransfers: Bool
        let ticketsInfo: TicketsInfo
        let duration: Int
        let arrivalTerminal: String?
        let startDate, arrivalPlatform: String
        
        struct Location: Decodable {
            let code: String?
            let shortTitle, popularTitle: String?
            let type: String?
            let title: String?
            let stationType: StationType?
            let stationTypeName: String?
            let transportType: String?
        }
        struct Thread: Decodable {
            let uid, title: String
            let interval: Interval?
            let number, shortTitle, threadMethodLink: String
            let carrier: Carrier
            let transportType, vehicle: String?
            let transportSubtype: TransportSubtype
            let expressType: String?
            
            struct Interval: Decodable {

                let density: String
                let endTime, beginTime: String
            }
            struct Carrier: Decodable {
                let code: Int
                let contacts, url: String
                let logoSVG: String?
                let title, phone: String
                let codes: Codes?
                let address: String?
                let logo: String?
                let email: String?
                
                struct Codes: Decodable {
                    let icao: String?
                    let sirena, iata: String?
                }
            }
            
            struct TransportSubtype: Decodable {
                let color, code, title: String?
            }
        }
        struct TicketsInfo: Decodable {
            let etMarker: Bool
            let places: [Place]
            
            struct Place: Decodable {
                let currency: String
                let price: Price
                let name: String
                
                struct Price: Decodable {
                    let cents, whole: Int
                }
            }
        }
    }
    
    // MARK: - Pagination
    struct Pagination: Codable {
        let total, limit, offset: Int
    }
}
