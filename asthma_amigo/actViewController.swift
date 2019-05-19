//
//  actViewController.swift
//  asthma_amigo
//
//  Created by Deepika on 2019/5/6.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit
import CoreData

class actViewController: UIViewController {
    
    //for when well card
    
    
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var comments1: UILabel!
    
    @IBOutlet weak var comments2: UILabel!
    @IBOutlet weak var whenWellMedName: UILabel!
    @IBOutlet weak var whenWellDosage: UILabel!
    @IBOutlet weak var wellReliverName: UILabel!
    
    @IBOutlet weak var wellRelieverDosage: UILabel!
    
    @IBOutlet weak var notwellRelieverName: UILabel!
    
    @IBOutlet weak var notwellRelieverDosage: UILabel!
    
    @IBOutlet weak var worseRelieverName: UILabel!
    
    @IBOutlet weak var worseRelieverDosage: UILabel!
    @IBOutlet weak var kidLabel: UILabel!
    //for when not well card
    @IBOutlet weak var notWellName: UILabel!
    @IBOutlet weak var notWellDosage: UILabel!
    @IBOutlet weak var notWellMedSymbol: UIImageView!
    @IBOutlet weak var notWellCard: UIView!
    @IBOutlet weak var notWellButton: UIButton!
    @IBOutlet weak var parentLabel: UILabel!
    @IBOutlet weak var parentContact: UILabel!
    @IBOutlet weak var kidAge: UILabel!
    
    //for when worse card
    @IBOutlet weak var worseName: UILabel!
    @IBOutlet weak var worseDosage: UILabel!
    @IBOutlet weak var worseMedSymbol: UIImageView!
    @IBOutlet weak var worseCard: UIView!
    @IBOutlet weak var worseButton: UIButton!
    
    @IBOutlet weak var masterContainerView: UIView!
    
    @IBOutlet weak var pdfButton: UIButton!
    @IBAction func generatePDFtapped(_ sender: Any) {
        pdfButton.isHidden = true
        //generatePDF()
        pdfButton.isHidden = false
    }
    
    //declaring helper object for manipulating plist
    var plistHelper = PListHelper()
    
    var selectedActionPlan: ActionPlan?
    
    //for accessing coredata
    var managedObjectContext: NSManagedObjectContext?
    
    //for storing medicine being fetched from database
    var preventerList: [Medicine]?
    var relieverList: [Medicine]?
    var commentList:[ActionPlan]?
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
        
        configureMoodCard()
        //  addShadow(card: whenWellCard)
        // addShadow(card: notWellCard)
        //  addShadow(card: worseCard)
        
        
        // Do any additional setup after loading the view.
        
    }
    func configureMoodCard(){
        let mood = plistHelper.readPlist(namePlist: "contacts", key: "Mood")
        
        
        
        kidLabel.alpha = 1
        
        
        kidLabel.text =  ((plistHelper.readPlist(namePlist: "contacts", key: "Child")["First Name"]!)!) as! String
        kidAge.text =  ((plistHelper.readPlist(namePlist: "contacts", key: "Child")["Age"]!)!) as? String
        parentLabel.text =  ((plistHelper.readPlist(namePlist: "contacts", key: "Parent")["First Name"]!)!) as? String
        parentContact.text =  ((plistHelper.readPlist(namePlist: "contacts", key: "Parent")["Phone Number"]!)!) as? String
    }
