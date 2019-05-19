//
//  DashBoardViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 18/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

//

import UIKit
import CoreData
import UserNotifications
import CoreLocation
import SwiftyJSON
import Alamofire

class DashBoardViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var moodCard: UIView!
    @IBOutlet weak var kidLabel: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    
    
    @IBOutlet weak var selectedHappy: UIImageView!
    @IBOutlet weak var selectedSad: UIImageView!
    
    @IBOutlet weak var selectedCry: UIImageView!
    @IBOutlet weak var editButtonLabel: UIButton!
    
    //button labels
    @IBOutlet weak var happyButtonLabel: UIButton!
    @IBOutlet weak var sadButtonLabel: UIButton!
    @IBOutlet weak var cryButtonLabel: UIButton!
    
    //button cards
    @IBOutlet weak var happyBCard: UIView!
    @IBOutlet weak var sadBCard: UIView!
    @IBOutlet weak var cryBCard: UIView!
    
    //button card text labels
    @IBOutlet weak var wellCardLabel: UILabel!
    @IBOutlet weak var sadCardLabel: UILabel!
    @IBOutlet weak var cryCardLabel: UILabel!
    
    //"please select health status" label
    @IBOutlet weak var selectInstructionLabel: UILabel!
    
    
    
    //cards
    @IBOutlet weak var tempCard: UIView!
    @IBOutlet weak var humidityCard: UIView!
    @IBOutlet weak var airQualityCard: UIView!
    @IBOutlet weak var overallCard: UIView!
    
    
    //temperature
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherPic: UIImageView!
    @IBOutlet weak var tempValueLabel: UILabel!
    @IBOutlet weak var weatherData: UILabel!
    
    //humidity
    @IBOutlet weak var humidityPic: UIImageView!
    @IBOutlet weak var humidityValue: UILabel!
    
    //air quality
    @IBOutlet weak var airQualityLabel: UILabel!
    
    //Overall
    @IBOutlet weak var overallLabel: UILabel!
    
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var overallPic: UIImageView!
    
    @IBOutlet weak var setLocationButton: UIButton!
    
    //diary entries for alerts
     var allDiary = [Diary]()
    
    var access: Bool = false
    
    
    
    //constants
    let locationManager = CLLocationManager()
    //variables
    var currentWeather: CurrentWeather!
    var currentLocation: CLLocation?

    //for accessing coredata
    var managedObjectContext: NSManagedObjectContext?
    
    //coredata initialization
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    

    //declaring helper object for manipulating plist
    var plistHelper = PListHelper()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.navigationBar.barTintColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
        //navigationController?.navigationBar.backgroundColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
        
        //adding shadow to each card
        addShadow(card: happyBCard)
        addShadow(card: sadBCard)
        addShadow(card: cryBCard)
        
        callDelegates()
        currentWeather = CurrentWeather()
        
//        if CLLocationManager.authorizationStatus() == .notDetermined {
//            locationManager.requestWhenInUseAuthorization()
//        }
//
        
        setupLocation()
        

        // Do any additional setup after loading the view.
    }
    
