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
    
    //constants
    let locationManager = CLLocationManager()
    //variables
    var currentWeather: CurrentWeather!
    var currentLocation: CLLocation!

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
        //adding shadow to each card
        addShadow(card: moodCard)
        addShadow(card: tempCard)
        addShadow(card: humidityCard)
        addShadow(card: airQualityCard)
        addShadow(card: overallCard)
        
        callDelegates()
        currentWeather = CurrentWeather()
        setupLocation()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //moodLabel.text = "Health: \((plistHelper.readPlist(namePlist: "contacts", key: "Mood")))"
        
        configureMoodCard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthCheck()
    }
    
    
    func callDelegates(){
        locationManager.delegate = self
    }
    func setupLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() // Take Permission from the user
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    /// This function updates the Current weather UI in our App.
    func updateUI() {
        cityNameLabel.text = currentWeather.cityName
        tempValueLabel.text = "\(Int(currentWeather.currentTemp)) ℃"
        weatherData.text = currentWeather.weatherType
        humidityValue.text = currentWeather.humidityVal
        airQualityLabel.text = currentWeather.airQuality
        overallLabel.text = currentWeather.summary
        weatherPic.image = UIImage(named: currentWeather.weatherType)
    }
    
    //Here we are checking the location authentication status
    func locationAuthCheck() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // Get the location from the device
            currentLocation = locationManager.location
            
            // Pass the location coord to our API
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            
            // Download the API Data
            currentWeather.downloadCurrentWeather {
                // Update the UI after download is completed.
                self.updateUI()
            }
        }else {
            //user did not allow
            locationManager.requestWhenInUseAuthorization()//take permission from the user
            locationAuthCheck()//Make a check
        }
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
            
            kidLabel.alpha = 1
            happyButtonLabel.alpha = 1
            sadButtonLabel.alpha = 1
            cryButtonLabel.alpha = 1
            
            kidLabel.text = "How is \((plistHelper.readPlist(namePlist: "contacts", key: "Child")["First Name"]!)!) feeling today?"
            
        }
        if mood as! String == "Well"{
            kidLabel.alpha = 0
            happyButtonLabel.alpha = 0
            sadButtonLabel.alpha = 0
            cryButtonLabel.alpha = 0
            selectedSad.alpha = 0
            selectedCry.alpha = 0
            
            selectedHappy.alpha = 1
            moodLabel.alpha = 1
            editButtonLabel.alpha = 1
            
            moodLabel.text = "Health: \((plistHelper.readPlist(namePlist: "contacts", key: "Mood")))"
        }
        if mood as! String == "Not Well"{
            kidLabel.alpha = 0
            happyButtonLabel.alpha = 0
            sadButtonLabel.alpha = 0
            cryButtonLabel.alpha = 0
            selectedHappy.alpha = 0
            selectedCry.alpha = 0
            
            selectedSad.alpha = 1
            moodLabel.alpha = 1
            editButtonLabel.alpha = 1
            
            moodLabel.text = "Health: \((plistHelper.readPlist(namePlist: "contacts", key: "Mood")))"
        }
        if mood as! String == "Worse"{
            kidLabel.alpha = 0
            happyButtonLabel.alpha = 0
            sadButtonLabel.alpha = 0
            cryButtonLabel.alpha = 0
            selectedSad.alpha = 0
            selectedHappy.alpha = 0
            
            selectedCry.alpha = 1
            moodLabel.alpha = 1
            editButtonLabel.alpha = 1
            
            moodLabel.text = "Health: \((plistHelper.readPlist(namePlist: "contacts", key: "Mood")))"
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
                })
            })
        }
        

        moodLabel.text = "Health: Worse"
    }
    
    @IBAction func editPressed(_ sender: Any) {
        //let the user select a mood
        selectedHappy.alpha = 0
        selectedSad.alpha = 0
        selectedCry.alpha = 0
        editButtonLabel.alpha = 0
        moodLabel.alpha = 0
        
        kidLabel.alpha = 1
        happyButtonLabel.alpha = 1
        sadButtonLabel.alpha = 1
        cryButtonLabel.alpha = 1
        
        kidLabel.text = "How is \((plistHelper.readPlist(namePlist: "contacts", key: "Child")["First Name"]!)!) feeling today?"
       
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
