////
////  DiaryViewController.swift
////  asthma_amigo
////
////  Created by Apurba Nath on 27/4/19.
////  Copyright © 2019 Apurba Nath. All rights reserved.
////
//
//import UIKit
//
//class DiaryViewController: UIViewController {
//
//    @IBOutlet weak var diaryCardView: UIView!
//    @IBOutlet weak var monthLabel: UILabel!
//    @IBOutlet weak var dayLabel: UILabel!
//    @IBOutlet weak var locationLabel: UILabel!
//    @IBOutlet weak var timeLabel: UILabel!
//    @IBOutlet weak var triggerLabel: UILabel!
//
//
//    var isActive: Bool = false
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        navigationController?.navigationBar.barTintColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
//        navigationController?.navigationBar.backgroundColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
//        navigationController?.navigationBar.tintColor = UIColor.white
//
//        addShadow(card: diaryCardView)
//
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        if isActive == false{
//            diaryCardView.alpha = 0
//        }
//        else{
//            diaryCardView.alpha = 1
//        }
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    //reusing function from DashBoardViewController
//    func addShadow(card: UIView){
//        card.layer.cornerRadius = 8.0
//        card.layer.shadowColor = UIColor.black.cgColor
//        card.layer.shadowOffset = .zero
//        card.layer.shadowOpacity = 0.6
//        card.layer.shadowRadius = 8.0
//        card.layer.shadowPath = UIBezierPath(rect: card.bounds).cgPath
//        card.layer.shouldRasterize = true
//    }
//
//    func sendDiaryData(location: String, day: String, month: String, time: String, isActivated: Bool, trigger: String) {
//        isActive = isActivated
//
//        locationLabel.text = location
//        timeLabel.text = time
//        dayLabel.text = day
//        triggerLabel.text = "Trigger: \(trigger)"
//        if month == "01"{
//            monthLabel.text = "January"
//        }
//        else if month == "02"{
//            monthLabel.text = "February"
//        }
//        else if month == "03"{
//            monthLabel.text = "March"
//        }
//        else if month == "04"{
//            monthLabel.text = "April"
//        }
//        else if month == "05"{
//            monthLabel.text = "May"
//        }
//        else if month == "06"{
//            monthLabel.text = "June"
//        }
//        else if month == "07"{
//            monthLabel.text = "July"
//        }
//        else if month == "08"{
//            monthLabel.text = "August"
//        }
//        else if month == "09"{
//            monthLabel.text = "September"
//        }
//        else if month == "10"{
//            monthLabel.text = "October"
//        }
//        else if month == "11"{
//            monthLabel.text = "November"
//        }
//        else {
//            monthLabel.text = "December"
//        }
//    }
//
//
//
//     // MARK: - Navigation
//
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
////     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        let controller: AddDiaryViewController = segue.destination as! AddDiaryViewController
////        controller.delegate = self
////     }
//
//
//}
