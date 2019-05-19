//
//  AppDelegate.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 3/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import GooglePlaces
import IQKeyboardManagerSwift
//import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()
    
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //code for user to authorize getting notifications
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            }
            else{
                print("Fuck!")
            }
        }
        
        //Setting Google Place API for autocomplete feature
        GMSPlacesClient.provideAPIKey("AIzaSyD3641J2yUNog1As0l0s8zfHX7271yjJAY")
        
        
        //setting core location permission
        //locationManager.requestAlwaysAuthorization()
        
        //keyboard stuff
        IQKeyboardManager.shared.enable = true
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
 

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "asthma_amigo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    // This function will be called when the app receive notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // show the notification alert (banner), and with sound
        completionHandler([.alert, .sound])
    }
    
    // This function will be called right after user tap on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let notificationID = response.notification.request.identifier
        
        if notificationID == "healthStatusNotification"{
            //this is for setting up every morning
            if let homeVC = storyBoard.instantiateViewController(withIdentifier: "TabBarView") as? MainTabBarController,
                let rootNavVC = self.window?.rootViewController as? UINavigationController{
                rootNavVC.pushViewController(homeVC, animated: true)
            }
        }
        else if notificationID.prefix(7) == "weather"{
            //redirect to alerts page
            if let homeVC = storyBoard.instantiateViewController(withIdentifier: "weatherAlert") as? WeatherWarningTableViewController,
                let rootNavVC = self.window?.rootViewController as? UINavigationController{
                rootNavVC.pushViewController(homeVC, animated: true)
            }
            
        }
        else{
            //call the rootController which is a navigation controller in my case
            if let reminderVC = storyBoard.instantiateViewController(withIdentifier: "RemindersView") as? RemindersViewController,
                let rootNavVC = self.window?.rootViewController as? UINavigationController{
                rootNavVC.pushViewController(reminderVC, animated: true)
            }
        }

        


         //tell the app that we have finished processing the user’s action / response
        completionHandler()
    }
}

