//
//  MyEditViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 11/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit

class MyEditViewController: UIViewController {
    
    @IBOutlet weak var fNameText: UITextField!
    @IBOutlet weak var lNameText: UITextField!
    @IBOutlet weak var pNoText: UITextField!
    
    //declaring helper object for manipulating plist
    var plistHelper = PListHelper()
    
    @IBAction func saveChange(_ sender: Any) {
        
        if fNameText.text != "" && pNoText.text?.count == 10{
            //if all fields have been filled out
            let parentData = ["First Name": fNameText.text, "Last Name": lNameText.text, "Phone Number": pNoText.text]
            
            //writing to plist
            plistHelper.writePlist(namePlist: "contacts", key: "Parent", data: parentData as AnyObject)
            
            let alertController = UIAlertController(title: "Sucess", message: "The changes have been successfully saved!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            var errorMessage: String = ""
            
            //validating both fields individually
            if(fNameText.text == ""){
                errorMessage.append("Please fill out your First Name to continue. \n")
            }
            //            if(parentLName.text == ""){
            //                errorMessage.append("Please fill out your last name \n")
            //            }
            if((pNoText.text!.count) != 10){
                errorMessage.append("Please enter a valid phone number.")
            }
            
            //display error message
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        
        //commentField.layer.borderWidth = 1
        //commentField.layer.cornerRadius = 10
        //commentField.tintColor = UIColor.black
        
        fNameText.layer.cornerRadius = 15
        fNameText.tintColor = UIColor.black
        
        lNameText.layer.cornerRadius = 15
        lNameText.tintColor = UIColor.black
        
        pNoText.layer.cornerRadius = 15
        pNoText.tintColor = UIColor.black
        pNoText.keyboardType = UIKeyboardType.numberPad
        
        let tap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(goAwayKeyboard))
        view.addGestureRecognizer(tap )
        
        super.viewDidLoad()
        fNameText.text = plistHelper.readPlist(namePlist: "contacts", key: "Parent")["First Name"] as? String
        lNameText.text = plistHelper.readPlist(namePlist: "contacts", key: "Parent")["Last Name"] as? String
        pNoText.text = plistHelper.readPlist(namePlist: "contacts", key: "Parent")["Phone Number"] as? String

        // Do any additional setup after loading the view.
    }
    
    @objc func goAwayKeyboard(){
        view.endEditing(true )
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
