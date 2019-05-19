//
//  ChildEditViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 11/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit

class ChildEditViewController: UIViewController {
    
    @IBOutlet weak var fNameText: UITextField!
    @IBOutlet weak var lNameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    
    
    //declaring helper object for manipulating plist
    var plistHelper = PListHelper()
    
    @IBAction func saveChange(_ sender: Any) {
        
        
        if fNameText.text != "" && lNameText.text != "" && ageText.text != "" && Int(ageText.text!)! < 16{
            let childData = ["First Name": fNameText.text, "Last Name": lNameText.text, "Age": ageText.text]
            plistHelper.writePlist(namePlist: "contacts", key: "Child", data: childData as AnyObject)
            
            let alertController = UIAlertController(title: "Sucess", message: "The changes have been successfully saved!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            
            var errorMessage: String = "Following errors with form: \n"
            
            //validating both fields individually
            if(fNameText.text == ""){
                errorMessage.append("Please fill out your child's name \n")
            }
            if(lNameText.text == ""){
                errorMessage.append("Please fill out your child's last name \n")
            }
            if(ageText.text == ""){
                errorMessage.append("Please enter your child's age")
            }
            if(ageText.text != ""){
                if(Int(ageText.text!)! > 15){
                    errorMessage.append("This app only supports children aged between 0 to 15.")
                }
            }
            
            
            //display error message
            let alertController = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        }
    
        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(goAwayKeyboard))
        view.addGestureRecognizer(tap )
        
        fNameText.text = plistHelper.readPlist(namePlist: "contacts", key: "Child")["First Name"] as? String
        lNameText.text = plistHelper.readPlist(namePlist: "contacts", key: "Child")["Last Name"] as? String
        ageText.text = plistHelper.readPlist(namePlist: "contacts", key: "Child")["Age"] as? String
        ageText.keyboardType = UIKeyboardType.numberPad
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
