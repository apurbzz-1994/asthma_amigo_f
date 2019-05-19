//
//  DiaryPageViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 29/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit

class DiaryPageViewController: UIViewController, addDiaryDelegate {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var triggerLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var airQualityLabel: UILabel!
    
    
    
    
    
    //for storing diary entry selected from the previous view.
    var selectedDiary:Diary?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if selectedDiary?.month == "01"{
            monthLabel.text = "January"
        }
        else if selectedDiary?.month == "02"{
            monthLabel.text = "February"
        }
        else if selectedDiary?.month == "03"{
            monthLabel.text = "March"
        }
        else if selectedDiary?.month == "04"{
            monthLabel.text = "April"
        }
        else if selectedDiary?.month == "05"{
            monthLabel.text = "May"
        }
        else if selectedDiary?.month == "06"{
            monthLabel.text = "June"
        }
        else if selectedDiary?.month == "07"{
            monthLabel.text = "July"
        }
        else if selectedDiary?.month == "08"{
            monthLabel.text = "August"
        }
        else if selectedDiary?.month == "09"{
            monthLabel.text = "September"
        }
        else if selectedDiary?.month == "10"{
            monthLabel.text = "October"
        }
        else if selectedDiary?.month == "11"{
            monthLabel.text = "November"
        }
        else {
            monthLabel.text = "December"
        }
        dayLabel.text = selectedDiary?.day
        locationLabel.text = selectedDiary?.location
        timeLabel.text = "\((selectedDiary?.hour)!):\((selectedDiary?.minute)!)"
        triggerLabel.text = selectedDiary?.trigger
        commentsLabel.text = selectedDiary?.comments
        tempLabel.text = "Temp: \((selectedDiary?.temp)!)℃"
        humidityLabel.text = "Humidity: \((selectedDiary?.humidity)!)%"
        airQualityLabel.text = "Air Quality: \((selectedDiary?.quality)!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendDiaryEntryData(location: String, month: String, day: String, time: String, trigger: String, comment: String, temp: String, humidity: String, quality: String) {
        if month == "01"{
            monthLabel.text = "January"
        }
        else if month == "02"{
            monthLabel.text = "February"
        }
        else if month == "03"{
            monthLabel.text = "March"
        }
        else if month == "04"{
            monthLabel.text = "April"
        }
        else if month == "05"{
            monthLabel.text = "May"
        }
        else if month == "06"{
            monthLabel.text = "June"
        }
        else if month == "07"{
            monthLabel.text = "July"
        }
        else if month == "08"{
            monthLabel.text = "August"
        }
        else if month == "09"{
            monthLabel.text = "September"
        }
        else if month == "10"{
            monthLabel.text = "October"
        }
        else if month == "11"{
            monthLabel.text = "November"
        }
        else {
            monthLabel.text = "December"
        }
        dayLabel.text = day
        locationLabel.text = location
        timeLabel.text = time
        triggerLabel.text = trigger
        commentsLabel.text = comment
        tempLabel.text = "Temp: \(temp)℃"
        humidityLabel.text = "Humidity: \(humidity)%"
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destination = segue.destination as! AddDiaryViewController
        destination.diaryForEdit = selectedDiary
        destination.isEdit = true
        destination.delegate = self
    }
    

}
