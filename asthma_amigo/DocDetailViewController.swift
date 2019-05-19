//
//  DocDetailViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 6/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit

class DocDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var docFName: UITextField!
    @IBOutlet weak var docLName: UITextField!
    @IBOutlet weak var docPNum: UITextField!
    @IBOutlet weak var docEmail: UITextField!
    
    //stores a reference to whichever textfield the user has selected.
    var selectedTextField: UITextField!
    
    
    
    //declaring helper object for manipulating plist
    var plistHelper = PListHelper()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.backBarButtonItem?.tintColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
        
        
        docFName.delegate = self
        docLName.delegate = self
        docPNum.delegate = self
        docEmail.delegate = self
    
        
        let tap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(goAwayKeyboard))
        view.addGestureRecognizer(tap )


        // Do any additional setup after loading the view.
        //listening for keyboard events
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // Do any additional setup after loading the view.
        
        //listeners for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
//    }
    
    @objc func goAwayKeyboard(){
        view.endEditing(true )
    }
    
    @objc func keyboardShow(notification: Notification){
        let info:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        
        let editingTextFieldY:CGFloat = (self.selectedTextField?.frame.origin.y)!
        
        if self.view.frame.origin.y >= 0 {
            //Checking if the textfield is really hidden behind the keyboard
            if editingTextFieldY > keyboardY - 90 {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY - (keyboardY - 90)), width: self.view.bounds.width,height: self.view.bounds.height)
                }, completion: nil)
            }
        }
    }
    
    //when the keyboard gets hidden, the whole view needs to move to its original axis.
    @objc func keyboardHide(notification: Notification){
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            //move the view to origin
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //remove observers
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //lets you know which textfield the user is working on
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
    }
    
    //this makes the keyboard disappear when the return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    @objc func keyboardWillChange(notification: Notification){
//        print("Keyboard will show: \(notification.name.rawValue)")
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onNextPress(_ sender: Any) {
        
//        if docFName.text != "" && docLName.text != "" && docPNum.text != ""{
//            //if all fields have been filled out
//            let doctorData = ["First Name": docFName.text, "Last Name": docLName.text, "Phone Number": docPNum.text, "Email": docEmail.text]
//
//            plistHelper.writePlist(namePlist: "contacts", key: "Doctor", data: doctorData as AnyObject)
//
//            self.performSegue(withIdentifier: "childSegue", sender: nil)
//        }
//        else{
//            var errorMessage: String = "Following errors with form: \n"
//
//            //validating both fields individually
//            if(docFName.text == ""){
//                errorMessage.append("Please fill out your doctor's name \n")
//            }
//            if(docLName.text == ""){
//                errorMessage.append("Please fill out your doctor's last name \n")
//            }
//            if(docPNum.text == ""){
//                errorMessage.append("Please enter your doctor's phone number \n")
//            }
//            if(docEmail.text == ""){
//                errorMessage.append("Please enter your doctor's email")
//            }
//
//            //display error message
//            let alertController = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
//            alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alertController, animated: true, completion: nil)
//        }
        
        let doctorData = ["First Name": docFName.text, "Last Name": docLName.text, "Phone Number": docPNum.text, "Email": docEmail.text]
        
        plistHelper.writePlist(namePlist: "contacts", key: "Doctor", data: doctorData as AnyObject)
        
        self.performSegue(withIdentifier: "childSegue", sender: nil)
        
        
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