//    private func locationManager(manager: CLLocationManager!,
//                         didChangeAuthorizationStatus status: CLAuthorizationStatus)
//    {
//        if status == .authorizedAlways || status == .authorizedWhenInUse {
//            //locationManager.startUpdatingLocation()
//            locationAuthCheck()
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        //moodLabel.text = "Health: \((plistHelper.readPlist(namePlist: "contacts", key: "Mood")))"
        
        
        //for removing navigation bar
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        //only after user has accepted
//        if access{
//            locationAuthCheck()
//        }
        
        
        
        configureMoodCard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //check for alerts
        checkForAlertsEveryDay()
        
        let status = CLLocationManager.authorizationStatus()
        
        if(status == .authorizedWhenInUse || status == .authorizedAlways){
            locationAuthCheck()
        }
        else{
            locationManager.requestAlwaysAuthorization()
        }
        
    }
    
    func checkForUserAuth(){
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                locationManager.requestWhenInUseAuthorization() // Take Permission from the user
                print(CLLocationManager.authorizationStatus())
                checkForUserAuth()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                locationAuthCheck()
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    
    func callDelegates(){
        locationManager.delegate = self
    }
    func setupLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization() // Take Permission from the user
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    /// This function updates the Current weather UI in our App.
    func updateUI() {
        //cityNameLabel.text = plistHelper.readPlist(namePlist: "contacts", key: "address") as! String
        cityNameLabel.text = currentWeather.cityName
        tempValueLabel.text = "\(Int(currentWeather.currentTemp)) ℃"
        weatherData.text = currentWeather.weatherType
        humidityValue.text = currentWeather.humidityVal
        airQualityLabel.text = currentWeather.airQuality
        //adjusting for new values [iteration 3 revision]
        if currentWeather.summary == "GOOD"{
            overallLabel.text = "LOW"
            overallPic.image = UIImage(named: "icons8-green-flag-96")
        }
        if currentWeather.summary == "FAIR"{
            overallLabel.text = "MEDIUM"
            overallPic.image = UIImage(named: "icons8-flag-filled-80")
        }
        if currentWeather.summary == "POOR"{
            overallLabel.text = "HIGH"
            overallPic.image = UIImage(named: "icons8-flag-filled-96")
        }
        //overallLabel.text = currentWeather.summary
        weatherPic.image = UIImage(named: currentWeather.icon)
    }
    
    //Here we are checking the location authentication status
    func locationAuthCheck() {
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//            // Get the location from the device
//            //locationManager.startUpdatingLocation()
//            //currentLocation = locationManager.location
//
//            // Pass the location coord to our API
//            //Location.sharedInstance.latitude = currentLocation?.coordinate.latitude
//            //Location.sharedInstance.longitude = currentLocation?.coordinate.longitude
//
//            Location.sharedInstance.latitude = -37.87255
//            Location.sharedInstance.longitude = 145.02262
//
//
//            // Download the API Data
//            currentWeather.downloadCurrentWeather {
//                // Update the UI after download is completed.
//                self.updateUI()
//            }
//        }else {
//            //user did not allow
//            locationManager.requestWhenInUseAuthorization()//take permission from the user
//            locationAuthCheck()//Make a check
//        }
        // Get the location from the device
        //locationManager.startUpdatingLocation()
        //currentLocation = locationManager.location
        
        // Pass the location coord to our API
        //Location.sharedInstance.latitude = currentLocation?.coordinate.latitude
        //Location.sharedInstance.longitude = currentLocation?.coordinate.longitude
        
        let stateLoc = plistHelper.readPlist(namePlist: "contacts", key: "isChildWithMe")
        
        
        
        let API_URL: String?
        
        if stateLoc as! String == "y"{
            
             //Get the location from the device
            
//            if CLLocationManager.locationServicesEnabled(){
//                locationManager.startUpdatingLocation()
//            }
            
            
            //set to caulfield if application fails :(
            //let lat = -37.8760
            //let long = 145.0440
            
            locationManager.startUpdatingLocation()
            currentLocation = locationManager.location
            
            let lat = currentLocation?.coordinate.latitude
            let long = currentLocation?.coordinate.longitude
            
            if lat == nil || long == nil{
                API_URL = "http://142.93.120.204/plumber/Json?lat=-37.8760&lon=145.0440"
                print(API_URL!)
            }
            else{
                API_URL = "http://142.93.120.204/plumber/Json?lat=\(lat!)&lon=\(long!)"
                print(API_URL!)
            }
            
        }
        else{
            let lat = plistHelper.readPlist(namePlist: "contacts", key: "lat")
            let long = plistHelper.readPlist(namePlist: "contacts", key: "long")
            
            API_URL = "http://142.93.120.204/plumber/Json?lat=\(lat)&lon=\(long)"
            print(API_URL!)
        }
        
        
        // Download the API Data
        currentWeather.downloadCurrentWeather(api_url: API_URL!) {
            // Update the UI after download is completed.
            self.updateUI()
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        currentLocation = (locations[locations.count-1] as! CLLocation)
        
        print("locations = \(currentLocation)")
        // lbl1.text = "\(currentLocation.coordinate.latitude)";
        // lbl2.text = "\(currentLocation.coordinate.longitude)";
    }
    
    
    
    //function for configuring the state of the mood card based on health status
    func configureMoodCard(){
        let mood = plistHelper.readPlist(namePlist: "contacts", key: "Mood")
        
        if mood as! String == "Not set"{
            //let the user select a mood
            selectedHappy.alpha = 0
            selectedSad.alpha = 0
            selectedCry.alpha = 0
            editButtonLabel.alpha = 0
            moodLabel.alpha = 0
            instructionLabel.alpha = 0
            
            kidLabel.alpha = 1
            happyButtonLabel.alpha = 1
            sadButtonLabel.alpha = 1
            cryButtonLabel.alpha = 1
            happyBCard.alpha = 1
            sadBCard.alpha = 1
            cryBCard.alpha = 1
            wellCardLabel.alpha = 1
            sadCardLabel.alpha = 1
            cryCardLabel.alpha = 1
            selectInstructionLabel.alpha = 1
            
            kidLabel.text = "How is \((plistHelper.readPlist(namePlist: "contacts", key: "Child")["First Name"]!)!) feeling today?"
            
        }
        if mood as! String == "Well"{
            kidLabel.alpha = 0
            happyButtonLabel.alpha = 0
            sadButtonLabel.alpha = 0
            cryButtonLabel.alpha = 0
            selectedSad.alpha = 0
            selectedCry.alpha = 0
            happyBCard.alpha = 0
            sadBCard.alpha = 0
            cryBCard.alpha = 0
            wellCardLabel.alpha = 0
            sadCardLabel.alpha = 0
            cryCardLabel.alpha = 0
            selectInstructionLabel.alpha = 0
            
            selectedHappy.alpha = 1
            moodLabel.alpha = 1
            editButtonLabel.alpha = 1
            
            moodLabel.text = "Health: \((plistHelper.readPlist(namePlist: "contacts", key: "Mood")))"
            instructionLabel.alpha = 1
        }
        if mood as! String == "Not Well"{
            kidLabel.alpha = 0
            happyButtonLabel.alpha = 0
            sadButtonLabel.alpha = 0
            cryButtonLabel.alpha = 0
            selectedHappy.alpha = 0
            selectedCry.alpha = 0
            happyBCard.alpha = 0
            sadBCard.alpha = 0
            cryBCard.alpha = 0
            wellCardLabel.alpha = 0
            sadCardLabel.alpha = 0
            cryCardLabel.alpha = 0
            selectInstructionLabel.alpha = 0
            
            selectedSad.alpha = 1
            moodLabel.alpha = 1
            editButtonLabel.alpha = 1
            
            moodLabel.text = "Health: \((plistHelper.readPlist(namePlist: "contacts", key: "Mood")))"
            instructionLabel.alpha = 1
        }
        if mood as! String == "Worse"{
            kidLabel.alpha = 0
            happyButtonLabel.alpha = 0
            sadButtonLabel.alpha = 0
            cryButtonLabel.alpha = 0
            selectedSad.alpha = 0
            selectedHappy.alpha = 0
            happyBCard.alpha = 0
            sadBCard.alpha = 0
            cryBCard.alpha = 0
            wellCardLabel.alpha = 0
            sadCardLabel.alpha = 0
            cryCardLabel.alpha = 0
            selectInstructionLabel.alpha = 0
            
            selectedCry.alpha = 1
            moodLabel.alpha = 1
            editButtonLabel.alpha = 1
            
            moodLabel.text = "Health: \((plistHelper.readPlist(namePlist: "contacts", key: "Mood")))"
            instructionLabel.alpha = 1
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func selectedHappy(_ sender: Any) {
        //change flag:
        plistHelper.writePlist(namePlist: "contacts", key: "Mood", data: "Well" as AnyObject)
        
        //adjust reminders
        setMedReminders(state: "Well")
        
        //initial bounds
        let initBounds = selectedHappy.bounds
        
        UIView.animate(withDuration: 0.5, animations: {
            self.kidLabel.alpha = 0
            self.happyButtonLabel.alpha = 0
            self.sadButtonLabel.alpha = 0
            self.cryButtonLabel.alpha = 0
            self.selectedSad.alpha = 0
            self.selectedCry.alpha = 0
            self.happyBCard.alpha = 0
            self.sadBCard.alpha = 0
            self.cryBCard.alpha = 0
            self.wellCardLabel.alpha = 0
            self.sadCardLabel.alpha = 0
            self.cryCardLabel.alpha = 0
            self.selectInstructionLabel.alpha = 0
        }) { (true) in
//            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
//                self.selectedHappy.alpha = 1
//                self.moodLabel.alpha = 1
//                self.editButtonLabel.alpha = 1
//            }, completion: nil)
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                self.selectedHappy.alpha = 1
                self.moodLabel.alpha = 1
                //self.editButtonLabel.alpha = 1
                
                self.selectedHappy.bounds = CGRect(x: self.selectedHappy.bounds.origin.x, y: self.selectedHappy.bounds.origin.y, width: self.selectedHappy.bounds.size.width + 20, height: self.selectedHappy.bounds.height + 20)
                
            }, completion: { (true) in
                //set to original bounds
                UIView.animate(withDuration: 0.3, animations: {
                    self.selectedHappy.bounds = initBounds
                    self.editButtonLabel.alpha = 1
                    self.instructionLabel.alpha = 1
                })
            })
            
            
        }
        
        moodLabel.text = "Health: Well"
    }
    
    
    @IBAction func selectedSad(_ sender: Any) {
        //change flag:
        plistHelper.writePlist(namePlist: "contacts", key: "Mood", data: "Not Well" as AnyObject)
        
        //initial bounds
        let initBounds = selectedSad.bounds
        
        //adjust reminders
        setMedReminders(state: "Not Well")
        
        UIView.animate(withDuration: 0.5, animations: {
            self.kidLabel.alpha = 0
            self.happyButtonLabel.alpha = 0
            self.sadButtonLabel.alpha = 0
            self.cryButtonLabel.alpha = 0
            self.selectedHappy.alpha = 0
            self.selectedCry.alpha = 0
            self.happyBCard.alpha = 0
            self.sadBCard.alpha = 0
            self.cryBCard.alpha = 0
            self.wellCardLabel.alpha = 0
            self.sadCardLabel.alpha = 0
            self.cryCardLabel.alpha = 0
            self.selectInstructionLabel.alpha = 0
            
        }) { (true) in
//            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
//                self.selectedHappy.alpha = 1
//                self.moodLabel.alpha = 1
//                self.editButtonLabel.alpha = 1
//            }, completion: nil)
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                self.selectedSad.alpha = 1
                self.moodLabel.alpha = 1
                //self.editButtonLabel.alpha = 1
                
                self.selectedSad.bounds = CGRect(x: self.selectedSad.bounds.origin.x, y: self.selectedSad.bounds.origin.y, width: self.selectedSad.bounds.size.width + 20, height: self.selectedSad.bounds.height + 20)
                
            }, completion: { (true) in
                //set to original bounds
                UIView.animate(withDuration: 0.3, animations: {
                    self.selectedSad.bounds = initBounds
                    self.editButtonLabel.alpha = 1
                    self.instructionLabel.alpha = 1
                })
            })
        }

        moodLabel.text = "Health: Not Well"
    }
    
    @IBAction func selectedCry(_ sender: Any) {
        //change flag:
        plistHelper.writePlist(namePlist: "contacts", key: "Mood", data: "Worse" as AnyObject)
        
        //adjust reminders
        setMedReminders(state: "Worse")
        
        //initial bounds
        let initBounds = selectedCry.bounds
        
        UIView.animate(withDuration: 0.5, animations: {
            self.kidLabel.alpha = 0
            self.happyButtonLabel.alpha = 0
            self.sadButtonLabel.alpha = 0
            self.cryButtonLabel.alpha = 0
            self.selectedHappy.alpha = 0
            self.selectedSad.alpha = 0
            self.happyBCard.alpha = 0
            self.sadBCard.alpha = 0
            self.cryBCard.alpha = 0
            self.wellCardLabel.alpha = 0
            self.sadCardLabel.alpha = 0
            self.cryCardLabel.alpha = 0
            self.selectInstructionLabel.alpha = 0
        }) { (true) in
//            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
//                self.selectedCry.alpha = 1
//                self.moodLabel.alpha = 1
//                self.editButtonLabel.alpha = 1
//            }, completion: nil)
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                self.selectedCry.alpha = 1
                self.moodLabel.alpha = 1
                //self.editButtonLabel.alpha = 1
                
                self.selectedCry.bounds = CGRect(x: self.selectedCry.bounds.origin.x, y: self.selectedCry.bounds.origin.y, width: self.selectedCry.bounds.size.width + 20, height: self.selectedSad.bounds.height + 20)
                
            }, completion: { (true) in
                //set to original bounds
                UIView.animate(withDuration: 0.3, animations: {
                    self.selectedCry.bounds = initBounds
                    self.editButtonLabel.alpha = 1
                    self.instructionLabel.alpha = 1
                })
            })
        }
        

        moodLabel.text = "Health: Worse"
    }
    
    @IBAction func editPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            //let the user select a mood
            self.selectedHappy.alpha = 0
            self.selectedSad.alpha = 0
            self.selectedCry.alpha = 0
            self.editButtonLabel.alpha = 0
            self.moodLabel.alpha = 0
            self.instructionLabel.alpha = 0
            
            self.kidLabel.alpha = 1
            self.happyButtonLabel.alpha = 1
            self.sadButtonLabel.alpha = 1
            self.cryButtonLabel.alpha = 1
            self.happyBCard.alpha = 1
            self.sadBCard.alpha = 1
            self.cryBCard.alpha = 1
            self.wellCardLabel.alpha = 1
            self.sadCardLabel.alpha = 1
            self.cryCardLabel.alpha = 1
            self.selectInstructionLabel.alpha = 1
            
            
            self.kidLabel.text = "How is \((self.plistHelper.readPlist(namePlist: "contacts", key: "Child")["First Name"]!)!) feeling today?"
        }
       
    }
    
    
    func addShadow(card: UIView){
        card.layer.cornerRadius = 8.0
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = .zero
        card.layer.shadowOpacity = 0.6
        card.layer.shadowRadius = 8.0
        card.layer.shadowPath = UIBezierPath(rect: card.bounds).cgPath
        card.layer.shouldRasterize = true
    }
    
    
    //function for checking whether a reminder is on the pending list or not
