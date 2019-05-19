//
//  aboutViewController.swift
//  asthma_amigo
//
//  Created by Deepika on 2019/5/11.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit

class aboutViewController: UIViewController {
    
    @IBOutlet weak var webLink: UILabel!
    @IBOutlet weak var creativeCommon: UILabel!
    @IBOutlet weak var flatIcon: UILabel!
    @IBOutlet weak var freePIk: UILabel!
    override func loadView() {
        super.loadView()
        
        // This is the key
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClicLabel(sender:)))
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.onClicLabel(sender:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.onClicLabel(sender:)))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.onClicLabel(sender:)))
        webLink.isUserInteractionEnabled = true
        webLink.addGestureRecognizer(tap)
        creativeCommon.isUserInteractionEnabled = true
        creativeCommon.addGestureRecognizer(tap)
        flatIcon.isUserInteractionEnabled = true
        flatIcon.addGestureRecognizer(tap2)
        freePIk.isUserInteractionEnabled = true
        freePIk.addGestureRecognizer(tap3)
    }
    
    // And that's the function :)
    @objc func onClicLabel(sender:UITapGestureRecognizer) {
        openUrl(urlString:"http://www.asthmaamigo.tk")
        
        openUrl1(urlString:"https://www.freepik.com/")
        openUrl2(urlString:"https://www.flaticon.com/")
        openUrl3(urlString:"http://creativecommons.org/licenses/by/3.0/")
    }
    
    
    func openUrl(urlString:String!) {
        let url1 = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url1, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url1)
        }
    }
    func openUrl1(urlString:String!) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    func openUrl2(urlString:String!) {
        let url2 = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url2, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url2)
        }
    }
    func openUrl3(urlString:String!) {
        let url3 = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url3, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url3)
        }
    }
}

