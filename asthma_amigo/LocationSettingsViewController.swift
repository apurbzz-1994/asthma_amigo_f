//
//  LocationSettingsViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 4/5/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationSettingsViewController: UIViewController {
    
    
    @IBOutlet weak var childLabel: UILabel!
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var saveButtonLabel: UIButton!
    @IBOutlet weak var customLocationCard: UIView!
    
    @IBOutlet weak var locationSwitch: UISwitch!
    
    
    var lat: Double?
    var long: Double?
    var address: String = "-"
    
    
    
    //declaring helper object for manipulating plist
    var plistHelper = PListHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
        navigationController?.navigationBar.backgroundColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let locChoiceState = plistHelper.readPlist(namePlist: "contacts", key: "isChildWithMe")

        if locChoiceState as! String == "n"{
            if locationLabel.text == ""{
                plistHelper.writePlist(namePlist: "contacts", key: "isChildWithMe", data: "y" as AnyObject)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let locChoiceState = plistHelper.readPlist(namePlist: "contacts", key: "isChildWithMe")
        
        if locChoiceState as! String == "y"{

            if locationLabel.text != ""{
                locationSwitch.isOn = true
                locationLabel.isEnabled = true
                saveButtonLabel.isEnabled = true
                customLocationCard.alpha = 1

                //fix the bug here
                if address == "-"{
                    locationLabel.text = (plistHelper.readPlist(namePlist: "contacts", key: "address") as! String)
                }
                else{
                    locationLabel.text = address
                }

            }
            else{
                //location set to device location
                //disable option for setting custom location
                //choiceSegment.selectedSegmentIndex = 0
                locationSwitch.isOn = false
                locationLabel.isEnabled = false
                saveButtonLabel.isEnabled = false
                customLocationCard.alpha = 0.439216
            }
           
        }
        else {
            //choiceSegment.selectedSegmentIndex = 1
            locationSwitch.isOn = true
            locationLabel.isEnabled = true
            saveButtonLabel.isEnabled = true
            customLocationCard.alpha = 1
            
            
            //fix the bug here
            if address == "-"{
                locationLabel.text = (plistHelper.readPlist(namePlist: "contacts", key: "address") as! String)
            }
            else{
                locationLabel.text = address
            }
            
            
        }
    }
    
    
    @IBAction func locationSwitchOnPressed(_ sender: UISwitch) {
        if sender.isOn == true{
            //custom user location
            //choiceSegment.selectedSegmentIndex = 1
            locationLabel.isEnabled = true
            saveButtonLabel.isEnabled = true
            customLocationCard.alpha = 1
            
            plistHelper.writePlist(namePlist: "contacts", key: "isChildWithMe", data: "n" as AnyObject)
        }
        else{
            //choiceSegment.selectedSegmentIndex = 0
            locationLabel.isEnabled = false
            saveButtonLabel.isEnabled = false
            customLocationCard.alpha = 0.439216
            
            //location to device location
            plistHelper.writePlist(namePlist: "contacts", key: "isChildWithMe", data: "y" as AnyObject)
            plistHelper.writePlist(namePlist: "contacts", key: "lat", data: "0" as AnyObject)
            plistHelper.writePlist(namePlist: "contacts", key: "long", data: "0" as AnyObject)
        }
    }
    
    
    
    
//    @IBAction func locationSegmentOnTapped(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex {
//        case 0:
//            choiceSegment.selectedSegmentIndex = 0
//            locationLabel.isEnabled = false
//            saveButtonLabel.isEnabled = false
//            customLocationCard.alpha = 0.439216
//
//            //location to device location
//            plistHelper.writePlist(namePlist: "contacts", key: "isChildWithMe", data: "y" as AnyObject)
//            plistHelper.writePlist(namePlist: "contacts", key: "lat", data: "0" as AnyObject)
//            plistHelper.writePlist(namePlist: "contacts", key: "long", data: "0" as AnyObject)
//            break
//        case 1:
//           //custom user location
//            choiceSegment.selectedSegmentIndex = 1
//            locationLabel.isEnabled = true
//            saveButtonLabel.isEnabled = true
//            customLocationCard.alpha = 1
//
//            plistHelper.writePlist(namePlist: "contacts", key: "isChildWithMe", data: "n" as AnyObject)
//            break
//        default:
//            choiceSegment.selectedSegmentIndex = 0
//            locationLabel.isEnabled = false
//            saveButtonLabel.isEnabled = false
//            customLocationCard.alpha = 0.439216
//
//            break
//        }
//    }
    
    @IBAction func saveCustomLocOnPress(_ sender: Any) {
        
        if locationLabel.text != ""{
            plistHelper.writePlist(namePlist: "contacts", key: "lat", data: lat as AnyObject)
            plistHelper.writePlist(namePlist: "contacts", key: "long", data: long as AnyObject)
            plistHelper.writePlist(namePlist: "contacts", key: "address", data: address as AnyObject)
            plistHelper.writePlist(namePlist: "contacts", key: "isChildWithMe", data: "n" as AnyObject)
            
            //add a confirm message dialogue box
            //also add validation for empty address field.
            let alertController = UIAlertController(title: "Saved Successfully", message: "The changes will now be reflected on the home page.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler:{
                //perform segue
                action in
            }))
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            var errorMessage: String = ""
            
            if(locationLabel.text == ""){
                errorMessage.append("Location is required.")
            }
            
            //display error message
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
       

    }
    
    @IBAction func addLocationOnTap(_ sender: Any) {
        locationLabel.resignFirstResponder()
        
        //create a new view controller for displaying autocomplete view
        let autoCompleteController = GMSAutocompleteViewController()
        
        //setting filter to australia only--------------
        let filter = GMSAutocompleteFilter()
        filter.country = "AU"
        
        autoCompleteController.autocompleteFilter = filter
        //------------------------------------------------
        
        autoCompleteController.delegate = self as? GMSAutocompleteViewControllerDelegate
        
        //present the controller on tap
        present(autoCompleteController, animated: true, completion: nil)
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

extension LocationSettingsViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        locationLabel.text = place.formattedAddress
       // ChoiceDLabel.text = "lat: \(place.coordinate.latitude.description) long: \(place.coordinate.longitude.description)"
        address = place.formattedAddress!
        lat = place.coordinate.latitude
        long = place.coordinate.longitude
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}
