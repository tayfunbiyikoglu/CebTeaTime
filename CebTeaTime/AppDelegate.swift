//
//  AppDelegate.swift
//  CebTeaTime
//
//  Created by tayfun biyikoglu on 03/04/15.
//  Copyright (c) 2015 tayfun biyikoglu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    /* Changed
    
    application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
    
    to
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    
    */
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        
        
        application.applicationIconBadgeNumber = 0
        Parse.setApplicationId("qyMjAwkhLDDcwFt9gedcWplmZOBqxJjhxHa0yjfv", clientKey: "vf489jsQdkoQHdp5B0SAvB1jmLiYwTekj64RKt12")
        
        PFFacebookUtils.initializeFacebook()
        

//        let userNotificationTypes = (UIUserNotificationType.Alert |  UIUserNotificationType.Badge |  UIUserNotificationType.Sound);
//        
//        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
//        application.registerUserNotificationSettings(settings)
//        application.registerForRemoteNotifications()
        
        // Register for Push Notitications, if running iOS 8
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let types:UIUserNotificationType = (.Alert | .Badge | .Sound)
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
        } else {
            // Register for Push Notifications before iOS 8
            application.registerForRemoteNotificationTypes(.Alert | .Badge | .Sound)
        }

        
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        println("didRegisterForRemoteNotificationsWithDeviceToken")
        
        let currentInstallation = PFInstallation.currentInstallation()
        
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.channels = ["ceb"]

        currentInstallation.saveInBackgroundWithBlock { (succeeded, e) -> Void in
            //code
        }

    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
         println("failed to register for remote notifications:  \(error)")
    }
    
    // Changed UIApplication! to UIApplication
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    // Changed UIApplication! to UIApplication
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    // Changed UIApplication! to UIApplication
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        application.applicationIconBadgeNumber = 0
    }
    
    // Changed UIApplication! to UIApplication
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /*  Changed
    
    func application(application: UIApplication, openURL url: NSURL,
    sourceApplication: NSString, annotation: AnyObject) -> Bool {
    
    to
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
    
    */
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication,
            withSession:PFFacebookUtils.session())
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        println("didReceiveRemoteNotification")
        PFPush.handlePush(userInfo)
        var brewInfo = HomeViewController.BrewInfo.last()
        var date = NSDate()
        let minsToBrew = 18 - date.minutesFrom(brewInfo.brewDate)
        var brewUser = brewInfo.brewUser as PFUser
        var brewedBy = brewUser["name"] as! String
        var nameArray = brewedBy.componentsSeparatedByString(" ")
        let secondsToBrew:Int = 60 * minsToBrew
        var localNotification = UILocalNotification()
        println("\(secondsToBrew) seconds")
        localNotification.fireDate = NSDate(timeIntervalSinceNow: NSTimeInterval(secondsToBrew))
        var currentUserName = PFUser.currentUser().objectForKey("name") as! String
        if(currentUserName == brewedBy) {
            brewedBy = "you"
        }else{
            brewedBy = brewedBy.componentsSeparatedByString(" ")[0] as String
        }
        localNotification.alertBody = "Tea brewed by \(brewedBy) is ready, enjoy.."
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        localNotification.soundName = UILocalNotificationDefaultSoundName
        
        application.scheduleLocalNotification(localNotification)
    }
    
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        println("didReceiveLocalNotification")
        application.applicationIconBadgeNumber = 0
    }
    
    
}

