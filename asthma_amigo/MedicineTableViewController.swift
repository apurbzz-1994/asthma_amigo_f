//
//  MedicineTableViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 4/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

//import UIKit
//import CoreData
//
//class MedicineTableViewController: UITableViewController, addMedDelegate {
//
//    @IBOutlet weak var headerLabel: UILabel!
//    var selectedActionPlan: ActionPlan?
//    var medicineList: [Medicine]?
//    var relieverList: [Medicine] = []
//    var preventerList: [Medicine] = []
//    var sectionNames: [String] = ["What are your Preventers?", "What are your Relievers?"]
//    var typeOfMedicineSelected: String = ""
//
//    //for accessing coredata
//    var managedObjectContext: NSManagedObjectContext?
//
//    //declaring helper object for manipulating plist
//    var plistHelper = PListHelper()
//
//
//    //coredata initialization
//    required init?(coder aDecoder: NSCoder) {
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
//        super.init(coder: aDecoder)!
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//
//
//        //get all medicine associated with selected action plan
//        medicineList = selectedActionPlan?.contains?.allObjects as? [Medicine]
//
//        //divide the medicine up according to category
//        for med in (medicineList)!{
//            if med.type == "Preventer"{
//                self.preventerList.append(med)
//            }
//            if med.type == "Reliever"{
//                self.relieverList.append(med)
//            }
//        }
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        //setting user preferences
//        headerLabel.text = "When \((plistHelper.readPlist(namePlist: "contacts", key: "Child")["First Name"]!)!) is \((selectedActionPlan?.type)!)"
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 2
//    }
//
////    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
////        return sectionNames[section]
////    }
//
//    //Add code here for whatever you wanna see in the headers
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//        //view.backgroundColor = UIColor.orange
//
//        let label = UILabel()
//        let button = UIButton()
//
//        //button properties
//        button.frame = CGRect(x: 310, y: 10, width: 40, height: 40)
//        button.setImage(UIImage(named: "icons8-add-48"), for: .normal)
//
//        if section == 0{
//            button.addTarget(self, action: #selector(addPreventerButtonAction), for: .touchUpInside)
//        }
//        if section == 1{
//            button.addTarget(self, action: #selector(addRelieverButtonAction), for: .touchUpInside)
//        }
//
//        view.addSubview(button)
//
//
//        //label properties
//        label.text = sectionNames[section]
//        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
//        label.textColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
//        label.frame = CGRect(x: 15, y: 15, width: 220, height: 25)
//
//        view.addSubview(label)
//
//
//        return view
//    }
//
//    //action for header buttons
//    @objc func addPreventerButtonAction(sender: UIButton!){
//        typeOfMedicineSelected = "Preventer"
//        //perform manual segue
//        self.performSegue(withIdentifier: "addMedSegue", sender: nil)
//    }
//
//    @objc func addRelieverButtonAction(sender: UIButton!){
//        typeOfMedicineSelected = "Reliever"
//        //perform manual segue
//        self.performSegue(withIdentifier: "addMedSegue", sender: nil)
//    }
//
//
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if preventerList.count == 0 && relieverList.count == 0{
//            return 150
//        }
//        else{
//            return 60
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        if section == 0{
//            return (self.preventerList.count)
//        }
//        else{
//            return (self.relieverList.count)
//        }
//    }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineCell", for: indexPath) as! MedicineCell
//
//        //display each cell row with medicine data from the mutable array
//        //let tempMedicine: Medicine? = self.medicineList![indexPath.row] as! Medicine
//        let tempMedicine: Medicine?
//
//        //decide on which section to show
//        if indexPath.section == 0{
//            tempMedicine = self.preventerList[indexPath.row]
//        }
//        else{
//            tempMedicine = self.relieverList[indexPath.row]
//        }
//
//        if tempMedicine?.name == "Empty"{
//            cell.medTitle.text = tempMedicine?.name
//            cell.medDscrp.text = "Looks like you haven't filled anything yet."
//            cell.medImage.image = UIImage(named: "icons8-box-important-48")
//        }
//        else{
//            cell.medTitle.text = tempMedicine?.name
//            //cell.medType.text = tempMedicine?.type
//            if tempMedicine?.type == "Preventer"{
//                //if medicine is a preventer
//                if (tempMedicine?.isTablet)!{
//                    cell.medDscrp.text = "Take \(tempMedicine!.dosage!) tablets \(tempMedicine!.freq!) times every day"
//                }
//                else{
//                    cell.medDscrp.text = "Take \(tempMedicine!.dosage!) puffs \(tempMedicine!.freq!) times every day"
//                }
//            }
//            if tempMedicine?.type == "Reliever"{
//                if (tempMedicine?.isTablet)!{
//                    cell.medDscrp.text = "Take \(tempMedicine!.dosage!) tablets."
//                }
//                else{
//                    cell.medDscrp.text = "Take \(tempMedicine!.dosage!) puffs."
//                }
//            }
//            if (tempMedicine?.isTablet)!{
//                //if medicine is a tablet
//                cell.medImage.image = UIImage(named: "icons8-pill-96")
//            }
//            else{
//                cell.medImage.image = UIImage(named: "inhaler")
//            }
//        }
//        return cell
//    }
//
//    //delegate implementation
//    func sendMedData(name: String, type: String, isTablet: Bool, dosage: String, freq: String){
//
//        //temporary object store
//        let tempMed: Medicine = createManagedMedicine(dosage: dosage, freq: freq, isTablet: isTablet, type: type, name: name)
//
//        //object added
//        selectedActionPlan?.addToContains(tempMed)
//
////        for (index, m) in preventerList.enumerated(){
////            if m.name == "Empty"{
////                //remove from list
////                preventerList.remove(at: index)
////                //remove from database
////                managedObjectContext?.delete(m)
////            }
////        }
////        for (index, m) in relieverList.enumerated(){
////            if m.name == "Empty"{
////                //remove from list
////                relieverList.remove(at: index)
////                //remove from database
////                managedObjectContext?.delete(m)
////            }
////        }
//
//        //save
//        saveData()
//
//        //appending the new object to the appropriate list
//
//        if tempMed.type == "Preventer"{
//            preventerList.append(tempMed)
//            tableView.insertRows(at: [IndexPath(row: (preventerList.count) - 1, section: 0)], with: .automatic)
//        }
//        if tempMed.type == "Reliever"{
//            relieverList.append(tempMed)
//            tableView.insertRows(at: [IndexPath(row: (relieverList.count) - 1, section: 1)], with: .automatic)
//        }
//
//        //medicineList?.append(tempMed)
//        //tableView.insertRows(at: [IndexPath(row: (medicineList?.count)! - 1, section: 0)], with: .automatic)
//
//        //reload data after save
//        self.tableView.reloadData()
//    }
//
//    //duplicate function for creating managed medicine objects
//    func createManagedMedicine(dosage: String, freq: String, isTablet: Bool, type: String, name: String) -> Medicine {
//        let med = NSEntityDescription.insertNewObject(forEntityName: "Medicine", into: managedObjectContext!) as! Medicine
//        med.dosage = dosage
//        med.freq = freq
//        med.isTablet = isTablet
//        med.type = type
//        med.name = name
//
//        return med
//    }
//
//    func saveData(){
//        do{
//            try managedObjectContext?.save()
//        }
//        catch let error{
//            print("could not save to core data: \(error)")
//        }
//    }
//
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "addMedSegue"{
//            let controller: AddMedicineViewController = segue.destination as! AddMedicineViewController
//            controller.type = typeOfMedicineSelected
//            controller.delegate = self
//        }
//    }
//
//
//}
