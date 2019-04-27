//
//  RemindersTableViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 24/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class RemindersTableViewController: UITableViewController {
    
    //for storing reminders for particular medicine
    var medReminderList = [MedReminder]()
    var selectedMed: Medicine?
    
    @IBOutlet weak var selectedMedImg: UIImageView!
    @IBOutlet weak var selectedMedName: UILabel!
    @IBOutlet weak var selectedMedDesc: UILabel!
    @IBOutlet weak var testButton: UIButton!
    
    
    //for accessing coredata
    var managedObjectContext: NSManagedObjectContext?
    
    //coredata initialization
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //hide test button for now
        testButton.alpha = 0
        
        //clear list and reload data each time view appears
        medReminderList.removeAll()
        
        //load data
        fetchReminders()
        
        //reload table view
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedMedName.text = selectedMed?.name
        selectedMedDesc.text = "\((selectedMed?.freq)!) tablet/puff(s) every \((selectedMed?.dosage)!) times(s) a day"
        if (selectedMed?.isTablet)!{
            selectedMedImg.image = UIImage(named: "icons8-pill-48")
        }
        else{
            selectedMedImg.image = UIImage(named: "inhaler_2")
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return medReminderList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath)

        // Configure the cell...
        let tempReminder: MedReminder? = medReminderList[indexPath.row]
        cell.textLabel?.text = "\((tempReminder?.hour)!) : \((tempReminder?.minute)!) : \((tempReminder?.second)!)"

        return cell
    }
    
    @IBAction func addReminderOnPress(_ sender: Any) {
        if medReminderList.count <= Int((selectedMed?.dosage)!)!{
            //perform segue
            self.performSegue(withIdentifier: "addReminderSegue", sender: nil)
        }
        else{
            //display error message
            let alertController = UIAlertController(title: "Alert", message: "You have already exceeded your daily dosage limit for this medicine.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func testPending(_ sender: Any) {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {requests -> () in
            print("\(requests.count) requests -------")
            for request in requests{
                print(request.identifier)
            }
        })
        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: {deliveredNotifications -> () in
            print("\(deliveredNotifications.count) Delivered notifications-------")
            for notification in deliveredNotifications{
                print(notification.request.identifier)
            }
        })
    }
    
    
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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
    
    //reusing function for checking if a notification is pending
    func checkIfPendingOrNot(r: MedReminder, completed: @escaping (Bool)-> Void = {_ in }) {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests{
                completed(request.identifier == r.reminderID)
            }
        })
    }

    
    // Override to support editing the table view.
    //deleting reminders
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //first delete from med reminder list array
            let deletedReminder = medReminderList.remove(at: indexPath.row)
            
            //remove notification schedule if pending
            checkIfPendingOrNot(r: deletedReminder){isPending in
                //remove
                //print(deletedReminder.reminderID)
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [deletedReminder.reminderID!])
            }
            
            //deleting from database
            managedObjectContext?.delete(deletedReminder)
            
            //fix table view to reflect the deletion changes
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            let totalPath = NSIndexPath(row: 0, section: 1)
            
            //save data
            saveData()
            
            
            //reload table view
            tableView.reloadRows(at: [totalPath as IndexPath], with: .none)
        }
    }
    

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
        if(segue.identifier == "addReminderSegue") {
            //send the well object to the next view
            let destination = segue.destination as! SetReminderViewController
            destination.selectedMed = selectedMed
        }
    }
    
    //fetch all reminder objects
    func fetchReminders(){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "MedReminder")
        fetchRequest.predicate = NSPredicate(format: "forMed = %@", selectedMed!)
        
        do{
            medReminderList = (try managedObjectContext?.fetch(fetchRequest) as? [MedReminder])!
        }
        catch{
            fatalError("Failed to fetch reminders: \(error)")
        }
        
    }
    

}
