//
//  MedicineViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 4/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit

class MedicineViewController: UIViewController {
    
    var selectedActionPlan: ActionPlan?
    var medicineList: [Medicine]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        medicineList = selectedActionPlan?.contains?.allObjects as? [Medicine]
        
        for each in medicineList!{
            print(each.type)
        }
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
