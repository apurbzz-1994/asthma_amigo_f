//
//  NotificationSettingsViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 11/5/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationSettingsViewController: UIViewController {
    
    //@IBOutlet weak var userChoiceSegment: UISegmentedControl!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var setTimeCard: UIView!
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    var hour: String = "6"
    var minute: String = "0"
    var hitSave: Bool = false
    
    //declaring helper object for manipulating plist
    var plistHelper = PListHelper()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
        navigationController?.navigationBar.backgroundColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)

        // Do any additional setup after loading the view.
        datePicker?.datePickerMode = .time
        datePicker?.addTarget(self, action: #selector(timeChanged(timePicker: )), for: .valueChanged)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        let date = dateFormatter.date(from: "06:00")
        
        datePicker.date = date!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let willBeNotified = plistHelper.readPlist(namePlist: "contacts", key: "toBeNotifiedAboutHealth")
        let h = plistHelper.readPlist(namePlist: "contacts", key: "n_hour")
        let m = plistHelper.readPlist(namePlist: "contacts", key: "n_minute")
        
        if h as! String != "0" && m as! String != "0"{
            let dateFormatterSave = DateFormatter()
            dateFormatterSave.dateFormat = "HH:mm"
            
            let date = dateFormatterSave.date(from: "\(h):\(m)")
            datePicker.date = date!
        }
        
        if willBeNotified as! String == "y"{
            //Enable options
            timeSwitch.isOn = true
            //userChoiceSegment.selectedSegmentIndex = 0
            //timeLabel.isEnabled = true
            saveButton.isEnabled = true
            setTimeCard.alpha = 1
        }
        else{
            timeSwitch.isOn = false
            //timeLabel.text = "6:00 AM"
            //userChoiceSegment.selectedSegmentIndex = 1
            //timeLabel.isEnabled = false
            saveButton.isEnabled = false
            setTimeCard.alpha = 0.439216
        }
        
        
    }
    
    @objc func timeChanged(timePicker: UIDatePicker){
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH"
        hour = timeFormatter.string(from: datePicker.date)
        timeFormatter.dateFormat = "mm"
        minute = timeFormatter.string(from: datePicker.date)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let willBeNotified = plistHelper.readPlist(namePlist: "contacts", key: "toBeNotifiedAboutHealth")
        
        if willBeNotified as! String == "y"{
            if hitSave == false{
                plistHelper.writePlist(namePlist: "contacts", key: "toBeNotifiedAboutHealth", data: "n" as AnyObject)
            }
        }
        
    }
    
//    @IBAction func choiceOnTapped(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex{
//        case 0:
//            userChoiceSegment.selectedSegmentIndex = 0
//            timeLabel.isEnabled = true
//            saveButton.isEnabled = true
//            setTimeCard.alpha = 1
//
//            plistHelper.writePlist(namePlist: "contacts", key: "toBeNotifiedAboutHealth", data: "y" as AnyObject)
//            break
//        case 1:
//            userChoiceSegment.selectedSegmentIndex = 1
//            timeLabel.isEnabled = false
//            saveButton.isEnabled = false
//            setTimeCard.alpha = 0.439216
//
//            plistHelper.writePlist(namePlist: "contacts", key: "toBeNotifiedAboutHealth", data: "n" as AnyObject)
//            break
//        default:
//            userChoiceSegment.selectedSegmentIndex = 1
//            timeLabel.isEnabled = false
//            saveButton.isEnabled = false
//            setTimeCard.alpha = 0.439216
//
//            break
//        }
//    }
    
    
    @IBAction func timeSwitchToggle(_ sender: UISwitch) {
        if sender.isOn == true{
            //userChoiceSegment.selectedSegmentIndex = 0
            //timeLabel.isEnabled = true
            saveButton.isEnabled = true
            setTimeCard.alpha = 1
            
            plistHelper.writePlist(namePlist: "contacts", key: "toBeNotifiedAboutHealth", data: "y" as AnyObject)
        }
        else{
            //userChoiceSegment.selectedSegmentIndex = 1
            //timeLabel.isEnabled = false
            
            //disable notificatios
            //remove notification schedule if pending
            checkIfPendingOrNot(){isPending in
                //remove
                //print(deletedReminder.reminderID)
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["healthStatusNotification"])
            }
            //---------------------------
            
            
            saveButton.isEnabled = false
            setTimeCard.alpha = 0.439216
            
            plistHelper.writePlist(namePlist: "contacts", key: "toBeNotifiedAboutHealth", data: "n" as AnyObject)
        }
    }
    
    
    //reusing function for checking if a notification is pending
    func checkIfPendingOrNot(completed: @escaping (Bool)-> Void = {_ in }) {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests{
                completed(request.identifier == "healthStatusNotification")
            }
        })
    }
    
    
    
    
    @IBAction func saveOnPress(_ sender: Any) {
        //set notifications
        scheduleLocal(hour: hour, minute: minute)
        
        //save the user selected time here.
        plistHelper.writePlist(namePlist: "contacts", key: "n_hour", data: hour as AnyObject)
         plistHelper.writePlist(namePlist: "contacts", key: "n_minute", data: minute as AnyObject)
        
        let alertController = UIAlertController(title: "Saved Successfully", message: "You will now receive notifications at the set time.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler:{
            //perform segue
            action in
        }))
        self.present(alertController, animated: true, completion: nil)
        
        hitSave = true
    }
    
    
    //code for scheduling a notification
    func scheduleLocal(hour: String, minute: String){
        //registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "How is \((plistHelper.readPlist(namePlist: "contacts", key: "Child")["First Name"]!)!) feeling today?"
        content.body = "Set \((plistHelper.readPlist(namePlist: "contacts", key: "Child")["First Name"]!)!)'s health state to get medicine remiders!"
        content.categoryIdentifier = "alarm"
        
        //the date stuff
        var dateComponent = DateComponents()
        dateComponent.hour = Int(hour)
        dateComponent.minute = Int(minute)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        //time interval for testing
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 50, repeats: false)
        
        let request = UNNotificationRequest(identifier: "healthStatusNotification", content: content, trigger: trigger)
        
        center.add(request)
        
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
