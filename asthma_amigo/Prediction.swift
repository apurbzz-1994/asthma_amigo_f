//
//  Prediction.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 8/5/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit

class Prediction: NSObject {
    
    var humidity: String
    var temperature: String
    var dateAndTime: String
    var qualityAir: String
    
    init(humidity: String, temperature: String, dateAndTime: String, qualityAir: String){
        self.humidity = humidity
        self.temperature = temperature
        self.dateAndTime = dateAndTime
        self.qualityAir = qualityAir
    }

}
