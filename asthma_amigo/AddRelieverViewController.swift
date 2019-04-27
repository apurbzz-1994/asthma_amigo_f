//
//  AddRelieverViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 6/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit

protocol addRelieverDelegate{
    func sendRelieverData(name: String, type: String, isTablet: Bool, dosage: String, freq: String)
}

class AddRelieverViewController: UIViewController {
    
    
    //interface elements
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var dosageText: UISegmentedControl!
    @IBOutlet weak var buttonText: UIButton!
    
    
    //this stores medicine being segued by previous viewcontroller
    var selectedMed: Medicine?
    var isMedEmpty: Bool = true

    
    //for sending over to previous view
    var type: String?
    var isTablet: Bool?
    var dosage: String?
    var freq: String?
    
    var delegate: addRelieverDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isMedEmpty == false{
            
            //name
            nameText.text = selectedMed?.name
            
            //how many dosage?
            dosageText.selectedSegmentIndex = Int((selectedMed?.dosage)!)! - 1
                        
            //buttontext
            buttonText.setTitle("Save Changes", for: .normal)
        }//<----END OF IF STATEMENT------>
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
  
    
    @IBAction func addMedicineOnPress(_ sender: Any) {
        
        //this is always an inhaler
        isTablet = false

        
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
        //relievers are taken whenever necessary
        freq = "0"

        
        //sending data back
        delegate?.sendRelieverData(name: nameText.text!, type: "Reliever", isTablet: isTablet!, dosage: dosage!, freq: freq!)
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
