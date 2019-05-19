//
//  ChildDetailViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 6/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit
import UserNotifications


class ChildDetailViewController: UIViewController, UNUserNotificationCenterDelegate, UITextFieldDelegate  {

    @IBOutlet weak var childFName: UITextField!
    @IBOutlet weak var childLName: UITextField!
    @IBOutlet weak var childAge: UITextField!
    
    
    
    //declaring helper object for manipulating plist
    var plistHelper = PListHelper()
    
    //stores a reference to whichever textfield the user has selected.
    var selectedTextField: UITextField!
    
    
    override func viewDidLoad() {
        
        childFName.delegate = self
        childLName.delegate = self
        childAge.delegate = self
        
        childFName.layer.borderWidth = 1
        childFName.layer.cornerRadius = 8
        childFName.layer.borderColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
        childFName.tintColor = UIColor.black
        
        childLName.layer.borderWidth = 1
        childLName.layer.cornerRadius = 8
        childLName.layer.borderColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
        childLName.tintColor = UIColor.black
        
        childAge.layer.borderWidth = 1
        childAge.layer.cornerRadius = 8
        childAge.layer.borderColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
        childAge.tintColor = UIColor.black
        childAge.keyboardType = UIKeyboardType.numberPad
        
        
        super.viewDidLoad()
        //UINavigationBar.appearance().tintColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
        let tap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(goAwayKeyboard))
        view.addGestureRecognizer(tap )

        // Do any additional setup after loading the view.
        //listeners for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func goAwayKeyboard(){
        view.endEditing(true )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //this generates a category to group notifications
//    func registerCategories(){
//        let center = UNUserNotificationCenter.current()
//        center.delegate = self
//        let show = UNNotificationAction(identifier: "setMood", title: "Set Health", options: .foreground)
//        let category = UNNotificationCategory(identifier: "alarm ", actions: [show] , intentIdentifiers: [], options: [])
//        center.setNotificationCategories([category])
//
//
//    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//
//        if let customData = userInfo["customData"] as? String{
//            print("custom data is: \(customData)")
//
//            switch response.actionIdentifier{
//            case UNNotificationDefaultActionIdentifier :
//                //user just unlocked phone
//                print("default identifier")
//            case "show":
//                //user has decided to set up action plan
//                print("user wants to set up action plan")
//                self.performSegue(withIdentifier: "toHomeSegue", sender: nil)
//            default:
//                break
//
//            }
//        }
//        completionHandler()
//    }
    
    //code for scheduling a notification
    func scheduleLocal(){
        //registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "How is \((plistHelper.readPlist(namePlist: "contacts", key: "Child")["First Name"]!)!) feeling today?"
        content.body = "Set \((plistHelper.readPlist(namePlist: "contacts", key: "Child")["First Name"]!)!)'s health state to get medicine remiders!"
        content.categoryIdentifier = "alarm"
        
        //the date stuff
        var dateComponent = DateComponents()
        dateComponent.hour = 10
        dateComponent.minute = 30
        
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        //time interval for testing
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 120, repeats: true)
        
        let request = UNNotificationRequest(identifier: "healthStatusNotification", content: content, trigger: trigger)
        
        center.add(request)
        
    }
    
    
    @IBAction func finishPress(_ sender: Any) {
        
        if childFName.text != "" && childLName.text != "" && childAge.text != "" && Int(childAge.text!)! < 16{
            let childData = ["First Name": childFName.text, "Last Name": childLName.text, "Age": childAge.text]
            plistHelper.writePlist(namePlist: "contacts", key: "Child", data: childData as AnyObject)
            
            //raising a flag that form has been filled
            plistHelper.writePlist(namePlist: "contacts", key: "isFormDone", data: "y" as AnyObject)
            
            //initial mood flag - set it to None
            plistHelper.writePlist(namePlist: "contacts", key: "Mood", data: "Not set" as AnyObject)
            
            //initial location flag
            plistHelper.writePlist(namePlist: "contacts", key: "isChildWithMe", data: "y" as AnyObject)
            plistHelper.writePlist(namePlist: "contacts", key: "lat", data: "0" as AnyObject)
            plistHelper.writePlist(namePlist: "contacts", key: "long", data: "0" as AnyObject)
            
            //status notification flag
            plistHelper.writePlist(namePlist: "contacts", key: "toBeNotifiedAboutHealth", data: "n" as AnyObject)
            
            //alert notification
             plistHelper.writePlist(namePlist: "contacts", key: "isAlertUpdated", data: "no" as AnyObject)
            
            //set default time
            plistHelper.writePlist(namePlist: "contacts", key: "n_hour", data: "0" as AnyObject)
            plistHelper.writePlist(namePlist: "contacts", key: "n_minute", data: "0" as AnyObject)
            
            
            //activating scheduled notification
           // scheduleLocal()
            
            //confirmation message
            let alertController = UIAlertController(title: "Success", message: "Thank you for filling in the form. You're all set!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler:{
                //perform segue
                action in self.performSegue(withIdentifier: "toHomeSegue", sender: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            
            var errorMessage: String = "Following errors with form: \n"
            
            //validating both fields individually
            if(childFName.text == ""){
                errorMessage.append("Please fill out your child's name \n")
            }
            if(childLName.text == ""){
                errorMessage.append("Please fill out your child's last name \n")
            }
            if(childAge.text == ""){
                errorMessage.append("Please enter your child's age")
            }
            if(childAge.text != ""){
                if(Int(childAge.text!)! > 15){
                    errorMessage.append("This app only supports children aged between 0 to 15.")
                }
            }
          

            
            //display error message
            let alertController = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        }
        
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
