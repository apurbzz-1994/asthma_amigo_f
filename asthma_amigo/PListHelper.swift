//
//  PListHelper.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 3/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

/*
 This code was adapted from the following github repository:
 https://github.com/soonin/IOS-Swift-PlistReadAndWrite/blob/master/IOS-Swift-PlistReadAndWrite/PlistReadAndWrite.swift
*/

import UIKit

class PListHelper: NSObject {
    func readPlist(namePlist: String, key: String) -> AnyObject{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(namePlist+".plist")
        
        var output:AnyObject = false as AnyObject
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            output = dict.object(forKey: key)! as AnyObject
        }else{
            if let privPath = Bundle.main.path(forResource: namePlist, ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    //<---new--->
                    if dict.object(forKey: key) == nil{
                        output = "n" as AnyObject
                        return output
                    }
                    //<---end new code--->
                    output = dict.object(forKey: key)! as AnyObject
                }else{
                    output = false as AnyObject
                    print("error_read")
                }
            }else{
                output = false as AnyObject
                print("error_read")
            }
        }
        print("plist_read \(output)")
        return output
    }
    
    func writePlist(namePlist: String, key: String, data: AnyObject){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(namePlist+".plist")
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            dict.setObject(data, forKey: key as NSCopying)
            if dict.write(toFile: path, atomically: true){
                print("plist_write")
            }else{
                print("plist_write_error")
            }
        }else{
            if let privPath = Bundle.main.path(forResource: namePlist, ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    dict.setObject(data, forKey: key as NSCopying)
                    if dict.write(toFile: path, atomically: true){
                        print("plist_write")
                    }else{
                        print("plist_write_error")
                    }
                }else{
                    print("plist_write")
                }
            }else{
                print("error_find_plist")
            }
        }
    }
}
