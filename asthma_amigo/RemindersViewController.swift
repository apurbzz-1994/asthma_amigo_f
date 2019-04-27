//
//  RemindersViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 22/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit
import CoreData

class RemindersViewController: UIViewController {
    
    //for when well card
    @IBOutlet weak var whenWellMedName: UILabel!
    @IBOutlet weak var whenWellDosage: UILabel!
    @IBOutlet weak var whenWellMedSymbol: UIImageView!
    @IBOutlet weak var whenWellCard: UIView!
    @IBOutlet weak var whenWellButton: UIButton!
    
    
    //for when not well card
    @IBOutlet weak var notWellName: UILabel!
    @IBOutlet weak var notWellDosage: UILabel!
    @IBOutlet weak var notWellMedSymbol: UIImageView!
    @IBOutlet weak var notWellCard: UIView!
    @IBOutlet weak var notWellButton: UIButton!
    
    

    //for when worse card
    @IBOutlet weak var worseName: UILabel!
    @IBOutlet weak var worseDosage: UILabel!
    @IBOutlet weak var worseMedSymbol: UIImageView!
    @IBOutlet weak var worseCard: UIView!
    @IBOutlet weak var worseButton: UIButton!
    
    
    //for accessing coredata
    var managedObjectContext: NSManagedObjectContext?
    
    //for storing medicine being fetched from database
    var preventerList: [Medicine]?
    
    //coredata initialization
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addShadow(card: whenWellCard)
        addShadow(card: notWellCard)
        addShadow(card: worseCard)
        

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Empty list so that updated values can be appended
        preventerList?.removeAll()
        
        //setting buttons as hidden initially
        whenWellButton.isHidden = true
        notWellButton.isHidden = true
        worseButton.isHidden = true
        
        //fetch updated stuff
        fetchPreventersFromDB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //reusing this from the dashboard class
    func addShadow(card: UIView){
        card.layer.cornerRadius = 8.0
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = .zero
        card.layer.shadowOpacity = 0.3
        card.layer.shadowRadius = 10.0
        card.layer.shadowPath = UIBezierPath(rect: card.bounds).cgPath
        card.layer.shouldRasterize = true
    }
    
    func fetchPreventersFromDB(){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Medicine")
        fetchRequest.predicate = NSPredicate(format: "type = %@", "Preventer")
        
        do{
            preventerList = try managedObjectContext?.fetch(fetchRequest) as? [Medicine]
            
            if preventerList?.count == 0 {
                //if no medicine has been set up
                whenWellMedName.text = "Empty"
                whenWellDosage.text = "Looks like you haven't filled this out yet"
                whenWellMedSymbol.image = UIImage(named: "icons8-box-important-48")
                
                notWellName.text = "Empty"
                notWellDosage.text = "Looks like you haven't filled this out yet"
                notWellMedSymbol.image = UIImage(named: "icons8-box-important-48")
                
                worseName.text = "Empty"
                worseDosage.text = "Looks like you haven't filled this out yet"
                worseMedSymbol.image = UIImage(named: "icons8-box-important-48")
                
                whenWellButton.isHidden = true
                notWellButton.isHidden = true
                worseButton.isHidden = true
            }
            else{
                for each in preventerList!{
                    if each.isPrescribed?.type == "Well"{
                        //if preventer belongs to well part of action plan
                        whenWellMedName.text = each.name
                        whenWellButton.isHidden = false
                        if each.isTablet{
                            //the preventer is a tablet
                            whenWellDosage.text = "Take \(each.dosage!) tablets \(each.freq!) times every day"
                            whenWellMedSymbol.image = UIImage(named: "icons8-pill-48")
                        }
                        else{
                            //the preventer is an inhailer
                            whenWellDosage.text = "Take \(each.dosage!) puffs \(each.freq!) times every day"
                            whenWellMedSymbol.image = UIImage(named: "inhaler_2")
                        }
                        
                    }
                    if each.isPrescribed?.type == "Not Well"{
                        //if preventer belongs to not well part of action plan
                        notWellName.text = each.name
                        notWellButton.isHidden = false
                        if each.isTablet{
                            //the preventer is a tablet
                            notWellDosage.text = "Take \(each.dosage!) tablets \(each.freq!) times every day"
                            notWellMedSymbol.image = UIImage(named: "icons8-pill-48")
                        }
                        else{
                            //the preventer is an inhailer
                            notWellDosage.text = "Take \(each.dosage!) puffs \(each.freq!) times every day"
                            notWellMedSymbol.image = UIImage(named: "inhaler_2")
                        }
                        
                    }
                    if each.isPrescribed?.type == "Worse"{
                        //if preventer belongs to well part of action plan
                        worseName.text = each.name
                        worseButton.isHidden = false
                        if each.isTablet{
                            //the preventer is a tablet
                            worseDosage.text = "Take \(each.dosage!) tablets \(each.freq!) times every day"
                            worseMedSymbol.image = UIImage(named: "icons8-pill-48")
                        }
                        else{
                            //the preventer is an inhailer
                            worseDosage.text = "Take \(each.dosage!) puffs \(each.freq!) times every day"
                            worseMedSymbol.image = UIImage(named: "inhaler_2")
                        }
                        
                    }
                    
                }
            }
            

        }
        catch{
            fatalError("Failed to fetch preventers: \(error)")
        }
    }
    
    //segue stuff
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "wellReminderSegue") {
            for med in preventerList!{
                if med.isPrescribed?.type == "Well"{
                    //send the well object to the next view
                    let destination = segue.destination as! RemindersTableViewController
                    destination.selectedMed = med
                }
            }
        }
        if(segue.identifier == "notWellReminderSegue") {
            for med in preventerList!{
                if med.isPrescribed?.type == "Not Well"{
                    //send the well object to the next view
                    let destination = segue.destination as! RemindersTableViewController
                    destination.selectedMed = med
                }
            }
        }
        
        if(segue.identifier == "worseReminderSegue") {
            for med in preventerList!{
                if med.isPrescribed?.type == "Worse"{
                    //send the well object to the next view
                    let destination = segue.destination as! RemindersTableViewController
                    destination.selectedMed = med
                }
            }
        }
    }
    
    

}
