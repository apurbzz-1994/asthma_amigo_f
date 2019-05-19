//
//  AlertDiaryViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 12/5/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit
import CoreData

class AlertDiaryViewController: UIViewController {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humLabel: UILabel!
    @IBOutlet weak var qualityAirLabel: UILabel!
    
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var triggerLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var selectedAlert: WeatherAlert?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //date format
        //format date
        let stringDate = selectedAlert?.belongToDiary?.month
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let tempDate = dateFormatter.date(from: stringDate!)
        
        dateFormatter.dateFormat = "MMM"
        let month = dateFormatter.string(from: tempDate!)
        
        
        monthLabel.text = month
        dateLabel.text = selectedAlert?.belongToDiary?.day
        
        tempLabel.text = "Temperature: \((selectedAlert?.belongToDiary?.temp)!)"
        humLabel.text = "Humidity: \((selectedAlert?.belongToDiary?.humidity)!)"
        qualityAirLabel.text = "Quality: \((selectedAlert?.belongToDiary?.quality)!)"
        
        addressLabel.text = selectedAlert?.belongToDiary?.location
        timeLabel.text = "\((selectedAlert?.belongToDiary?.hour)!): \((selectedAlert?.belongToDiary?.minute)!)"
        triggerLabel.text = selectedAlert?.belongToDiary?.trigger
        commentLabel.text = selectedAlert?.belongToDiary?.comments

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
