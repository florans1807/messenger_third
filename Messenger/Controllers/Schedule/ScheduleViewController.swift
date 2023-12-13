//
//  ScheduleViewController.swift
//  Messenger
//
//  Created by Флоранс on 12.12.2023.
//

import UIKit

class ScheduleViewController: UIViewController, SetSelectedDirectionOrDate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var wayView: UIView!
    @IBOutlet weak var transportsStackView: UIStackView!
        
    @IBOutlet weak var todayBtn: UIButton!
    @IBOutlet weak var tomorrowBtn: UIButton!
    @IBOutlet weak var dateBtn: UIButton!
    
    @IBOutlet weak var anyTransportBtn: UIButton!
    @IBOutlet weak var planeBtn: UIButton!
    @IBOutlet weak var trainBtn: UIButton!
    @IBOutlet weak var suburbanBtn: UIButton!
    @IBOutlet weak var busBtn: UIButton!
        
    private var transportType: String?
    private var stationCodeFrom: String?
    private var stationCodeTo: String?
    private var selectedDate: String?
    private var chosenDate: Date?
    
    private var scheduleData: ScheduleData?
    
    private let dateFormatter = DateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.dataSource = self
//        tableView.delegate = self
        
        fromTextField.borderStyle = .none
        toTextField.borderStyle = .none
        
        fromTextField.delegate = self
        toTextField.delegate = self
        
        wayView.layer.masksToBounds = true
        wayView.layer.cornerRadius = 4
        wayView.layer.borderWidth = 1.0
        wayView.layer.borderColor = UIColor.systemGray4.cgColor
        
        todayBtn.layer.masksToBounds = true
        dateBtn.layer.masksToBounds = true
        
        dateStackView.layer.masksToBounds = true
        dateStackView.layer.cornerRadius = 4.0
        
        //setting conditions by default
        selectedDate = formatDate(date: Date.today)
        transportType = ""
        buttonSelectOrDeselect(buttons: [todayBtn, anyTransportBtn], isChosen: true)
        
        //let vc = CitiesViewController()
        //vc.getAllStations()
    }
    
    func setDirection(direction: String, code: String?, isFrom: Bool) {
        if isFrom  {
            stationCodeFrom = code
        } else {
            stationCodeTo = code
        }
    
        if isFrom {
            fromTextField.text = direction
            fromTextField.resignFirstResponder()
        } else {
            toTextField.text = direction
            fromTextField.resignFirstResponder()
        }
    }
    
    func setSelectedDate(strDate: String) {
        selectedDate = strDate
        fromTextField.resignFirstResponder()
        toTextField.resignFirstResponder()
                
        switch strDate {
        case "today":
            dateBtn.setTitle("Дата", for: .normal)
            todayBtn.backgroundColor = .darkGray
            todayBtn.setTitleColor(.white, for: .normal)
            chosenDate = Date.today
        case "tomorrow":
            dateBtn.setTitle("Дата", for: .normal)
            tomorrowBtn.backgroundColor = .darkGray
            tomorrowBtn.setTitleColor(.white, for: .normal)
            chosenDate = Date.tomorrow
        case "На все дни":
            dateBtn.setTitle(strDate, for: .normal)
            buttonSelectOrDeselect(buttons: [dateBtn], isChosen: true)
            buttonSelectOrDeselect(buttons: [todayBtn, tomorrowBtn], isChosen: false)
        default:
            //let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let date = dateFormatter.date(from: strDate)
            let date = formatFromStringToDate(string: strDate)
            dateBtn.setTitle(formatDateToRus(date: date, isFull: true), for: .normal)
            buttonSelectOrDeselect(buttons: [dateBtn], isChosen: true)
            buttonSelectOrDeselect(buttons: [todayBtn, tomorrowBtn], isChosen: false)
            chosenDate = date
        }
    }
    
    func formatDate(date: Date) -> String {
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func formatDateToRus(date: Date, isFull: Bool) -> String {
        dateFormatter.locale = Locale(identifier: "ru_RU")
        if isFull {
            dateFormatter.dateFormat = "d MMMM"
        } else {
            dateFormatter.dateFormat = "d MMM"
        }
        return dateFormatter.string(from: date)
    }
    
    func formatFromStringToDate(string: String) -> Date {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string)!
    }
    
    func buttonSelectOrDeselect(buttons: [UIButton], isChosen: Bool) {
        for btn in buttons {
            if isChosen {
                btn.backgroundColor = .darkGray
                btn.setTitleColor(.white, for: .normal)
                btn.tintColor = .white
            } else {
                btn.backgroundColor = .systemGray4
                btn.setTitleColor(.black, for: .normal)
                btn.tintColor = .black
            }
        }
    }
    
    func resignTextFields() {
        fromTextField.resignFirstResponder()
        toTextField.resignFirstResponder()
    }
    
    @IBAction func selectDate(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            selectedDate = formatDate(date: Date.today)
            chosenDate = Date.today
            dateBtn.setTitle("Дата", for: .normal)
            buttonSelectOrDeselect(buttons: [todayBtn], isChosen: true)
            buttonSelectOrDeselect(buttons: [tomorrowBtn, dateBtn], isChosen: false)
        case 2:
            selectedDate = formatDate(date: Date.tomorrow)
            chosenDate = Date.tomorrow
            dateBtn.setTitle("Дата", for: .normal)
            buttonSelectOrDeselect(buttons: [tomorrowBtn], isChosen: true)
            buttonSelectOrDeselect(buttons: [todayBtn, dateBtn], isChosen: false)
        case 3:
            selectedDate = ""
            let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
            
            guard let calendarVC = storyboard.instantiateViewController(identifier: "CalendarPopover") as? CalendarViewController else {
                print("Something wrong in storyboard")
                return
            }
            calendarVC.modalPresentationStyle = .popover
            calendarVC.delegate = self
            calendarVC.selectedDate = chosenDate
            
            present(calendarVC, animated: true, completion: nil)
        default:
            break
        }
                
