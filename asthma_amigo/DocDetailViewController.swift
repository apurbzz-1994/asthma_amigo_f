//
//  DocDetailViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 6/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit

class DocDetailViewController: UIViewController {

    @IBOutlet weak var docFName: UITextField!
    @IBOutlet weak var docLName: UITextField!
    @IBOutlet weak var docPNum: UITextField!
    @IBOutlet weak var docEmail: UITextField!
    
    
    
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
        
        if docFName.text != "" && docLName.text != "" && docPNum.text != "" && docEmail.text != ""{
            //if all fields have been filled out
            let doctorData = ["First Name": docFName.text, "Last Name": docLName.text, "Phone Number": docPNum.text, "Email": docEmail.text]
            
            plistHelper.writePlist(namePlist: "contacts", key: "Doctor", data: doctorData as AnyObject)
            
            self.performSegue(withIdentifier: "childSegue", sender: nil)
        }
        else{
            var errorMessage: String = "Following errors with form: \n"
            
            //validating both fields individually
            if(docFName.text == ""){
                errorMessage.append("Please fill out your doctor's name \n")
            }
            if(docLName.text == ""){
                errorMessage.append("Please fill out your doctor's last name \n")
            }
            if(docPNum.text == ""){
                errorMessage.append("Please enter your doctor's phone number \n")
            }
            if(docEmail.text == ""){
                errorMessage.append("Please enter your doctor's email")
            }
            
            //display error message
            let alertController = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    
 
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "childSegue"{
//            let doctorData = ["First Name": docFName.text, "Last Name": docLName.text, "Phone Number": docPNum.text, "Email": docEmail.text]
//            let destination = segue.destination as! ChildDetailViewController
//            destination.parentData = parentData
//            destination.doctorData = doctorData as! [String : String]
//
//        }
//    }
//

}
