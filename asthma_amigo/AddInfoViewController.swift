//
//  AddInfoViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 6/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

/*
 text count and limiting code attributed to these videos
 https://www.youtube.com/watch?v=-BeQeKVbNJQ&t=675s
 https://www.youtube.com/watch?v=WSgRbH5-GKc
 */

import UIKit

//protocol for sending in data
protocol addInfoDelegate{
    func sendInfoData(info: String)
}

class AddInfoViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var userText: UITextView!
    @IBOutlet weak var characterCount: UILabel!
    
    
    
    var selectedActionPlan: ActionPlan?
    var isInfoEmpty: Bool = true
    
 
    var delegate: addInfoDelegate?
    
    @IBAction func addInfoOnPress(_ sender: Any) {
        delegate?.sendInfoData(info: userText.text)
        
        //pop the view controller
        self.navigationController!.popViewController(animated: true)
        
    }
    
    func checkRemainingCharacters(){
        let allowed = 200
        let remaining = allowed - userText.text.count
        characterCount.text = "Count: \(remaining)"
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkRemainingCharacters()
    }

    override func viewDidLoad() {
        
        //textView(userText, shouldChangeTextIn:NSMakeRange(0, 10), replacementText: "None")
        
        
        let tap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(goAwayKeyboard))
        view.addGestureRecognizer(tap )
        
        super.viewDidLoad()
        userText.layer.borderWidth = 1
        userText.layer.cornerRadius = 10
        
        userText.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @objc func goAwayKeyboard(){
        view.endEditing(true )
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.length + range.location > userText.text.count{
            return false
        }
        
        let newLength = userText.text.count + text.count - range.length
        
        return newLength <= 200
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
