//
//  AddInfoViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 6/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit

//protocol for sending in data
protocol addInfoDelegate{
    func sendInfoData(info: String)
}

class AddInfoViewController: UIViewController {
    
    @IBOutlet weak var userText: UITextView!
    var selectedActionPlan: ActionPlan?
    var isInfoEmpty: Bool = true
    
 
    var delegate: addInfoDelegate?
    
    @IBAction func addInfoOnPress(_ sender: Any) {
        delegate?.sendInfoData(info: userText.text)
        
        //pop the view controller
        self.navigationController!.popViewController(animated: true)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        userText.layer.borderWidth = 1
        userText.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isInfoEmpty == false{
            userText.text = selectedActionPlan?.info
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
