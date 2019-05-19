//
//  MyDetailViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 6/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

/*
 Code for moving text-field
 https://www.youtube.com/watch?v=AiYCStoj0lc
 */

import UIKit

class MyDetailViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var parentFName: UITextField!
    @IBOutlet weak var parentLName: UITextField!
    @IBOutlet weak var parentPNum: UITextField!
    
    
    //declaring helper object for manipulating plist
    var plistHelper = PListHelper()
    
    //stores a reference to whichever textfield the user has selected.
    var selectedTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
        navigationController?.navigationBar.backgroundColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
        
        parentFName.layer.borderWidth = 1
        parentFName.layer.cornerRadius = 8
        parentFName.layer.borderColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
        parentFName.tintColor = UIColor.black
        
        parentLName.layer.borderWidth = 1
        parentLName.layer.cornerRadius = 8
        parentLName.layer.borderColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
        parentLName.tintColor = UIColor.black
        
        parentPNum.layer.borderWidth = 1
        parentPNum.layer.cornerRadius = 8
        parentPNum.layer.borderColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
        parentPNum.tintColor = UIColor.black
        parentPNum.keyboardType = UIKeyboardType.numberPad
        
        //setting delegates
        parentFName.delegate = self
        parentLName.delegate = self
        parentPNum.delegate = self
        
        
        //self.navigationItem.backBarButtonItem?.tintColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(goAwayKeyboard))
        view.addGestureRecognizer(tap )
        
        //listeners for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    @objc func goAwayKeyboard(){
        view.endEditing(true )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    
    @IBAction func onNextPress(_ sender: Any) {
        
        if parentFName.text != "" && parentPNum.text?.count == 10{
            //if all fields have been filled out
            let parentData = ["First Name": parentFName.text, "Last Name": parentLName.text, "Phone Number": parentPNum.text]
            
            //writing to plist
            plistHelper.writePlist(namePlist: "contacts", key: "Parent", data: parentData as AnyObject)
            
            self.performSegue(withIdentifier: "childSegue", sender: nil)
        }
        else{
            var errorMessage: String = ""
            
            //validating both fields individually
            if(parentFName.text == ""){
                errorMessage.append("Please fill out your First Name to continue. \n")
            }
//            if(parentLName.text == ""){
//                errorMessage.append("Please fill out your last name \n")
//            }
            if((parentPNum.text!.count) != 10){
                errorMessage.append("Please enter a valid phone number.")
            }
            
            //display error message
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
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
