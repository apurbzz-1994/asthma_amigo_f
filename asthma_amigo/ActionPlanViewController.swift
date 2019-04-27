//
//  ActionPlanViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 6/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit
import CoreData

class ActionPlanViewController: UIViewController, addMedDelegate, addRelieverDelegate, addInfoDelegate {
    
    //for storing medicine
    var medicineList: [Medicine]?
    
    var selectedActionPlan: ActionPlan?
    
    var oldMed: Medicine?
    
    var typeOfMedicineSelected: String = ""
    
    var selectedPreventer: Medicine?
    
    
    //references to view elements
    
    //header
    @IBOutlet weak var headerStat: UILabel!
    @IBOutlet weak var headerImg: UIImageView!
    
    //preventer
    @IBOutlet weak var preventerName: UILabel!
    @IBOutlet weak var preventerDescription: UILabel!
    @IBOutlet weak var buttonText: UIButton!
    @IBOutlet weak var preventerPic: UIImageView!
    
    
    //reliever
    @IBOutlet weak var relieverName: UILabel!
    @IBOutlet weak var relieverDescription: UILabel!
    @IBOutlet weak var rButtonText: UIButton!
    @IBOutlet weak var relieverPic: UIImageView!
    
    //information and spencer
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var ifUseSpencer: UISegmentedControl!
    
    //for changing and saving spacer value
    @IBAction func saveSpacerValue(_ sender: Any) {
        if ifUseSpencer.selectedSegmentIndex == 0{
            //if user selects yes
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "ActionPlan")
            fetchRequest.predicate = NSPredicate(format: "type = %@", (selectedActionPlan?.type)!)
            do{
                let test = try managedObjectContext?.fetch(fetchRequest)

                let objectUpdate = test![0] as! NSManagedObject
                objectUpdate.setValue(true, forKey: "useSpencer")
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
        }
        if ifUseSpencer.selectedSegmentIndex == 1{
            //if user selects yes
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "ActionPlan")
            fetchRequest.predicate = NSPredicate(format: "type = %@", (selectedActionPlan?.type)!)
            do{
                let test = try managedObjectContext?.fetch(fetchRequest)

                let objectUpdate = test![0] as! NSManagedObject
                objectUpdate.setValue(false, forKey: "useSpencer")
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

        }
    }
    
    
    
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //setting user preferences
        headerStat.text = "When \((plistHelper.readPlist(namePlist: "contacts", key: "Child")["First Name"]!)!) is \((selectedActionPlan?.type)!)"
        
        if selectedActionPlan?.type == "Well"{
            headerImg.image = UIImage(named: "icons8-happy-96")
        }
        if selectedActionPlan?.type == "Not Well"{
            headerImg.image = UIImage(named: "icons8-sad-96")
        }
        if selectedActionPlan?.type == "Worse"{
            headerImg.image = UIImage(named: "icons8-crying-96")
        }
        
        
        //for medicine
        //<-------------------------BEGIN------------------------>
        medicineList?.removeAll()
        medicineList = selectedActionPlan?.contains?.allObjects as? [Medicine]
        
        if medicineList?.count == 0{
            //if actionplan has not been added yet
            showForNoPlan()
        }
        if medicineList?.count == 1{
            if medicineList![0].type == "Preventer"{
                showForPreventer(p: medicineList![0])
            }
            else{
                showForReliever(p: medicineList![0])
            }
        }
        if medicineList?.count == 2 {
            if medicineList![0].type == "Preventer"{
                showForBoth(p: medicineList![0], r: medicineList![1])
            }
            else{
                showForBoth(p: medicineList![1], r: medicineList![0])
            }
            
        }
        //<-----------END---------------------------->
        
        
        //setting additional information
        if selectedActionPlan?.info == nil{
            infoLabel.text = "No information added yet"
        }
        else{
            infoLabel.text = selectedActionPlan?.info
        }
        
        //setting spacer use option
        if (selectedActionPlan?.useSpencer)!{
            ifUseSpencer.selectedSegmentIndex = 0
        }
        else{
            ifUseSpencer.selectedSegmentIndex = 1
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //get all medicine associated with selected action plan
        //selectedActionPlan gets updated via the segue from homescreen.
//        medicineList = selectedActionPlan?.contains?.allObjects as? [Medicine]
//
//        if medicineList?.count == 0{
//            //if actionplan has not been added yet
//            showForNoPlan()
//        }
//        if medicineList?.count == 1{
//            if medicineList![0].type == "Preventer"{
//                showForPreventer(p: medicineList![0])
//            }
//            else{
//                showForReliever(p: medicineList![0])
//            }
//        }
//        if medicineList?.count == 2 {
//            if medicineList![0].type == "Preventer"{
//                showForBoth(p: medicineList![0], r: medicineList![1])
//            }
//            else{
//                showForBoth(p: medicineList![1], r: medicineList![0])
//            }
//
//        }
    }
    
    
    
