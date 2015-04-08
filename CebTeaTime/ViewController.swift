//
//  ViewController.swift
//  CebTeaTime
//
//  Created by tayfun biyikoglu on 03/04/15.
//  Copyright (c) 2015 tayfun biyikoglu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
   
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var loginCancelledLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.image.layer.cornerRadius = self.image.frame.size.width / 2;
        self.image.layer.borderWidth = 3.0;
        self.image.layer.borderColor = UIColor.whiteColor().CGColor
        self.image.clipsToBounds = true

        
    }
    
    override func viewDidAppear(animated: Bool) {
        proceedNextScreen()
    }
    
    @IBAction func signin(sender: UIButton) {
        
        var permissions = ["public_profile","email"]
        
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
                
                self.proceedNextScreen()
            }
            
        })

    }
    
    func proceedNextScreen(){
        
        if PFUser.currentUser() != nil {
            
            var query = PFQuery(className:"_User")
            query.whereKey("objectId", equalTo: PFUser.currentUser().objectId)
            
            query.getFirstObjectInBackgroundWithBlock {
                (user: PFObject!, error: NSError!) -> Void in
                if error == nil {
                    // The find succeeded.
                    NSLog("Successfully retrieved \(user.objectId) user.")
                    
                    
                    var userVerified = user.objectForKey("approved") as NSString
                    println(userVerified)
                    
                    if(userVerified == "1"){
//                        self.performSegueWithIdentifier("home", sender: self)
                        self.dismissViewControllerAnimated(true, completion:nil)
                        println("User is verified")
                    }else{
                        self.performSegueWithIdentifier("waiting", sender: self)                    }
                    
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


}

