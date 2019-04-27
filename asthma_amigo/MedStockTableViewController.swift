//
//  MedStockTableViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 7/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit
import CoreData

class MedStockTableViewController: UITableViewController {
    
    var medicineList: [Medicine]?
    var inStock: [Medicine]? = []
    var outOfStock: [Medicine]? = []
    
    
    //for accessing coredata
    var managedObjectContext: NSManagedObjectContext?
    
    
    //coredata initialization
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    

    override func viewDidAppear(_ animated: Bool) {
        //remove back button
        self.navigationItem.setHidesBackButton(true, animated:true);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //delete stuff initially
        medicineList?.removeAll()
        inStock?.removeAll()
        outOfStock?.removeAll()

        //fetch all medicine all at once
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Medicine")
        do{
            medicineList = try managedObjectContext?.fetch(fetchRequest) as? [Medicine]
            
            //maybe do something for when no medicine.
        }
        catch{
            fatalError("Failed to fetch medicine: \(error)")
        }
        
        //divide medicine based on stock
        for med in (medicineList)!{
            if Int(med.stock!)! == 0{
                self.outOfStock?.append(med)
            }
            else{
                self.inStock?.append(med)
            }
        }
        
        self.tableView.reloadData()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
            return (self.inStock?.count)!
        }
        else{
            return (self.outOfStock?.count)!
        }
    }
    
    //for custom header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        if section == 0{
            label.text = "Current Stock"
        }
        else{
            label.text = "Out of Stock"
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineCell", for: indexPath) as! MedicineCell
        
        let tempMedicine: Medicine?
        
        if indexPath.section == 0{
            //for in stock
            tempMedicine = self.inStock?[indexPath.row]
        }
        else{
            tempMedicine = self.outOfStock?[indexPath.row]
        }
        
        //names and stuff
        cell.nameLabel.text = tempMedicine?.name
        cell.stockLabel.text = "\((tempMedicine?.stock)!) still remaining"
        
        //alert
        if Int((tempMedicine?.stock)!)! != 0{
            cell.alertImg.isHidden = true
        }
        if (tempMedicine?.isTablet)!{
            cell.medImg.image = UIImage(named: "icons8-pill-96")
        }
        else{
            cell.medImg.image = UIImage(named: "inhaler")
        }
        

        return cell
    }
 

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
