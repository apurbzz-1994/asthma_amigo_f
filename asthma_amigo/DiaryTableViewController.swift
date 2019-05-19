//
//  DiaryTableViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 29/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit
import CoreData

class DiaryTableViewController: UITableViewController {
    
    //var diaryList: [Diary]?
    var diaryList = [Diary]()
    
    
    //for accessing coredata
    var managedObjectContext: NSManagedObjectContext?
    
    
    //coredata initialization
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
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
    
    override func viewWillAppear(_ animated: Bool) {
        //hide navigation controller
        //navigationController?.setNavigationBarHidden(true, animated: animated)
        
        //clear list
        diaryList.removeAll()
        
        //fetch all entries again
        fetchDiaryEntries()
        
        //reload table view
        self.tableView.reloadData()
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
        return (self.diaryList.count)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath) as! DiaryTableViewCell
        let tempDiary = self.diaryList[indexPath.row]
        // Configure the cell...
        if tempDiary.month == "01"{
            cell.monthLabel.text = "January"
        }
        else if tempDiary.month == "02"{
            cell.monthLabel.text = "February"
        }
        else if tempDiary.month == "03"{
            cell.monthLabel.text = "March"
        }
        else if tempDiary.month == "04"{
            cell.monthLabel.text = "April"
        }
        else if tempDiary.month == "05"{
            cell.monthLabel.text = "May"
        }
        else if tempDiary.month == "06"{
            cell.monthLabel.text = "June"
        }
        else if tempDiary.month == "07"{
            cell.monthLabel.text = "July"
        }
        else if tempDiary.month == "08"{
            cell.monthLabel.text = "August"
        }
        else if tempDiary.month == "09"{
            cell.monthLabel.text = "September"
        }
        else if tempDiary.month == "10"{
            cell.monthLabel.text = "October"
        }
        else if tempDiary.month == "11"{
            cell.monthLabel.text = "November"
        }
        else {
            cell.monthLabel.text = "December"
        }
        //cell.monthLabel.text = tempDiary.month
        cell.dayLabel.text = tempDiary.day
        
        //adjust size of locationfield
//        changeLocationLabelHeight(textLabel: cell.addressLabel, locationText: tempDiary.location!)
        
        cell.addressLabel.text = tempDiary.location
        cell.timeLabel.text = "\((tempDiary.hour)!):\((tempDiary.minute)!)"
        cell.triggerLabel.text = "Trigger: \((tempDiary.trigger)!)"
        

        return cell
    }
    
    //fetch all diary objects
    func fetchDiaryEntries(){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Diary")
        
        do{
            diaryList = (try managedObjectContext?.fetch(fetchRequest) as? [Diary])!
        }
        catch{
            fatalError("Failed to fetch reminders: \(error)")
        }
        
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //first delete from diary list array
            let deletedDiary = diaryList.remove(at: indexPath.row)
            
            //fetch associated weather alerts
            
            
            //deleting from database
            managedObjectContext?.delete(deletedDiary)
            
            //fix table view to reflect the deletion changes
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            let totalPath = NSIndexPath(row: 0, section: 1)
            
            //save data
            saveData()
            
            
            //reload table view
            tableView.reloadRows(at: [totalPath as IndexPath], with: .none)
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //getting the diary entry which was selected by the user
        if segue.identifier == "showDiarySegue"{
            let selected = self.diaryList[(tableView.indexPathForSelectedRow?.row)!]
            let destination = segue.destination as! DiaryPageViewController
            destination.selectedDiary = selected
        }
        
    }
    
    /*calculating height of textlabel*/
    
    //calculates what size the label needs to be based on text
//    func getWidthOfLocationLabel(text: String) -> CGFloat
//    {
//        let txtLabel = UILabel(frame: .zero)
//        txtLabel.text = text
//        txtLabel.sizeToFit()
//        return txtLabel.frame.size.height
//    }
//
//    func changeLocationLabelHeight(textLabel: UILabel, locationText: String){
//        let height = getWidthOfLocationLabel(text: locationText)
//
//        //change height
//        textLabel.frame.size.height = height
//    }
    

}