    @IBAction func addMedForPreventer(_ sender: Any) {
        typeOfMedicineSelected = "Preventer"
        //perform manual segue
        self.performSegue(withIdentifier: "addMedSegue", sender: nil)
    }
    
    
    @IBAction func addMedForReliever(_ sender: Any) {
        typeOfMedicineSelected = "Reliever"
        //perform manual segue
        self.performSegue(withIdentifier: "addRelieverSegue", sender: nil)
    }
    
    @IBAction func addInfoOnPress(_ sender: Any) {
        self.performSegue(withIdentifier: "addInfoSegue", sender: nil)
    }
    
    

    //displays stuff when there is no action plan
    func showForNoPlan(){
        preventerName.text = "Empty"
        preventerDescription.text = "Looks like you haven't entered anything yet."
        buttonText.setTitle("Add", for: .normal)
        preventerPic.image = UIImage(named: "icons8-box-important-48")
        
        relieverName.text = "Empty"
        relieverDescription.text = "Looks like you haven't entered anything yet."
        rButtonText.setTitle("Add", for: .normal)
        relieverPic.image = UIImage(named: "icons8-box-important-48")
    }
    
    //only preventer plan is there
    func showForPreventer(p: Medicine){
        preventerName.text = p.name
        
        if p.isTablet{
            //the medicine is a tablet
            preventerDescription.text = "Take \(p.dosage!) tablets \(p.freq!) times every day"
            preventerPic.image = UIImage(named: "icons8-pill-48")
        }
        else{
            //the medicine is inhaler
            preventerDescription.text = "Take \(p.dosage!) puffs \(p.freq!) times every day"
            preventerPic.image = UIImage(named: "inhaler_2")
        }
        buttonText.setTitle("Edit", for: .normal)
        
        relieverName.text = "Empty"
        relieverDescription.text = "Looks like you haven't entered anything yet."
        rButtonText.setTitle("Add", for: .normal)
        relieverPic.image = UIImage(named: "icons8-box-important-48")
    }
    
    //only reliever plan is there
    func showForReliever(p: Medicine){
        //aa reliever is always an inhaler (add this to the addMedicine section)
        //also, no fixed day times
        relieverName.text = p.name
        relieverDescription.text = "Take \(p.dosage!) puffs."
        rButtonText.setTitle("Add", for: .normal)
        relieverPic.image = UIImage(named: "inhaler_2")
        
        preventerName.text = "Empty"
        preventerDescription.text = "Looks like you haven't entered anything yet."
        buttonText.setTitle("Edit", for: .normal)
        preventerPic.image = UIImage(named: "icons8-box-important-48")
    }
    
