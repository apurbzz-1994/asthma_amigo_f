//
//  AddDiaryViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 27/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

/*
 This was helpful for creating datepickers
 https://www.youtube.com/watch?v=aa-lNWUVY7g
 */

import UIKit

class AddDiaryViewController: UIViewController {
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var commentField: UITextView!
    
    var day: String = ""
    var month: String = ""
    var year: String = ""
    
    var hour: String = ""
    var minute: String = ""
    
    var datePicker: UIDatePicker?
    var timePicker: UIDatePicker?
    
    @IBOutlet var triggerView: UIView!
    
    //trigger image and name after being selected
    @IBOutlet weak var tLabel: UILabel!
    @IBOutlet weak var tImg: UIImageView!
    
    
    @IBOutlet weak var triggerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide the trigger view
        triggerView.alpha = 0
        tLabel.alpha = 0
        tImg.alpha = 0
        
        // Do any additional setup after loading the view.
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker: )), for: .valueChanged)
        
        //the time picker stuff
        timePicker = UIDatePicker()
        timePicker?.datePickerMode = .time
        timePicker?.addTarget(self, action: #selector(timeChanged(timePicker: )), for: .valueChanged)
        
        
        //adding gesture to dismiss pickers
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer: )))
        
        view.addGestureRecognizer(tapGesture)
        
        dateField.inputView = datePicker
        timeField.inputView = timePicker
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        year = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "MM"
        month = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "dd"
        day = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func timeChanged(timePicker: UIDatePicker){
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h"
        hour = timeFormatter.string(from: timePicker.date)
        timeFormatter.dateFormat = "mm"
        minute = timeFormatter.string(from: timePicker.date)
        timeFormatter.dateFormat = "h:mm a"
        timeField.text = timeFormatter.string(from: timePicker.date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //function for save button
    @IBAction func saveDiaryOnPress(_ sender: Any) {
        print(day)
        print(month)
        print(year)
        print(hour)
        print(minute)
    }
    
    //function for add trigger button
    @IBAction func addTriggerOnPress(_ sender: Any) {
        //make this visible
        
        UIView.animate(withDuration: 0.8, animations: {
            self.addShadow(card: self.triggerView)
            self.triggerView.alpha = 1
        })
        
    }
    
    
    
    
    //trigger buttons
    @IBAction func petTrigger(_ sender: Any) {
        
        UIView.animate(withDuration: 0.8, animations: {
            //trigger view disappears
            self.triggerView.alpha = 0
        })
        
        tLabel.alpha = 1
        tImg.alpha = 1
        
        //trigger name changed to selected trigger
        tLabel.text = "Pet"
        
        //picture changed appropriately
        tImg.image = UIImage(named: "icons8-dog-96")
        
    }
    
    @IBAction func bugTrigger(_ sender: Any) {
        UIView.animate(withDuration: 0.8, animations: {
            //trigger view disappears
            self.triggerView.alpha = 0
        })
        
        tLabel.alpha = 1
        tImg.alpha = 1
        
        //trigger name changed to selected trigger
        tLabel.text = "Bugs"
        
        //picture changed appropriately
        tImg.image = UIImage(named: "icons8-insect-96")
    }
    
    @IBAction func pollenTrigger(_ sender: Any) {
        UIView.animate(withDuration: 0.8, animations: {
            //trigger view disappears
            self.triggerView.alpha = 0
        })
        
        tLabel.alpha = 1
        tImg.alpha = 1
        
        //trigger name changed to selected trigger
        tLabel.text = "Pollen"
        
        //picture changed appropriately
        tImg.image = UIImage(named: "icons8-orchid-96")
        
    }
    
    @IBAction func allergyTrigger(_ sender: Any) {
        UIView.animate(withDuration: 0.8, animations: {
            //trigger view disappears
            self.triggerView.alpha = 0
        })
        
        tLabel.alpha = 1
        tImg.alpha = 1
        
        //trigger name changed to selected trigger
        tLabel.text = "Allergies"
        
        //picture changed appropriately
        tImg.image = UIImage(named: "icons8-vegetarian-food-96")
        
    }
    
    @IBAction func exerciseTrigger(_ sender: Any) {
        UIView.animate(withDuration: 0.8, animations: {
            //trigger view disappears
            self.triggerView.alpha = 0
        })
        
        tLabel.alpha = 1
        tImg.alpha = 1
        
        //trigger name changed to selected trigger
        tLabel.text = "Exercise"
        
        //picture changed appropriately
        tImg.image = UIImage(named: "icons8-pullups-96")
        
    }
    
    @IBAction func weatherTrigger(_ sender: Any) {
        UIView.animate(withDuration: 0.8, animations: {
            //trigger view disappears
            self.triggerView.alpha = 0
        })
        
        tLabel.alpha = 1
        tImg.alpha = 1
        
        //trigger name changed to selected trigger
        tLabel.text = "Weather"
        
        //picture changed appropriately
        tImg.image = UIImage(named: "icons8-winter-96")
    }
    
    
    
    
    
    //reusing function from DashBoardViewController
    func addShadow(card: UIView){
        card.layer.cornerRadius = 8.0
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = .zero
        card.layer.shadowOpacity = 0.6
        card.layer.shadowRadius = 8.0
        card.layer.shadowPath = UIBezierPath(rect: card.bounds).cgPath
        card.layer.shouldRasterize = true
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

