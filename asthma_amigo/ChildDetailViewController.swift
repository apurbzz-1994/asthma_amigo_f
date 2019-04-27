//
//  ChildDetailViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 6/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit
import UserNotifications


class ChildDetailViewController: UIViewController, UNUserNotificationCenterDelegate  {

    @IBOutlet weak var childFName: UITextField!
    @IBOutlet weak var childLName: UITextField!
    @IBOutlet weak var childAge: UITextField!
    
    
    
    //declaring helper object for manipulating plist
    var plistHelper = PListHelper()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UINavigationBar.appearance().tintColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
        
    }
    
    
    @IBAction func finishPress(_ sender: Any) {
        
        if childFName.text != "" && childLName.text != "" && childAge.text != ""{
            let childData = ["First Name": childFName.text, "Last Name": childLName.text, "Age": childAge.text]
            plistHelper.writePlist(namePlist: "contacts", key: "Child", data: childData as AnyObject)
            
            //raising a flag that form has been filled
            plistHelper.writePlist(namePlist: "contacts", key: "isFormDone", data: "y" as AnyObject)
            
            //initial mood flag - set it to None
            plistHelper.writePlist(namePlist: "contacts", key: "Mood", data: "Not set" as AnyObject)
            
            //activating scheduled notification
            scheduleLocal()
            
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
