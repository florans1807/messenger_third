//
//  CalendarViewController.swift
//  Messenger
//
//  Created by Флоранс on 12.12.2023.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    
    var delegate: SetSelectedDirectionOrDate?
    
    var selectedDate: Date?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.scrollDirection = .vertical
        calendar.pagingEnabled = false
        calendar.select(selectedDate)
    }

    @IBAction func allDaysTapped(_ sender: Any) {
        delegate?.setSelectedDate(strDate: "На все дни")
        self.dismiss(animated: true)
    }
    
    @IBAction func tomorrowTapped(_ sender: Any) {
        delegate?.setSelectedDate(strDate: "tomorrow")
        self.dismiss(animated: true)
    }
    
    @IBAction func todayTapped(_ sender: Any) {
        delegate?.setSelectedDate(strDate: "today")
        self.dismiss(animated: true)
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension CalendarViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let string = formatter.string(from: date)
        print("\(string)")
        delegate?.setSelectedDate(strDate: string)
        self.dismiss(animated: true)
    }
    
}
