//
//  Extras.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 27/4/19.
//  Code originally written by Deepika on 2019/4/20 being integrated.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import Foundation

let API_URL = "http://142.93.120.204/plumber/Json?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)"

typealias DownloadComplete = () -> ()
