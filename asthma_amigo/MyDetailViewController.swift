//
//  MyDetailViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 6/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit

class MyDetailViewController: UIViewController {
    
    
    @IBOutlet weak var parentFName: UITextField!
    @IBOutlet weak var parentLName: UITextField!
    @IBOutlet weak var parentPNum: UITextField!
    
    
    //declaring helper object for manipulating plist
    var plistHelper = PListHelper()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.backBarButtonItem?.tintColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    
    @IBAction func onNextPress(_ sender: Any) {
        
        if parentFName.text != "" && parentLName.text != "" && parentPNum.text != ""{
            //if all fields have been filled out
            let parentData = ["First Name": parentFName.text, "Last Name": parentLName.text, "Phone Number": parentPNum.text]
            
            //writing to plist
            plistHelper.writePlist(namePlist: "contacts", key: "Parent", data: parentData as AnyObject)
            
            self.performSegue(withIdentifier: "docSegue", sender: nil)
        }
        else{
            var errorMessage: String = "Following errors with form: \n"
            
            //validating both fields individually
            if(parentFName.text == ""){
                errorMessage.append("Please fill out your name \n")
            }
            if(parentLName.text == ""){
                errorMessage.append("Please fill out your last name \n")
            }
            if(parentPNum.text == ""){
                errorMessage.append("Please enter your phone number")
            }
            
            //display error message
            let alertController = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      //  if segue.identifier == "docSegue"{
      //      let parentData = ["First Name": parentFName.text, "Last Name": parentLName.text, "Phone Number": parentPNum.text]
          //  let destination = segue.destination as! DocDetailViewController
           // destination.parentData = parentData as! [String : String]
            
        //}
   // }
    

}