//    func generatePDF() {
//        let pdfWrittenPath = masterContainerView.exportAsPdfFromView()
//        print("PDF written at \(pdfWrittenPath)")
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //Empty list so that updated values can be appended
        preventerList?.removeAll()
        
        
        
        //fetch updated stuff
        fetchPreventersFromDB()
        fetchRelieverFromDB()
        fetchCommentsFromDB()
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
    
    func fetchRelieverFromDB(){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Medicine")
        fetchRequest.predicate = NSPredicate(format: "type = %@", "Reliever")
        do{
            relieverList = try! managedObjectContext?.fetch(fetchRequest) as? [Medicine]
            
            if relieverList?.count == 0 {
                print("empty")
                wellReliverName.text = "Empty"
                wellRelieverDosage.text = "Empty"
            }else{
                for each in relieverList!{
                    if each.isPrescribed?.type == "Well"{
                        wellReliverName.text = each.name
                        wellRelieverDosage.text =  "Take \(each.dosage!) times every day"
                        
                    }else
                        if each.isPrescribed?.type == "Not Well"{
                            notwellRelieverName.text = each.name
                            notwellRelieverDosage.text =  "Take \(each.dosage!) times every day"
                            
                        }else
                            if each.isPrescribed?.type == "Worse"{
                                worseRelieverName.text = each.name
                                worseRelieverDosage.text =  "Take \(each.dosage!) times every day"
                    }
                    
                }
            }
        }
    }
    
    func fetchCommentsFromDB(){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "ActionPlan")
        //fetchRequest.predicate = NSPredicate(format: "type = %@", "Reliever")
        do{
            commentList = try! managedObjectContext?.fetch(fetchRequest) as? [ActionPlan]
            if commentList?.count == 0 {
                print("empty")
                wellReliverName.text = "Empty"
                //wellRelieverDosage.text = "Empty"
            }else{
                for each in commentList!{
                    if each.type == "Well" {
                        print("each.isPrescribed?.info: ")
                        comments.text = each.info
                        // wellRelieverDosage.text = each.dosage
                        
                    }else
                        if each.type == "Not Well" {
                            print("each.isPrescribed?.info: ")
                            comments1.text = each.info
                            // wellRelieverDosage.text = each.dosage
                            
                        }else
                            if each.type == "Worse" {
                                print("each.isPrescribed?.info: ")
                                comments2.text = each.info
                                // wellRelieverDosage.text = each.dosage
                                
                    }
                }
            }
        }
    }
    
    func fetchPreventersFromDB(){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Medicine")
        fetchRequest.predicate = NSPredicate(format: "type = %@", "Preventer")
        do{
            preventerList = try managedObjectContext?.fetch(fetchRequest) as? [Medicine]
            
            if preventerList?.count == 0 {
                
                //if no medicine has been set up
                whenWellMedName.text = "Empty"
                whenWellDosage.text = "Empty"
                //whenWellMedSymbol.image = UIImage(named: "icons8-box-important-48")
                
                notWellName.text = "Empty"
                notWellDosage.text = "Empty"
                //                notWellMedSymbol.image = UIImage(named: "icons8-box-important-48")
                
                worseName.text = "Empty"
                worseDosage.text = "Empty"
                //  worseMedSymbol.image = UIImage(named: "icons8-box-important-48")
                
                //whenWellButton.isHidden = true
                //  notWellButton.isHidden = true
                // worseButton.isHidden = true
            }
            else{
                for each in preventerList!{
                    print("Here",each)
                    if each.isPrescribed?.type == "Well"{
                        //if preventer belongs to well part of action plan
                        whenWellMedName.text = each.name
                        //whenWellButton.isHidden = false
                        if each.isTablet{
                            //the preventer is a tablet
                            whenWellDosage.text = "Take \(each.dosage!) tablets \(each.freq!) times every day"
                            //whenWellMedSymbol.image = UIImage(named: "icons8-pill-48")
                        }
                        else{
                            //the preventer is an inhailer
                            whenWellDosage.text = "Take \(each.dosage!) puffs \(each.freq!) times every day"
                            //whenWellMedSymbol.image = UIImage(named: "inhaler_2")
                        }
                        
                    }
                    if each.isPrescribed?.type == "Not Well"{
                        //if preventer belongs to not well part of action plan
                        notWellName.text = each.name
                        //                        notWellButton.isHidden = false
                        if each.isTablet{
                            //the preventer is a tablet
                            notWellDosage.text = "Take \(each.dosage!) tablets \(each.freq!) times every day"
                            //notWellMedSymbol.image = UIImage(named: "icons8-pill-48")
                        }
                        else{
                            //the preventer is an inhailer
                            notWellDosage.text = "Take \(each.dosage!) puffs \(each.freq!) times every day"
                            // notWellMedSymbol.image = UIImage(named: "inhaler_2")
                        }
                        
                    }
                    if each.isPrescribed?.type == "Worse"{
                        //if preventer belongs to well part of action plan
                        worseName.text = each.name
                        //      worseButton.isHidden = false
                        if each.isTablet{
                            //the preventer is a tablet
                            worseDosage.text = "Take \(each.dosage!) tablets \(each.freq!) times every day"
                            //    worseMedSymbol.image = UIImage(named: "icons8-pill-48")
                        }
                        else{
                            //the preventer is an inhailer
                            worseDosage.text = "Take \(each.dosage!) puffs \(each.freq!) times every day"
                            // worseMedSymbol.image = UIImage(named: "inhaler_2")
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


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


