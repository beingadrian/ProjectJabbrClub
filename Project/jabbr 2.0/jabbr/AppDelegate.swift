//
//  AppDelegate.swift
//  jabbr
//
//  Created by Adrian Wisaksana on 9/19/15.
//  Copyright © 2015 BeingAdrian. All rights reserved.
//

import UIKit
import MMX
import Foundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        if launchOptions != nil {
            
        }
        
        AGSGTGeotriggerManager.setupWithClientId("QfZcP236gBSfHFuK", isProduction: false, completion: {(error: NSError?) in
            if error != nil {
                print("Geotrigger Service setup encountered error: %@", error)
            }
            else {
                print("Good to go!")
            }
            AGSGTGeotriggerManager.sharedManager().trackingProfile = kAGSGTTrackingProfileAdaptive

            
        })
        
        AGSGTApiClient.sharedClient().setAuthorizationHeaderWithToken("pMAvKagUvgGH0wEOjk_3mmyZPWfI5fB-1NYs341hyjkkOF5Q_VGTZIfaBLuwRyJqO2TXxKcc63WGTy7cZboZ7dAnjsI2F_Bh2XZgevPNi6BPH8QPLl0z2XQXUV_CbM43jLeIvY21YMCPjMHkG-o_Hg..")
        
        // Initialize Magnet Message
        MMX.setupWithConfiguration("default")
        MMXLogger.sharedLogger().level = .Verbose
        MMXLogger.sharedLogger().startLogging()
        
        // set tab bar to white
        UITabBar.appearance().barTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
//        UITabBar.appearance().tintColor = UIColor(red: 72/255, green: 178/255, blue: 232/255, alpha: 1)
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

