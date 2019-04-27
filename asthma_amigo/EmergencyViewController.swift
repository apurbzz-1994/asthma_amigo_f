//
//  EmergencyViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 7/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit

class EmergencyViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    //declaring helper object for manipulating plist
    var plistHelper = PListHelper()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.text = "Please consult Doctor \((plistHelper.readPlist(namePlist: "contacts", key: "Doctor")["Phone Number"]!)!)"
        emailLabel.text = "Email: \((plistHelper.readPlist(namePlist: "contacts", key: "Doctor")["Email"]!)!)"

        // Do any additional setup after loading the view.
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