//    func checkIfPendingOrNot(r: MedReminder) -> Bool{
//        var checkFlag: Bool = false
//        var reminderIDStrings = [String]()
//
//        //load the pending list
//        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {requests -> () in
//            for request in requests{
////                print(request.identifier)
////                print(r.reminderID)
////                if request.identifier == r.reminderID{
////                    checkFlag = true
////                }
//                reminderIDStrings.append(request.identifier)
//            }
//        })
//
//        for each in reminderIDStrings{
//            if each == r.reminderID{
//                checkFlag = true
//            }
//        }
//
//        return checkFlag
//    }
    
    
    /*
     This article helped for handling asynchronous stuff:
     https://stackoverflow.com/questions/45176054/count-pending-local-notifications
     */
    
    
    func checkIfPendingOrNot(r: MedReminder, completed: @escaping (Bool)-> Void = {_ in }) {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests{
                completed(request.identifier == r.reminderID)
            }
        })
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

    
    
    func setMedReminders(state: String){
        //All fetched reminders from persistent memory
        var allReminders = [MedReminder]()
        
        //make a fetch request
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MedReminder")
        do{
            allReminders = (try (managedObjectContext?.fetch(fetchRequest) as? [MedReminder]))!
            
            for eachReminder in allReminders{
                //if reminder state matches current state
                if eachReminder.forMed?.isPrescribed?.type == state{
                    scheduleLocal(medName: (eachReminder.forMed?.name)!, medDos: (eachReminder.forMed?.dosage)!, h: eachReminder.hour!, m: eachReminder.minute!, s: eachReminder.second!, remID: eachReminder.reminderID!)
                }
                else{
                    //if reminder on pending list
//                    if checkIfPendingOrNot(r: eachReminder){
//                       //remove from pending list
//                       UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [eachReminder.reminderID!])
//                    }
                    checkIfPendingOrNot(r: eachReminder){isPending in
                        //remove
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [eachReminder.reminderID!])
                    }
                }
            }
        }
        catch{
            fatalError("Failed to fetch actionplans: \(error)")
        }
        
    }
    
    //checking for alerts
    func checkForAlertsEveryDay(){
        let fetchData = plistHelper.readPlist(namePlist: "contacts", key: "isAlertUpdated") as! String
        
        if fetchData == "no"{
            //it has not been updated yet
            let date = Date()
            let calendar = Calendar.current

            let day = calendar.component(.day, from: date)
            let month = calendar.component(.month, from: date)
            let year = calendar.component(.year, from: date)

            let updateDate = "\(day)-\(month)-\(year)"
            //write to plist
            
            plistHelper.writePlist(namePlist: "contacts", key: "isAlertUpdated", data: updateDate as AnyObject)
            
            //for testing
            //plistHelper.writePlist(namePlist: "contacts", key: "isAlertUpdated", data: "14-05-2019" as AnyObject)
            
        }
        else{
            let date = Date()
            let calendar = Calendar.current
            
            let day = calendar.component(.day, from: date)
            let month = calendar.component(.month, from: date)
            let year = calendar.component(.year, from: date)
            
            let todayDate = "\(day)-\(month)-\(year)"
            
            if fetchData != todayDate{
                //clean any alert object that exceeds today's date
                
                /*update has not been done yet, so do it*/
                fetchDiaryEntries() //fetch all diaries
                
                generateWarning() //add alert objects
                
                
                //set update date to todays date
                plistHelper.writePlist(namePlist: "contacts", key: "isAlertUpdated", data: todayDate as AnyObject)
            }
            
        }
        
    }
    
    /*Helper functions for persistent object in memory*/
    
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
    
    
    //reusable function for core data persistance
    func saveData(){
        do{
            try managedObjectContext?.save()
        }
        catch let error{
            print("could not save to core data: \(error)")
        }
    }
    
    //fetch all diary objects
    func fetchDiaryEntries(){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Diary")
        
        do{
            allDiary = (try managedObjectContext?.fetch(fetchRequest) as? [Diary])!
        }
        catch{
            fatalError("Failed to fetch reminders: \(error)")
        }
        
    }
    
    func generateWarning(){
        for eachEntry in allDiary{
            
            //dummy api
            let API_URL = "http://142.93.120.204/plumber/DummyDataWeather?lat=\((eachEntry.lat)!)&lon=\((eachEntry.long)!)&hu=\((eachEntry.humidity)!)&temp=\((eachEntry.temp)!)&aqi=\((eachEntry.quality)!)&unit=2"
            
            //real api
            //let API_URL = "http://142.93.120.204/plumber/weather?lat=\((eachEntry.lat)!)&lon=\((eachEntry.long)!)&hu=\((eachEntry.humidity)!)&temp=\((eachEntry.temp)!)&aqi=\((eachEntry.quality)!)&unit=\((thresholdLabel.text)!)"
            
            //Check if any optionals are presiding
            print(API_URL)
            
            
            downloadWarnings(api_url: API_URL, entry: eachEntry){
                //notification scheduling goes here.
                self.scheduleLocalForAlerts()
            }
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedWhenInUse || status == .authorizedAlways){
            locationAuthCheck()
            access = true
        }
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


