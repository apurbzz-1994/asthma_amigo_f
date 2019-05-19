//
//  WeatherWarningTableViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 8/5/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class WeatherWarningTableViewController: UITableViewController {
    
    
    //for storing fetched similar weather events
    var allAlerts = [WeatherAlert]()
    var seenAlerts = [WeatherAlert]()
    var unSeenAlerts = [WeatherAlert]()
    
    
    //for accessing coredata
    var managedObjectContext: NSManagedObjectContext?
    var dateForNextView: String?
    
    
    //coredata initialization
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //clear list
        allAlerts.removeAll()
        seenAlerts.removeAll()
        unSeenAlerts.removeAll()
        
        //fetch all entries again
        fetchAlerts()
        
        //divide the alerts based on if the user has read it or not
        for each in (allAlerts){
            if each.isSeen{
                self.seenAlerts.append(each)
            }
            else{
                self.unSeenAlerts.append(each)
            }
        }
        
        //reload table view
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
        navigationController?.navigationBar.backgroundColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return (self.seenAlerts.count)
        }
        else{
            return (self.unSeenAlerts.count)
        }
    }
    
    //for custom header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        if section == 0{
            label.text = "Read"
        }
        else{
            label.text = "Unread"
        }
        
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.textColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
        label.frame = CGRect(x: 15, y: 15, width: 220, height: 25)
        
        view.addSubview(label)
        
        return view
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    //user selects for generating warnings
    @IBAction func generateWarnings(_ sender: Any) {
//        for eachEntry in allDiary{
//
//            //dummy api
//            let API_URL = "http://142.93.120.204/plumber/DummyDataWeather?lat=\((eachEntry.lat)!)&lon=\((eachEntry.long)!)&hu=\((eachEntry.humidity)!)&temp=\((eachEntry.temp)!)&aqi=\((eachEntry.quality)!)&unit=\((thresholdLabel.text)!)"
//
//            //real api
//            //let API_URL = "http://142.93.120.204/plumber/weather?lat=\((eachEntry.lat)!)&lon=\((eachEntry.long)!)&hu=\((eachEntry.humidity)!)&temp=\((eachEntry.temp)!)&aqi=\((eachEntry.quality)!)&unit=\((thresholdLabel.text)!)"
//
//            //Check if any optionals are presiding
//            print(API_URL)
//
//
//            downloadWarnings(api_url: API_URL){
//
//                //reload table view
//                self.tableView.reloadData()
//
//            }
//        }
//        //save all data
//        saveData()
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertCell", for: indexPath) as! AlertTableViewCell
        
        let alr: WeatherAlert?
        
        if indexPath.section == 0{
            //for in stock
            alr = self.seenAlerts[indexPath.row]
        }
        else{
            alr = self.unSeenAlerts[indexPath.row]
        }
        
        //format date
        let stringDate = alr?.dateAndTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let tempDate = dateFormatter.date(from: stringDate!)
        dateFormatter.dateFormat = "MMM dd,yyyy"
        let tempDateTwo = dateFormatter.string(from: tempDate!)
        
        
        let dateForLabel = "\(tempDateTwo)"
        
        
        //please fill everything here
        dateForNextView = "Weather alert for \(dateForLabel)"
        cell.summaryLabel.text = "Weather alert for \(dateForLabel)"
        
        return cell
    }
    
    //function for fetching historical data for diary entry
//    func downloadWarnings(api_url: String, completed: @escaping DownloadComplete){
//        Alamofire.request(api_url).responseJSON { (response) in
//            print(response)
//            switch response.result {
//            case .success(let value):
//                //print(value)
//                let json = JSON(value)
//
//                //looping through the received json array
//                for i in 0..<json[0].count {
//                    let tempPrediction = Prediction(humidity: json[0][i]["Humidity"].stringValue, temperature: json[0][i]["Temperature"].stringValue, dateAndTime: json[0][i]["DateTime"].stringValue, qualityAir: json[0][i]["AQI"].stringValue)
//                     self.allPredictions.append(tempPrediction)
//                }
//
//                //the API sends a sorted list of alerts based on dates. Hence, selecting only the
//                //first one selects the one which is closest to todays date.
//                if json[0].count >= 1{
//                    //if some form of alert is there for a given diary entry
//                    self.createManagedAlert(humidity: json[0][1]["Humidity"].stringValue, temperature: json[0][1]["Temperature"].stringValue, dateAndTime: json[0][1]["DateTime"].stringValue, qualityAir: json[0][1]["AQI"].stringValue, isSeen: false)
//
//                }
//
////                print(json[0][0]["Humidity"])
////                print(json[0][1]["Humidity"])
////                print(json[0][2]["Humidity"])
//                //let roundedTemp: Double = json["temperature"].double!
//
//                //self.humidity = json["humidity"].stringValue
//                //print(self.humidity)
//            //self.airQuality = json["AQI"].stringValue
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//            DispatchQueue.main.async{
//                completed ()
//
//            }
//        }
//    }
    
    //fetch all diary objects
    func fetchAlerts(){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "WeatherAlert")
        
        do{
            allAlerts = (try managedObjectContext?.fetch(fetchRequest) as? [WeatherAlert])!
        }
        catch{
            fatalError("Failed to fetch reminders: \(error)")
        }
        
    }
    
    func saveData(){
        do{
            try managedObjectContext?.save()
        }
        catch let error{
            print("could not save to core data: \(error)")
        }
    }
    
    //function for editing read/unread status
    func readAnAlert(alert: WeatherAlert){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "WeatherAlert")
        fetchRequest.predicate = NSPredicate(format: "dateAndTime = %@", alert.dateAndTime!)
        do{
            let test = try managedObjectContext?.fetch(fetchRequest)
            
            let objectUpdate = test![0] as! NSManagedObject
            objectUpdate.setValue(true, forKey: "isSeen")
            do{
                try managedObjectContext?.save()
            }
            catch{
                print(error)
            }
        }
        catch{
            print(error)
        }
        
        saveData()
        
    }
    
    //function for creating managed weather alert objects to be stored to database
//    func createManagedAlert(humidity: String, temperature: String, dateAndTime: String, qualityAir: String, isSeen: Bool) {
//        let alert = NSEntityDescription.insertNewObject(forEntityName: "WeatherAlert", into: managedObjectContext!) as! WeatherAlert
//        alert.humidity = humidity
//        alert.temperature = temperature
//        alert.dateAndTime = dateAndTime
//        alert.qualityAir = qualityAir
//        alert.isSeen = isSeen
//    }
//
//
//    //reusable function for core data persistance
//    func saveData(){
//        do{
//            try managedObjectContext?.save()
//        }
//        catch let error{
//            print("could not save to core data: \(error)")
//        }
//    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "alertDetailsSegue"){
            let selectedAlert = self.allAlerts[(tableView.indexPathForSelectedRow?.row)!]
            self.readAnAlert(alert: selectedAlert)
            let destination = segue.destination as! AlertDetailsViewController
            destination.selectedAlert = selectedAlert
        }
     }
    
    
}

