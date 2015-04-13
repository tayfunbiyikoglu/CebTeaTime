//
//  WaitingViewController.swift
//  CebTeaTime
//
//  Created by tayfun biyikoglu on 05/04/15.
//  Copyright (c) 2015 tayfun biyikoglu. All rights reserved.
//

import UIKit

class WaitingViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func refresh(sender: UIButton) {
        refresh()
    }
    
    
    func refresh(){
        
        if PFUser.currentUser() != nil {
            
            var query = PFQuery(className:"_User")
            query.whereKey("objectId", equalTo: PFUser.currentUser().objectId)
            
            query.getFirstObjectInBackgroundWithBlock {
                (user: PFObject!, error: NSError!) -> Void in
                if error == nil {
                    // The find succeeded.
                    NSLog("Successfully retrieved \(user.objectId) user.")
                    
                    
                    var userVerified = user.objectForKey("approved") as! NSString
                    println(userVerified)
                    
                    if(userVerified == "1"){
                        self.performSegueWithIdentifier("home", sender: self)
                        println("User is verified")
                    }else{
                        println("Still not verified")                    }
                    
                }else{
                    println(error)
                }
                
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