    //both plans are there
    func showForBoth(p: Medicine, r: Medicine){
        preventerName.text = p.name
        if p.isTablet{
            //the medicine is a tablet
            preventerDescription.text = "Take \(p.dosage!) tablets \(p.freq!) times every day"
            preventerPic.image = UIImage(named: "icons8-pill-48")
        }
        else{
            //the medicine is inhaler
            preventerDescription.text = "Take \(p.dosage!) puffs \(p.freq!) times every day"
            preventerPic.image = UIImage(named: "inhaler_2")
        }
        buttonText.setTitle("Edit", for: .normal)
        
        relieverName.text = r.name
        relieverDescription.text = "Take \(r.dosage!) puffs."
        rButtonText.setTitle("Edit", for: .normal)
        relieverPic.image = UIImage(named: "inhaler_2")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //delegate implementation for preventer
    func sendMedData(name: String, type: String, isTablet: Bool, dosage: String, freq: String){
        
        //generating a random number for the stock
        let randomStock = Int(arc4random_uniform(3))
        
        //temporary object store
        let tempMed: Medicine = createManagedMedicine(dosage: dosage, freq: freq, isTablet: isTablet, type: type, name: name, stock: String(randomStock))
        
        
        if medicineList?.count == 0{
            //if no data, add whatever is being sent
            selectedActionPlan?.addToContains(tempMed)
            //save
            saveData()
            
            //<----------------------------display----------------------->
            //if newly added medicine is a preventer
//            preventerName.text = tempMed.name
//            if tempMed.isTablet{
//                //the medicine is a tablet
//                preventerDescription.text = "Take \(tempMed.dosage!) tablets \(tempMed.freq!) times every day"
//                preventerPic.image = UIImage(named: "icons8-pill-48")
//            }
//            else{
//                //the medicine is inhaler
//                preventerDescription.text = "Take \(tempMed.dosage!) puffs \(tempMed.freq!) times every day"
//                preventerPic.image = UIImage(named: "inhaler_2")
//            }
//            buttonText.setTitle("Edit", for: .normal)
        }
        else{
            //delete the old object
            for eachMed in medicineList!{
                if eachMed.type == tempMed.type{
                    oldMed = eachMed
                }
            }
            
            if oldMed != nil{
                managedObjectContext?.delete(oldMed!)
                
                //add new object
                selectedActionPlan?.addToContains(tempMed)
                
                //save
                saveData()
            }
            else{
                //if no data, add whatever is being sent
                selectedActionPlan?.addToContains(tempMed)
                //save
                saveData()
            }
            
            //<---------------------display---------------------->
            //if newly added medicing is a preventer
//            preventerName.text = tempMed.name
//            if tempMed.isTablet{
//                //the medicine is a tablet
//                preventerDescription.text = "Take \(tempMed.dosage!) tablets \(tempMed.freq!) times every day"
//                preventerPic.image = UIImage(named: "icons8-pill-48")
//            }
//            else{
//                //the medicine is inhaler
//                preventerDescription.text = "Take \(tempMed.dosage!) puffs \(tempMed.freq!) times every day"
//                preventerPic.image = UIImage(named: "inhaler_2")
//            }
//            buttonText.setTitle("Edit", for: .normal)
        }
        
    }
    
    //delegate implementation for reliever
    func sendRelieverData(name: String, type: String, isTablet: Bool, dosage: String, freq: String) {
        
        //generating a random number for the stock
        let randomStock = Int(arc4random_uniform(50))
        //temporary object store
        
        let tempMed: Medicine = createManagedMedicine(dosage: dosage, freq: freq, isTablet: isTablet, type: type, name: name, stock: String(randomStock))
        
        
        if medicineList?.count == 0{
            //if no data, add whatever is being sent
            selectedActionPlan?.addToContains(tempMed)
            //save
            saveData()
            
            //<----------------------------display----------------------->
            //if newly added medicing is a reliever
            relieverName.text = tempMed.name
            relieverDescription.text = "Take \(tempMed.dosage!) puffs."
            rButtonText.setTitle("Edit", for: .normal)
            relieverPic.image = UIImage(named: "inhaler_2")
            }
        else{
            //delete the old object
            for eachMed in medicineList!{
                if eachMed.type == tempMed.type{
                    oldMed = eachMed
                }
            }
            
            if oldMed != nil{
                
                managedObjectContext?.delete(oldMed!)
                
                
                //delete all reminders here
                
                
                
                //add new object
                selectedActionPlan?.addToContains(tempMed)
                
                //save
                saveData()
            }
            else{
                //this does not exist yet
                selectedActionPlan?.addToContains(tempMed)
                //save
                saveData()
            }
            

            
            //<---------------------display---------------------->
            //if newly added medicing is a reliever
            relieverName.text = tempMed.name
            relieverDescription.text = "Take \(tempMed.dosage!) puffs."
            rButtonText.setTitle("Edit", for: .normal)
            relieverPic.image = UIImage(named: "inhaler_2")
        }
        
    }
    
    //deleting all reminders
    
    //duplicate function for creating managed medicine objects
    func createManagedMedicine(dosage: String, freq: String, isTablet: Bool, type: String, name: String, stock: String) -> Medicine {
        let med = NSEntityDescription.insertNewObject(forEntityName: "Medicine", into: managedObjectContext!) as! Medicine
        med.dosage = dosage
        med.freq = freq
        med.isTablet = isTablet
        med.type = type
        med.name = name
        med.stock = stock
        
        return med
    }
    
    func saveData(){
        do{
            try managedObjectContext?.save()
        }
        catch let error{
            print("could not save to core data: \(error)")
        }
    }
    
    //delegate implementation for information tab
    func sendInfoData(info: String) {
        //infoLabel.text = info

        //gonna type some sort of an update function.
        //Hope this works!
        
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "ActionPlan")
        fetchRequest.predicate = NSPredicate(format: "type = %@", (selectedActionPlan?.type)!)
        do{
            let test = try managedObjectContext?.fetch(fetchRequest)
            
            let objectUpdate = test![0] as! NSManagedObject
            objectUpdate.setValue(info, forKey: "info")
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
        
        
    }
    
    
    
    //duplicate helper function
    func createManagedActionPlan(type: String, useSpencer: Bool, info: String) -> ActionPlan {
        let plan = NSEntityDescription.insertNewObject(forEntityName: "ActionPlan", into: managedObjectContext!) as! ActionPlan
        plan.type = type
        plan.useSpencer = useSpencer
        plan.info = info
        return plan
    }
    
    

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addMedSegue"{
            let controller: AddMedicineViewController = segue.destination as! AddMedicineViewController
            if medicineList?.count != 0{
                for each in medicineList!{
                    if each.type == "Preventer"{
                        controller.selectedMed = each
                        controller.isMedEmpty = false
                    }
                }
            }
            else{
                controller.isMedEmpty = true
            }

            controller.delegate = self
        }
    if segue.identifier == "addRelieverSegue"{
        let controller: AddRelieverViewController = segue.destination as! AddRelieverViewController
        if medicineList?.count != 0{
            for each in medicineList!{
                if each.type == "Reliever"{
                    controller.selectedMed = each
                    controller.isMedEmpty = false
                }
            }
        }
        else{
            controller.isMedEmpty = true
        }
        controller.delegate = self
    }
    if segue.identifier == "addInfoSegue"{
        let controller: AddInfoViewController = segue.destination as! AddInfoViewController
        //controller.type = typeOfMedicineSelected
        if selectedActionPlan?.info != "No information added yet."{
            controller.selectedActionPlan = selectedActionPlan
            controller.isInfoEmpty = false
        }
        else{
            controller.isInfoEmpty = true
        }
        controller.delegate = self
    }
    
    }

}
