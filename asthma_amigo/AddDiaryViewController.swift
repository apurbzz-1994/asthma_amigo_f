//
//  AddDiaryViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 27/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

/*
 This was helpful for creating datepickers
 https://www.youtube.com/watch?v=aa-lNWUVY7g
 */

/*Code for implementing Google places is attributed to the following article:
 https://medium.com/@KentaKodashima/ios-google-places-autocomplete-api-e064c683b5a3
 */


import UIKit
import CoreData
import GooglePlaces
import Alamofire
import SwiftyJSON
import UserNotifications


//protocol for passing updated diary data back to the edit screen
protocol addDiaryDelegate{
    func sendDiaryEntryData(location: String, month: String, day: String, time: String, trigger: String, comment: String, temp: String, humidity: String, quality: String)
}

class AddDiaryViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var commentField: UITextView!
    @IBOutlet weak var textCount: UILabel!
    
    
    var delegate: addDiaryDelegate?
    
    //for storing Diary object from the details view that
    //may or may not be edited.
    var diaryForEdit: Diary?
    
    //whether diary is to be edited
    var isEdit: Bool = false
    
    //stores a reference to whichever textfield the user has selected.
    var selectedTextField: UITextField!
    
    var day: String = ""
    var month: String = ""
    var year: String = ""
    
    var hour: String = ""
    var minute: String = ""
    
    //historical values from api
    var lat: String = "---"
    var long: String = "---"
    var temp: String = "---"
    var humidity: String = "---"
    var airQuality: String = "---"
    
    var datePicker: UIDatePicker?
    var timePicker: UIDatePicker?
    
    @IBOutlet var triggerView: UIView!
    
    //trigger image and name after being selected
    @IBOutlet weak var tLabel: UILabel!
    @IBOutlet weak var tImg: UIImageView!
    
    
    @IBOutlet weak var triggerButton: UIButton!
    

    
    //for accessing coredata
    var managedObjectContext: NSManagedObjectContext?
    
    
    //coredata initialization
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.length + range.location > commentField.text.count{
            return false
        }
        
        let newLength = commentField.text.count + text.count - range.length
        
        return newLength <= 200
    }
    
    func checkRemainingCharacters(){
        let allowed = 200
        let remaining = allowed - commentField.text.count
        textCount.text = "Count: \(remaining)"
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkRemainingCharacters()
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationField.delegate = self
        dateField.delegate = self
        timeField.delegate = self
        commentField.delegate = self
        
        commentField.layer.borderWidth = 1
        commentField.layer.cornerRadius = 10
        commentField.tintColor = UIColor.black
        
        //listeners for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //if a diary object is received from the edit button
        if isEdit{
            tLabel.alpha = 1
            tImg.alpha = 1
            
            locationField.text = diaryForEdit?.location
            dateField.text = "\((diaryForEdit?.day)!)/\((diaryForEdit?.month)!)/\((diaryForEdit?.year)!)"
            timeField.text = "\((diaryForEdit?.hour)!):\((diaryForEdit?.minute)!)"
            commentField.text = diaryForEdit?.comments
            tLabel.text = diaryForEdit?.trigger
            
            day = (diaryForEdit?.day)!
            month = (diaryForEdit?.month)!
            year = (diaryForEdit?.year)!
            
            hour = (diaryForEdit?.hour)!
            minute = (diaryForEdit?.minute)!
            
            
            if diaryForEdit?.trigger == "Pet"{
                tImg.image = UIImage(named: "icons8-dog-96")
            }
            else if diaryForEdit?.trigger == "Bugs"{
                tImg.image = UIImage(named: "icons8-insect-96")
            }
            else if diaryForEdit?.trigger == "Pollen"{
                tImg.image = UIImage(named: "icons8-orchid-96")
            }
            else if diaryForEdit?.trigger == "Allergies"{
                tImg.image = UIImage(named: "icons8-vegetarian-food-96")
            }
            else if diaryForEdit?.trigger == "Exercise"{
                tImg.image = UIImage(named: "icons8-vegetarian-pullups-96")
            }
            else if diaryForEdit?.trigger == "Weather"{
                tImg.image = UIImage(named: "icons8-vegetarian-winter-96")
            }
            else{
                tImg.image = UIImage(named: "icons8-box-important-48")
            }
            
            //hide the trigger view
            triggerView.alpha = 0
            
            let todayDate = Date()
            //28 days from today
            let lastDate = Calendar.current.date(byAdding: .day, value: -28, to: todayDate)

            
            // Do any additional setup after loading the view.
            datePicker = UIDatePicker()
            datePicker?.datePickerMode = .date
            datePicker?.addTarget(self, action: #selector(dateChanged(datePicker: )), for: .valueChanged)
            datePicker?.minimumDate = lastDate
            datePicker?.maximumDate = todayDate
            
            //the time picker stuff
            timePicker = UIDatePicker()
            timePicker?.datePickerMode = .time
            timePicker?.addTarget(self, action: #selector(timeChanged(timePicker: )), for: .valueChanged)
            
            
            //adding gesture to dismiss pickers
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer: )))
            
            view.addGestureRecognizer(tapGesture)
            
            dateField.inputView = datePicker
            timeField.inputView = timePicker
            
        }
        else{
            //set currrent date and time as default
            let todayDate = Date()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            year = dateFormatter.string(from: todayDate)
            dateFormatter.dateFormat = "MM"
            month = dateFormatter.string(from: todayDate)
            dateFormatter.dateFormat = "dd"
            day = dateFormatter.string(from: todayDate)
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateField.text = dateFormatter.string(from: todayDate)
            
            dateFormatter.dateFormat = "hh"
            hour = dateFormatter.string(from: todayDate)
            dateFormatter.dateFormat = "mm"
            minute = dateFormatter.string(from: todayDate)
            dateFormatter.dateFormat = "h:mm a"
            timeField.text = dateFormatter.string(from: todayDate)
            //------------------------Setting default values complete-----------------
            
            //hide the trigger view
            triggerView.alpha = 0
            tLabel.alpha = 0
            tImg.alpha = 0
            
            //28 days from today
            let lastDate = Calendar.current.date(byAdding: .day, value: -28, to: todayDate)
            
            
            // Do any additional setup after loading the view.
            datePicker = UIDatePicker()
            datePicker?.datePickerMode = .date
            datePicker?.addTarget(self, action: #selector(dateChanged(datePicker: )), for: .valueChanged)
            datePicker?.minimumDate = lastDate
            datePicker?.maximumDate = todayDate
            
            //the time picker stuff
            timePicker = UIDatePicker()
            timePicker?.datePickerMode = .time
            timePicker?.addTarget(self, action: #selector(timeChanged(timePicker: )), for: .valueChanged)
            
            
            //adding gesture to dismiss pickers
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer: )))
            
            view.addGestureRecognizer(tapGesture)
            
            dateField.inputView = datePicker
            timeField.inputView = timePicker
        }
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func keyboardShow(notification: Notification){
        let info:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        
        let editingTextFieldY:CGFloat = (self.selectedTextField?.frame.origin.y)!
        
        if self.view.frame.origin.y >= 0 {
            //Checking if the textfield is really hidden behind the keyboard
            if editingTextFieldY > keyboardY - 90 {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY - (keyboardY - 90)), width: self.view.bounds.width,height: self.view.bounds.height)
                }, completion: nil)
            }
        }
    }
    
    //when the keyboard gets hidden, the whole view needs to move to its original axis.
    @objc func keyboardHide(notification: Notification){
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            //move the view to origin
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //remove observers
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //lets you know which textfield the user is working on
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
    }
    
    //this makes the keyboard disappear when the return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        year = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "MM"
        month = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "dd"
        day = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func timeChanged(timePicker: UIDatePicker){
        //Restriction code
        //===========================================>
        let todayDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let y = dateFormatter.string(from: todayDate)
        dateFormatter.dateFormat = "MM"
        let m = dateFormatter.string(from: todayDate)
        dateFormatter.dateFormat = "dd"
        let d = dateFormatter.string(from: todayDate)
        
        if day == d && month == m && year == y{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "HH:mm"
            
            let min = dateFormatter.date(from: "00:00")
            let max = dateFormatter.date(from: "01:00")
            
            timePicker.minimumDate = min
            timePicker.maximumDate = max
        }
        else{
            let min = dateFormatter.date(from: "00:00")
            let max = dateFormatter.date(from: "23:00")
            
            timePicker.minimumDate = min
            timePicker.maximumDate = max
        }
        //=================================================>
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh"
        hour = timeFormatter.string(from: timePicker.date)
        timeFormatter.dateFormat = "mm"
        minute = timeFormatter.string(from: timePicker.date)
        timeFormatter.dateFormat = "h:mm a"
        timeField.text = timeFormatter.string(from: timePicker.date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Disply autocomplete via Google Places when location field is tapped.
    @IBAction func whenLocationFieldIsTapped(_ sender: Any) {
        locationField.resignFirstResponder()
        
        //create a new view controller for displaying autocomplete view
        let autoCompleteController = GMSAutocompleteViewController()
        
        //setting filter to australia only--------------
        let filter = GMSAutocompleteFilter()
        filter.country = "AU"
        
        autoCompleteController.autocompleteFilter = filter
        //------------------------------------------------
        autoCompleteController.delegate = self

        //present the controller on tap
        present(autoCompleteController, animated: true, completion: nil)
        
    }
    
    //function for save button
    @IBAction func saveDiaryOnPress(_ sender: Any) {
        print(day)
        print(month)
        print(year)
        print(hour)
        print(minute)
        
        if isEdit{
            //date for user
            let diary_date = "\(self.year)-\(self.month)-\(self.day)"
            
            if self.lat == "---" || self.long == "---"{
                //this indicates that user has not changed the location on edit
                self.lat = (diaryForEdit?.lat)!
                self.long = (diaryForEdit?.long)!
            }
            
            //api_url
            let API_URL = "http://142.93.120.204/plumber/history?lat=\(self.lat)&lon=\(self.long)&Date=\(diary_date)&Time=\(self.hour)"
            print(API_URL)
            
            //fetch historical values via http
            downloadHistoricalWeather(api_url: API_URL) {
                //here, location is being assumed to be unique for now.
                //Rememeber to think of a proper key for each entry.
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Diary")
                fetchRequest.predicate = NSPredicate(format: "location = %@", (self.diaryForEdit?.location)!)
                do{
                    let test = try self.managedObjectContext?.fetch(fetchRequest)
                    
                    let objectUpdate = test![0] as! NSManagedObject
                    objectUpdate.setValue(self.self.commentField.text, forKey: "comments")
                    objectUpdate.setValue(self.day, forKey: "day")
                    objectUpdate.setValue(self.month, forKey: "month")
                    objectUpdate.setValue(self.year, forKey: "year")
                    objectUpdate.setValue(self.hour, forKey: "hour")
                    objectUpdate.setValue(self.minute, forKey: "minute")
                    objectUpdate.setValue(self.locationField.text, forKey: "location")
                    objectUpdate.setValue(self.tLabel.text, forKey: "trigger")
                    objectUpdate.setValue(self.temp, forKey: "temp")
                    objectUpdate.setValue(self.airQuality, forKey: "quality")
                    objectUpdate.setValue(self.humidity, forKey: "humidity")
                    do{
                        try self.managedObjectContext?.save()
                    }
                    catch{
                        print(error)
                    }
                }
                catch{
                    print(error)
                }
            
                
                //send data back to edit screen via delegation
                self.delegate?.sendDiaryEntryData(location: self.locationField.text!, month: self.month, day: self.day, time: "\(self.hour):\(self.minute)", trigger: self.tLabel.text!, comment: self.commentField.text, temp: self.temp, humidity: self.humidity, quality: self.airQuality)
                
                
                self.navigationController!.popViewController(animated: true)
                //self.performSegue(withIdentifier: "backToDiaryListSegue", sender: nil)
                
            }
        }
        else{
            
            //mandatory fields
            if locationField.text != "" && timeField.text != "" && dateField.text != ""{
                //date for user
                let diary_date = "\(self.year)-\(self.month)-\(self.day)"
                
                //api_url
                let API_URL = "http://142.93.120.204/plumber/history?lat=\(self.lat)&lon=\(self.long)&Date=\(diary_date)&Time=\(self.hour)"
                print(API_URL)
                
                //fetch historical values via http
                downloadHistoricalWeather(api_url: API_URL) {
                    //create a diary object once download is complete
                    
                    let newD = self.createManagedDiary(comments: self.commentField.text, day: self.day, month: self.month, year: self.year, hour: self.hour, minute: self.minute, location: self.locationField.text!, trigger: self.tLabel.text!, lat: self.lat, long: self.long, temp: self.temp, humidity: self.humidity, quality: self.airQuality)
                    
                    self.generateWarning(d: newD)
                    
                    //save to persistent memory
                    self.saveData()
                    
                    //add here
                
                    
                    self.navigationController!.popViewController(animated: true)
                }
            }
            else{
                var errorMessage: String = "Following errors with form: \n"
                
                //validating both fields individually
                if(locationField.text == ""){
                    errorMessage.append("You must specify a location for creating a diary \n")
                }
                if(dateField.text == ""){
                    errorMessage.append("Please specify a date for diary. \n")
                }
                if(timeField.text == ""){
                    errorMessage.append("Please specify time for diary.")
                }
            
                //display error message
                let alertController = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
            }
            
  
        }
        
    }
    //Alert generation for expo
    //============================================================>
    func generateWarning(d: Diary){
            
            //dummy api
            let API_URL = "http://142.93.120.204/plumber/DummyDataWeather?lat=\((d.lat)!)&lon=\((d.long)!)&hu=\((d.humidity)!)&temp=\((d.temp)!)&aqi=\((d.quality)!)&unit=2"
            
            //real api
            //let API_URL = "http://142.93.120.204/plumber/weather?lat=\((eachEntry.lat)!)&lon=\((eachEntry.long)!)&hu=\((eachEntry.humidity)!)&temp=\((eachEntry.temp)!)&aqi=\((eachEntry.quality)!)&unit=\((thresholdLabel.text)!)"
            
            //Check if any optionals are presiding
            print(API_URL)
            
            
            downloadWarnings(api_url: API_URL, entry: d){
                //notification scheduling goes here.
                self.scheduleLocalForAlerts()
            }
    
        //save all data
        saveData()
    }
    
    //function for fetching historical data for diary entry
    func downloadWarnings(api_url: String, entry: Diary, completed: @escaping DownloadComplete){
        Alamofire.request(api_url).responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(let value):
                //print(value)
                let json = JSON(value)
                
                //the API sends a sorted list of alerts based on dates. Hence, selecting only the
                //first one selects the one which is closest to todays date.
                if json[0].count >= 1{
                    //if some form of alert is there for a given diary entry
                    
                    entry.addToHasAlert( self.createManagedAlert(humidity: json[0][1]["Humidity"].stringValue, temperature: json[0][1]["Temperature"].stringValue, dateAndTime: json[0][1]["DateTime"].stringValue, qualityAir: json[0][1]["AQI"].stringValue, isSeen: false))
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            DispatchQueue.main.async{
                completed ()
                
            }
        }
    }
    
    
    //reusing function for setting notification
    func scheduleLocalForAlerts(){
        
        let center = UNUserNotificationCenter.current()
        //center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "You have a new weather alert."
        content.body = "Please tap to view more information."
        content.categoryIdentifier = "alarm"
        
        //the date stuff
        var dateComponent = DateComponents()
        dateComponent.hour = 10
        dateComponent.minute = 0
        dateComponent.second = 0
        
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        //time interval for testing
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: false)
        
        let firstPart: String = "weather"
        let uniquePart: String = UUID().uuidString
        
        //creating an unique id for the reminder
        let remID = "\(firstPart)_\(uniquePart)"
        
        let request = UNNotificationRequest(identifier: remID, content: content, trigger: trigger)
        
        center.add(request)
        
    }
    
    
    //function for creating managed weather alert objects to be stored to database
    func createManagedAlert(humidity: String, temperature: String, dateAndTime: String, qualityAir: String, isSeen: Bool) -> WeatherAlert {
        let alert = NSEntityDescription.insertNewObject(forEntityName: "WeatherAlert", into: managedObjectContext!) as! WeatherAlert
        alert.humidity = humidity
        alert.temperature = temperature
        alert.dateAndTime = dateAndTime
        alert.qualityAir = qualityAir
        alert.isSeen = isSeen
        
        return alert
    }
    
    //============================================================>
    
    
    
    
    //function for creating managed diary objects to be stored to database
    func createManagedDiary(comments: String, day: String, month: String, year: String, hour: String, minute: String,
                            location: String, trigger: String, lat: String, long: String, temp: String, humidity: String, quality: String) -> Diary {
        let plan = NSEntityDescription.insertNewObject(forEntityName: "Diary", into: managedObjectContext!) as! Diary
        plan.comments = comments
        plan.day = day
        plan.month = month
        plan.year = year
        plan.hour = hour
        plan.minute = minute
        plan.location = location
        plan.trigger = trigger
        plan.lat = lat
        plan.long = long
        plan.temp = temp
        plan.humidity = humidity
        plan.quality = quality
        
        return plan
    }
    
    //function for fetching historical data for diary entry
    func downloadHistoricalWeather(api_url: String, completed: @escaping DownloadComplete){
        Alamofire.request(api_url).responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(let value):
                print(value)
                let json = JSON(value)
                
                //check for empty stuff
                if json["temperature"] == JSON.null || json["humidity"] == JSON.null || json["AQI"] == JSON.null{
                    //set default values
                    if json["temperature"] == JSON.null{
                        self.temp = "0"
                    }
                    if json["humidity"] == JSON.null{
                        self.humidity = "0"
                    }
                    if json["AQI"] == JSON.null{
                        self.airQuality = "0"
                    }
                }
                else{
                    let roundedTemp: Double = json["temperature"].double!
                    
                    self.temp = String(Int(roundedTemp))
                    print(self.temp)
                    self.humidity = json["humidity"].stringValue
                    print(self.humidity)
                    self.airQuality = json["AQI"].stringValue
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            DispatchQueue.main.async{
                completed ()
                
            }
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
    
    
    
    
    //function for add trigger button
    @IBAction func addTriggerOnPress(_ sender: Any) {
        //make this visible
        
        UIView.animate(withDuration: 0.8, animations: {
            self.addShadow(card: self.triggerView)
            self.triggerView.alpha = 1
        })
        
    }
    
    
    
    
    //trigger buttons
    @IBAction func petTrigger(_ sender: Any) {
        
        UIView.animate(withDuration: 0.8, animations: {
            //trigger view disappears
            self.triggerView.alpha = 0
        })
        
        tLabel.alpha = 1
        tImg.alpha = 1
        
        //trigger name changed to selected trigger
        tLabel.text = "Pet"
        
        //picture changed appropriately
        tImg.image = UIImage(named: "icons8-dog-96")
        
    }
    
    @IBAction func bugTrigger(_ sender: Any) {
        UIView.animate(withDuration: 0.8, animations: {
            //trigger view disappears
            self.triggerView.alpha = 0
        })
        
        tLabel.alpha = 1
        tImg.alpha = 1
        
        //trigger name changed to selected trigger
        tLabel.text = "Bugs"
        
        //picture changed appropriately
        tImg.image = UIImage(named: "icons8-insect-96")
    }
    
    @IBAction func pollenTrigger(_ sender: Any) {
        UIView.animate(withDuration: 0.8, animations: {
            //trigger view disappears
            self.triggerView.alpha = 0
        })
        
        tLabel.alpha = 1
        tImg.alpha = 1
        
        //trigger name changed to selected trigger
        tLabel.text = "Pollen"
        
        //picture changed appropriately
        tImg.image = UIImage(named: "icons8-orchid-96")
        
    }
    
    @IBAction func allergyTrigger(_ sender: Any) {
        UIView.animate(withDuration: 0.8, animations: {
            //trigger view disappears
            self.triggerView.alpha = 0
        })
        
        tLabel.alpha = 1
        tImg.alpha = 1
        
        //trigger name changed to selected trigger
        tLabel.text = "Allergies"
        
        //picture changed appropriately
        tImg.image = UIImage(named: "icons8-vegetarian-food-96")
        
    }
    
    @IBAction func exerciseTrigger(_ sender: Any) {
        UIView.animate(withDuration: 0.8, animations: {
            //trigger view disappears
            self.triggerView.alpha = 0
        })
        
        tLabel.alpha = 1
        tImg.alpha = 1
        
        //trigger name changed to selected trigger
        tLabel.text = "Exercise"
        
        //picture changed appropriately
        tImg.image = UIImage(named: "icons8-pullups-96")
        
    }
    
    @IBAction func weatherTrigger(_ sender: Any) {
        UIView.animate(withDuration: 0.8, animations: {
            //trigger view disappears
            self.triggerView.alpha = 0
        })
        
        tLabel.alpha = 1
        tImg.alpha = 1
        
        //trigger name changed to selected trigger
        tLabel.text = "Weather"
        
        //picture changed appropriately
        tImg.image = UIImage(named: "icons8-winter-96")
    }
    
    
    
    //action for cancel button on the triggers popup
    @IBAction func cancelOnPress(_ sender: Any) {
        UIView.animate(withDuration: 0.8, animations: {
            //trigger view disappears
            self.triggerView.alpha = 0
        })
    }
    
    
    
    
    //reusing function from DashBoardViewController
    func addShadow(card: UIView){
        card.layer.cornerRadius = 8.0
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = .zero
        card.layer.shadowOpacity = 0.6
        card.layer.shadowRadius = 8.0
        card.layer.shadowPath = UIBezierPath(rect: card.bounds).cgPath
        card.layer.shouldRasterize = true
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

extension AddDiaryViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        locationField.text = place.formattedAddress
        
        //set the lat long values here
        self.lat = place.coordinate.latitude.description
        self.long = place.coordinate.longitude.description
        
        
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}

