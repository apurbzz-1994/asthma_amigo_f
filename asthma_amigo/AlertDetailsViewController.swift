//
//  AlertDetailsViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 12/5/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit
import CoreData

class AlertDetailsViewController: UIViewController {
    
    var selectedAlert: WeatherAlert?
    
    //labels
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var airQualityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateSummary: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        humidityLabel.text = "\((selectedAlert?.humidity)!)%"
        airQualityLabel.text = selectedAlert?.qualityAir
        temperatureLabel.text = "\((selectedAlert?.temperature)!) ℃"

        // Do any additional setup after loading the view.
        //format date
        let stringDate = selectedAlert?.dateAndTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let tempDate = dateFormatter.date(from: stringDate!)
        dateFormatter.dateFormat = "MMM dd,yyyy"
        let tempDateTwo = dateFormatter.string(from: tempDate!)
        
        
        let dateForLabel = "\(tempDateTwo)"
        dateSummary.text = "Weather alert for \(dateForLabel)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AlertDiaryViewController
        destination.selectedAlert = selectedAlert
    }
    

}
