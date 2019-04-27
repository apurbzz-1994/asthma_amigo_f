//
//  CurrentWeather.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 27/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//


import SwiftyJSON
import Alamofire
import Foundation

class CurrentWeather {
    
    private var _cityName: String!
    private var _date: String!
    private var _weatherType: String!
    private var _currentTemp: Double!
    private var _humidityVal: String!
    private var _airQuality: String!
    private  var  _summary: String!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
    }
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    var summary: String {
        if _summary == nil {
            _summary = ""
        }
        return _summary
    }
    var airQuality: String {
        if _airQuality == nil {
            _airQuality = ""
        }
        return _airQuality
    }
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    var humidityVal: String {
        if _humidityVal == nil {
            _humidityVal = ""
        }
        return _humidityVal
    }
    
    func downloadCurrentWeather(completed: @escaping DownloadComplete){
        Alamofire.request(API_URL).responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(let value):
                print(value)
                let json = JSON(value)
                self._cityName = json["Name"].stringValue
                print(self._cityName)
                // let tempDate = json["dt"].double
                self._weatherType = json["TempDesc"].stringValue
                let downloadedTemp = json["TempValue"].double
                self._humidityVal = json["HumidDesc"].stringValue
                self._currentTemp = downloadedTemp!
                print(self._humidityVal)
                print(self._weatherType)
                print(self._currentTemp)
                self._airQuality = json["AirQualityDesc"].stringValue
                print(self._airQuality)
                self._summary = json["Summary"].stringValue
                print(self._summary)
            case .failure(let error):
                print(error.localizedDescription)
            }
            DispatchQueue.main.async{
                completed ()
                
            }
        }
    }
}


