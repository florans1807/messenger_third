//
//  ScheduleTableViewCell.swift
//  schedule
//
//  Created by Флоранс on 05.12.2023.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    @IBOutlet weak var directionLabel: UILabel!
    
    @IBOutlet weak var carrierLabel: UILabel!
    
    @IBOutlet weak var vehicleLabel: UILabel!
    
    @IBOutlet weak var transportTypeImageView: UIImageView!
    
    @IBOutlet weak var dateFromLabel: UILabel!
    
    @IBOutlet weak var dateToLabel: UILabel!
    
    @IBOutlet weak var timeFromLabel: UILabel!
    
    @IBOutlet weak var timeToLabel: UILabel!
    
    @IBOutlet weak var stationFrom: UILabel!
    
    @IBOutlet weak var stationTo: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var thirdView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        directionLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
