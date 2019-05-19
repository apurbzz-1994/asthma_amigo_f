//
//  SetReminderViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 24/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

/*
 Code help from the following links:
 https://makeapppie.com/2016/11/21/manage-delete-and-update-notifications-in-ios-10/
 
 https://makeapppie.com/2016/08/08/how-to-make-local-notifications-in-ios-10/
 
 https://learnappmaking.com/random-unique-identifier-uuid-swift-how-to/
 */

import UIKit
import CoreData
import UserNotifications

class SetReminderViewController: UIViewController{
    
    
    var hour: String = ""
    var minute: String = ""
    var second: String = "0"
    
    var selectedMed: Medicine?
    
    //stores all fetched reminders
    var allReminders = [MedReminder]()
    var relatedMed = [MedReminder]()
    var found: Bool = false
    
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    //for accessing coredata
    var managedObjectContext: NSManagedObjectContext?
    
    //declaring helper object for manipulating plist
    var plistHelper = PListHelper()
    
    //coredata initialization
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //the time picker stuff
        timePicker?.datePickerMode = .time
        timePicker?.addTarget(self, action: #selector(timeChanged(timePicker: )), for: .valueChanged)
        
        let today = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        hour = dateFormatter.string(from: today)
        dateFormatter.dateFormat = "mm"
        minute = dateFormatter.string(from: today)
        dateFormatter.dateFormat =  "HH:mm"
    
        let timeString = dateFormatter.string(from: today)
        let date = dateFormatter.date(from: timeString)
        
        
        
        timePicker.date = date!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAllReminders()
    }
    
    func fetchAllReminders(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MedReminder")
        do{
            allReminders = (try (managedObjectContext?.fetch(fetchRequest) as? [MedReminder]))!
            
            for each in allReminders{
                if each.forMed?.name == selectedMed?.name{
                    relatedMed.append(each)
                }
            }
            
            
        }
        catch{
            fatalError("Failed to fetch actionplans: \(error)")
        }
    }
    
    func checkForSameReminder() -> Bool{
        for each in relatedMed{
            if hour == each.hour && minute == each.minute{
                //if user provided values match one of the already existing reminders
                return true            }
        }
        return false
    }
    
    @objc func timeChanged(timePicker: UIDatePicker){
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH"
        hour = timeFormatter.string(from: timePicker.date)
        timeFormatter.dateFormat = "mm"
        minute = timeFormatter.string(from: timePicker.date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //
    //    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    //         return pickerData.count
    //    }
    //
    //    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    //         return pickerData[component].count
    //    }
    //
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //        return pickerData[component][row]
    //    }
    //
    //    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    //        switch (component){
    //        case 0:
    //            hour = pickerData[component][row]
    //            print(hour)
    //        case 1:
    //            minute = pickerData[component][row]
    //            print(minute)
    //        case 2:
    //            second = pickerData[component][row]
    //            print(second)
    //        default:
    //            break
    //        }
    //    }
    
    
    @IBAction func addReminderOnPress(_ sender: Any) {
        
        if !checkForSameReminder(){
            //creating a new medicine reminder object using the data from the picker
            let newMedReminder = NSEntityDescription.insertNewObject(forEntityName: "MedReminder", into: managedObjectContext!) as! MedReminder
            newMedReminder.hour = hour
            newMedReminder.minute = minute
            newMedReminder.second = second
            
            let firstPart: String = (selectedMed?.isPrescribed?.type)!
            let secondPart: String = (selectedMed?.name)!
            let uniquePart: String = UUID().uuidString
            
            //creating an unique id for the reminder
            let remID = "\(firstPart)_\(secondPart)_\(uniquePart)"
            
            newMedReminder.reminderID = remID
            
            //storing the reminder using appropriate medicine
            selectedMed?.addToHasMed(newMedReminder)
            
            //save changes
            saveData()
            
            /*
             if the current state of the application set by the user matches the state
             of the medicine this new reminder is associated with, then schedule a notification
             for this reminder immediately
             */
            
            let currentMood: String = plistHelper.readPlist(namePlist: "contacts", key: "Mood") as! String
            
            if selectedMed?.isPrescribed?.type == currentMood{
                //schedule right away
                scheduleLocal(medName: (selectedMed?.name)!, medDos: (selectedMed?.dosage)!, h: hour, m: minute, s: second, remID: remID)
            }
            
            //pop back the controlelr
            self.navigationController!.popViewController(animated: true)
        }
        else{
            //display error message
            let alertController = UIAlertController(title: "Alert", message: "A reminder for this time and medicine already exists.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        
    }
    
    //reusable function for core data persistance
    func saveData(){
        do{
            try managedObjectContext?.save()
        }
        catch let error{
            print("could not save to core data: \(error)")
        }
    }
    
    //reusing function for setting notification
    func scheduleLocal(medName: String, medDos: String, h: String, m: String, s: String, remID: String){
        
        let center = UNUserNotificationCenter.current()
        //center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Medicine Reminder for \((plistHelper.readPlist(namePlist: "contacts", key: "Child")["First Name"]!)!)"
        content.body = "Time for \(medName): \(medDos) tablets"
        content.categoryIdentifier = "alarm"
        
        //the date stuff
        var dateComponent = DateComponents()
        dateComponent.hour = Int(h)
        dateComponent.minute = Int(m)
        dateComponent.second = Int(s)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        //time interval for testing
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
        
        let request = UNNotificationRequest(identifier: remID, content: content, trigger: trigger)
        
        center.add(request)
        
    }
    
}

