//
//  HomeViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 3/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    var actionPlanList: [ActionPlan]?
    
    //for accessing coredata
    var managedObjectContext: NSManagedObjectContext?
    
    //cards
    @IBOutlet weak var happyCard: UIView!
    @IBOutlet weak var sadCard: UIView!
    @IBOutlet weak var cryCard: UIView!
    @IBOutlet weak var emergencyCard: UIView!
    
    
    
    
    //declaring helper object for manipulating plist
    var plistHelper = PListHelper()
    

    //coredata initialization
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addShadow(card: happyCard)
        addShadow(card: sadCard)
        addShadow(card: cryCard)
        addShadow(card: emergencyCard)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
        navigationController?.navigationBar.backgroundColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
        
        //fetch all action plans into the list for lookup and button mapping
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ActionPlan")
        do{
            actionPlanList = try (managedObjectContext?.fetch(fetchRequest) as? [ActionPlan])
            //if no objects were fetched from the database
            if actionPlanList?.count == 0{
                //add initial action plans plus sample medicine
                populateActionPlan()
                actionPlanList = try ((managedObjectContext?.fetch(fetchRequest) as? [ActionPlan]))
                }
        }
        catch{
            fatalError("Failed to fetch actionplans: \(error)")
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //hide navigation bar
        //navigationController?.setNavigationBarHidden(true, animated: animated)
        
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        //setting user preferences
        //parentLabel.text = "Hello, \((plistHelper.readPlist(namePlist: "contacts", key: "Parent")["First Name"]!)!)"
        //kidLabel.text = "How is \((plistHelper.readPlist(namePlist: "contacts", key: "Child")["First Name"]!)!) feeling today?"
        //moodLabel.text = "Health: \((plistHelper.readPlist(namePlist: "contacts", key: "Mood")))"
        
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     Function that initialises the application with 3 parts action plan
     and provides some sample medicine.
     */
    func populateActionPlan(){
        //adding predefined action plans
        let well = createManagedActionPlan(type: "Well", useSpencer: false, info: "No information added yet.")
        let notWell = createManagedActionPlan(type: "Not Well", useSpencer: false, info: "No information added yet.")
        let worse = createManagedActionPlan(type: "Worse", useSpencer: false, info: "No information added yet.")
        
        //sample medicine for well
        
        
//        well.addToContains(createManagedMedicine(dosage: "0", freq: "0", isTablet: true, type: "Preventer", name: "Empty"))
//        well.addToContains(createManagedMedicine(dosage: "0", freq: "0", isTablet: false, type: "Reliever", name: "Empty"))
//
//        //sample medicine for not well
//        notWell.addToContains(createManagedMedicine(dosage: "0", freq: "0", isTablet: true, type: "Preventer", name: "Empty"))
//        notWell.addToContains(createManagedMedicine(dosage: "0", freq: "0", isTablet: false, type: "Reliever", name: "Empty"))
//
//
//        //sample medicine for worse
//        worse.addToContains(createManagedMedicine(dosage: "0", freq: "0", isTablet: true, type: "Preventer", name: "Empty"))
//        worse.addToContains(createManagedMedicine(dosage: "0", freq: "0", isTablet: false, type: "Reliever", name: "Empty"))
        
        saveData()
    }
    
    //object creation helper functions
    
    func createManagedActionPlan(type: String, useSpencer: Bool, info: String) -> ActionPlan {
        let plan = NSEntityDescription.insertNewObject(forEntityName: "ActionPlan", into: managedObjectContext!) as! ActionPlan
        plan.type = type
        plan.useSpencer = useSpencer
        plan.info = info
        return plan
    }
    
    func createManagedMedicine(dosage: String, freq: String, isTablet: Bool, type: String, name: String) -> Medicine {
        let med = NSEntityDescription.insertNewObject(forEntityName: "Medicine", into: managedObjectContext!) as! Medicine
        med.dosage = dosage
        med.freq = freq
        med.isTablet = isTablet
        med.type = type
        med.name = name
        
        return med
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "wellSegue") {
            //change flag:
            //plistHelper.writePlist(namePlist: "contacts", key: "Mood", data: "Well" as AnyObject)
            for plan in actionPlanList!{
                if plan.type == "Well"{
                    //send the well object to the next view
                    let destination = segue.destination as! ActionPlanViewController
                    destination.selectedActionPlan = plan
                }
            }
        }
        if(segue.identifier == "notWellSegue") {
            //change flag:
            //plistHelper.writePlist(namePlist: "contacts", key: "Mood", data: "Not Well" as AnyObject)
            for plan in actionPlanList!{
                if plan.type == "Not Well"{
                    //send the well object to the next view
                    let destination = segue.destination as! ActionPlanViewController
                    destination.selectedActionPlan = plan
                }
            }
        }
        
        if(segue.identifier == "worseSegue") {
            //change flag:
            //plistHelper.writePlist(namePlist: "contacts", key: "Mood", data: "Worse" as AnyObject)
            for plan in actionPlanList!{
                if plan.type == "Worse"{
                    //send the well object to the next view
                    let destination = segue.destination as! ActionPlanViewController
                    destination.selectedActionPlan = plan
                }
            }
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
    
    func addShadow(card: UIView){
        card.layer.cornerRadius = 8.0
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = .zero
        card.layer.shadowOpacity = 0.6
        card.layer.shadowRadius = 8.0
        card.layer.shadowPath = UIBezierPath(rect: card.bounds).cgPath
        card.layer.shouldRasterize = true
    }
    

}
