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
        let childData = ["First Name": fNameText.text, "Last Name": lNameText.text, "Age": ageText.text]
        plistHelper.writePlist(namePlist: "contacts", key: "Child", data: childData as AnyObject)
        
        let alertController = UIAlertController(title: "Sucess", message: "The changes have been successfully saved!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fNameText.text = plistHelper.readPlist(namePlist: "contacts", key: "Child")["First Name"] as? String
        lNameText.text = plistHelper.readPlist(namePlist: "contacts", key: "Child")["Last Name"] as? String
        ageText.text = plistHelper.readPlist(namePlist: "contacts", key: "Child")["Age"] as? String
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
