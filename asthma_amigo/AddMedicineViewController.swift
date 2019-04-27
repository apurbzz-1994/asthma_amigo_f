//
//  AddMedicineViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 4/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit

protocol addMedDelegate{
    func sendMedData(name: String, type: String, isTablet: Bool, dosage: String, freq: String)
}

class AddMedicineViewController: UIViewController {
    
    @IBOutlet weak var nameText: UITextField!
    //@IBOutlet weak var typeText: UISegmentedControl!
    @IBOutlet weak var isTabletText: UISegmentedControl!
    @IBOutlet weak var dosageText: UISegmentedControl!
    @IBOutlet weak var freqText: UISegmentedControl!
    @IBOutlet weak var typeText: UILabel!
    @IBOutlet weak var tabOrinhailer: UILabel!
    @IBOutlet weak var medImage: UIImageView!
    @IBOutlet weak var buttonText: UIButton!
    
    
    
    
    //this stores medicine being segued by previous viewcontroller
    var selectedMed: Medicine?
    var isMedEmpty: Bool = true
    
    
    @IBAction func changeTabOrPuff(_ sender: Any) {
        //for switching text. Hope this works!
        if isTabletText.selectedSegmentIndex == 0{
            tabOrinhailer.text = "How many tablets?"
            medImage.image = UIImage(named: "icons8-pill-96")
            //medImage.frame = CGRect(x: 0, y: 0, width: 96, height: 96)
        }
        else if isTabletText.selectedSegmentIndex == 1{
            tabOrinhailer.text = "How many puffs?"
            medImage.image = UIImage(named: "inhaler_2")
            //medImage.frame = CGRect(x: 0, y: 0, width: 96, height: 96)
        }
        else{
            tabOrinhailer.text = "How many tablets?"
        }
    }
    
    
    //for sending over to previous view
    var type: String?
    var isTablet: Bool?
    var dosage: String?
    var freq: String?
    
    var delegate: addMedDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //typeText.text = "Add \(type!)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isMedEmpty == false{
            //is tablet or inhaler?
            if (selectedMed?.isTablet)!{
                isTabletText.selectedSegmentIndex = 0
                tabOrinhailer.text = "How many tablets?"
                medImage.image = UIImage(named: "icons8-pill-96")
                
            }
            else{
                isTabletText.selectedSegmentIndex = 1
                tabOrinhailer.text = "How many puffs?"
                medImage.image = UIImage(named: "inhaler_2")
            }
            
            //name
            nameText.text = selectedMed?.name
            
            //how many dosage?
            dosageText.selectedSegmentIndex = Int((selectedMed?.dosage)!)! - 1
            
            //how many times a day?
            freqText.selectedSegmentIndex = Int((selectedMed?.freq)!)! - 1
            
            //buttontext
            buttonText.setTitle("Save Changes", for: .normal)
        }//<----END OF IF STATEMENT------>
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addMedicineOnPress(_ sender: Any) {
        //Is it preventer or reliever?
//        switch(typeText.selectedSegmentIndex){
//        case 0:
//            type = "Preventer"
//            break
//        case 1:
//            type = "Reliever"
//            break
//        default:
//            type = "Preventer"
//            break
//        }
        
        //Is it tablet or inhaler?
        switch(isTabletText.selectedSegmentIndex){
        case 0:
            isTablet = true
            //tabOrinhailer.text = "How many tablets?"
            break
        case 1:
            isTablet = false
            //tabOrinhailer.text = "How many puffs?"
            break
        default:
            isTablet = true
            //tabOrinhailer.text = "How many tablets?"
            break
        }
        
        //How many dosage?
        switch(dosageText.selectedSegmentIndex){
        case 0:
            dosage = "1"
            break
        case 1:
            dosage = "2"
            break
        case 2:
            dosage = "3"
            break
        case 3:
            dosage = "4"
            break
        case 4:
            dosage = "5"
            break
        case 5:
            dosage = "6"
            break
        default:
            dosage = "1"
            break
        }
        
        //how many times a day?
        switch(freqText.selectedSegmentIndex){
        case 0:
            freq = "1"
            break
        case 1:
            freq = "2"
            break
        case 2:
            freq = "3"
            break
        case 3:
            freq = "4"
            break
        case 4:
            freq = "5"
            break
        case 5:
            freq = "6"
            break
        default:
            freq = "1"
            break
        }
        
        //sending data back
        delegate?.sendMedData(name: nameText.text!, type: "Preventer", isTablet: isTablet!, dosage: dosage!, freq: freq!)
        //pop the view controller
        self.navigationController!.popViewController(animated: true)
        
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