//        for btn in dateStackView.arrangedSubviews {
//            let button = btn //as! UIButton
//            if btn.tag == sender.tag && btn.tag != 3 {
//                button.backgroundColor = .darkGray
//                //button.setTitleColor(.white, for: .normal)
//                button.tintColor = .white
//            } else if sender.tag != 3 {
//                button.backgroundColor = .systemGray4
//                //button.setTitleColor(.black, for: .normal)
//                button.tintColor = .black
//            }
//        }
    }
    
    @IBAction func selectTransport(_ sender: UIButton) {
        
        for btn in transportsStackView.arrangedSubviews {
            let button = btn as! UIButton
            if btn.tag == sender.tag {
                button.setTitleColor(.white, for: .normal)
                button.tintColor = .white
            } else {
                button.backgroundColor = .systemGray4
                button.setTitleColor(.black, for: .normal)
                button.tintColor = .black
            }
        }
        
        switch sender.tag {
        case 1:
            sender.backgroundColor = .darkGray
            transportType = ""
        case 2:
            sender.backgroundColor = .blue
            transportType = "plane"
        case 3:
            sender.backgroundColor = .red
            transportType = "train"
        case 4:
            sender.backgroundColor = .green
            transportType = "suburban"
        case 5:
            sender.backgroundColor = .orange
            transportType = "bus"
        default:
            break
        }
    }
    
    @IBAction func tapToFindSchedule(_ sender: Any) {
        if let from = fromTextField.text, let to = toTextField.text {
            if from.isEmpty || to.isEmpty {
                noDirectionAlert()
            } else {
                scheduleData = nil
                ApiClient.shared.getSchedule(date: selectedDate ?? "", transport: transportType ?? "", from: stationCodeFrom ?? "", to: stationCodeTo ?? "") { [weak self] values in
                    DispatchQueue.main.async {
                        guard let self else { return }
                        self.scheduleData = values
                        self.tableView.reloadData()
                    }
                }
                tableView.dataSource = self
                tableView.delegate = self
                //tableView.reloadData()
            }
        }
    }
    
    @IBAction func changeDirections(_ sender: Any) {
        let from = fromTextField.text
        let to = toTextField.text
        let codeFrom = stationCodeFrom
        let codeTo = stationCodeTo
        stationCodeFrom = codeTo
        stationCodeTo = codeFrom
        fromTextField.text = to
        toTextField.text = from
    }
    
    func noDirectionAlert() {
        let alert = UIAlertController(title: "Выберите направление", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("ok")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func noScheduleLAlert() {
        let alert = UIAlertController(title: "По данному направлению ничего не найдено", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("ok")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scheduleData != nil {
            if scheduleData?.segments.count == 0 {
                noScheduleLAlert()
            }
            return (scheduleData?.segments.count)!
        } else {
            noScheduleLAlert()
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ScheduleTableViewCell
        
        if let transportType = scheduleData?.segments[indexPath.row].thread.transportType {
            switch transportType {
            case "bus":
                cell.transportTypeImageView.image = UIImage(systemName: "bus")
                cell.transportTypeImageView.tintColor = .orange
                break
            case "helicopter":
                break
            case "plane":
                cell.transportTypeImageView.image = UIImage(systemName: "airplane")
                cell.transportTypeImageView.tintColor = .link
                break
            case "sea":
                break
            case "train":
                cell.transportTypeImageView.image = UIImage(systemName: "train.side.front.car")
                cell.transportTypeImageView.tintColor = .red
                break
            case "water":
                break
            default:
                break
            }
        }
        
        cell.carrierLabel.text = scheduleData?.segments[indexPath.row].thread.carrier.title
        if let vehicle = scheduleData?.segments[indexPath.row].thread.vehicle {
            cell.vehicleLabel.text = vehicle
        } else {
            cell.vehicleLabel.text = ""
        }
        cell.directionLabel.text = scheduleData?.segments[indexPath.row].thread.title
        
//        if let fromDate = scheduleData?.segments[indexPath.row].departure_platform {
//            cell.dateFromLabel.text = formatDateToRus(date: fromDate, isFull: false)
//            dateFormatter.dateFormat = "HH:mm"
//            cell.timeFromLabel.text = dateFormatter.string(from: fromDate)
//        }
//
//        if let toDate = scheduleData?.segments[indexPath.row].arrival_platform {
//            cell.dateToLabel.text = formatDateToRus(date: toDate, isFull: false)
//            dateFormatter.dateFormat = "HH:mm"
//            cell.timeToLabel.text = dateFormatter.string(from: toDate)
//        }
        
        if let fromDate = scheduleData?.segments[indexPath.row].departure_platform, let toDate = scheduleData?.segments[indexPath.row].arrival_platform {
            cell.dateFromLabel.text = formatDateToRus(date: fromDate, isFull: false)
            cell.dateToLabel.text = formatDateToRus(date: toDate, isFull: false)
            dateFormatter.dateFormat = "HH:mm"
            cell.timeFromLabel.text = dateFormatter.string(from: fromDate)
            cell.timeToLabel.text = dateFormatter.string(from: toDate)
        } else if scheduleData?.segments[indexPath.row].thread.interval != nil && scheduleData?.segments[indexPath.row].startDate != nil {
            let interval = scheduleData?.segments[indexPath.row].thread.interval
            let startDate = scheduleData?.segments[indexPath.row].startDate
            let fullDate = formatFromStringToDate(string: startDate!)
            let shortDate = formatDateToRus(date: fullDate, isFull: false)
            cell.timeFromLabel.text = interval?.beginTime
            cell.timeToLabel.text = interval?.endTime
            cell.dateFromLabel.text = shortDate
            cell.dateToLabel.text = "-"
        } else if let startDate = scheduleData?.segments[indexPath.row].startDate {
            let fullDate = formatFromStringToDate(string: startDate)
            let shortDate = formatDateToRus(date: fullDate, isFull: false)
            cell.dateFromLabel.text = shortDate
            cell.dateToLabel.text = "-"
            //dateFormatter.dateFormat = "HH:mm"
            cell.timeFromLabel.text = "-"//dateFormatter.string(from: fullDate)
            cell.timeToLabel.text = "-"//dateFormatter.string(from: fullDate)
        } else {
            cell.dateFromLabel.text = "-"
            cell.dateToLabel.text = "-"
            cell.timeFromLabel.text = "-"
            cell.timeToLabel.text = "-"
        }
        
        if let fromLocation = scheduleData?.search.from.title {
            if let departureTerminal = scheduleData?.segments[indexPath.row].departure_terminal {
                cell.stationFrom.text = "\(fromLocation), \(departureTerminal)"
            } else {
                cell.stationFrom.text = fromLocation
            }
        } else {
            cell.stationFrom.text = "-"
        }
        
        if let toLocation = scheduleData?.search.to.title {
            if let arrivalTerminal = scheduleData?.segments[indexPath.row].departure_terminal {
                cell.stationTo.text = "\(toLocation), \(arrivalTerminal)"
            } else {
                cell.stationTo.text = toLocation
            }
        } else {
            cell.stationTo.text = "-"
        }
        
        if let duration = scheduleData?.segments[indexPath.row].duration {
            let hours = duration/3600
            cell.durationLabel.text = hours.hours()
        }
        
        return cell
    }
    
}

extension ScheduleViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let storyboard = UIStoryboard(name: "StationsList", bundle: nil)
        
        guard let cityVC = storyboard.instantiateViewController(identifier: "CitiesPopOver") as? CitiesViewController else {
            print("Something wrong in storyboard")
            return
        }
        cityVC.modalPresentationStyle = .popover
        cityVC.delegate = self
        cityVC.stationInField = textField.text

        switch textField.tag {
        case 1:
            cityVC.isFrom = true
        case 2:
            cityVC.isFrom = false
        default:
            break
        }
        
        present(cityVC, animated: true, completion: nil)
    }
}

protocol SetSelectedDirectionOrDate {
    func setDirection(direction: String, code: String?, isFrom: Bool)
    func setSelectedDate(strDate: String)
    func resignTextFields()
}
