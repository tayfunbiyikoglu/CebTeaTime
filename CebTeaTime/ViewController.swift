//
//  ViewController.swift
//  CebTeaTime
//
//  Created by tayfun biyikoglu on 03/04/15.
//  Copyright (c) 2015 tayfun biyikoglu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
   
    @IBOutlet weak var loginCancelledLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if PFUser.currentUser() != nil {
            println("User logged In")
        }
        
    }
    
    
    @IBAction func signin(sender: UIButton) {
        
        var permissions = ["public_profile"]
        
        self.loginCancelledLabel.alpha = 0
        
        
        PFFacebookUtils.logInWithPermissions(permissions, block: {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
                
                self.loginCancelledLabel.alpha = 1
                
            } else if user.isNew {
                NSLog("User signed up and logged in through Facebook!")
                
                self.performSegueWithIdentifier("signUp", sender: self)
                
            } else {
                NSLog("User logged in through Facebook!")
                
                
            }
            
        })

    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

