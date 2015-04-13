//
//  HomeViewController.swift
//  CebTeaTime
//
//  Created by tayfun biyikoglu on 05/04/15.
//  Copyright (c) 2015 tayfun biyikoglu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBAction func goToUsers(sender: UIButton) {
        self.performSegueWithIdentifier("users", sender: self)
    }
    
    
    @IBAction func brew(sender: UIButton) {
        self.performSegueWithIdentifier("brew", sender: nil)
    }
    
    
    @IBAction func signOut(sender: UIBarButtonItem) {
        
        let optionMenu = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .ActionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "log out", style: UIAlertActionStyle.Destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            println("User logged out")
            PFUser.logOut()
            self.performSegueWithIdentifier("login", sender: nil)
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
       

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
//            var nav = self.navigationController?.navigationBar
//            nav?.barStyle = UIBarStyle.Black
//            nav?.tintColor = UIColor.redColor()
            title = "Tea Track"

        if PFUser.currentUser() == nil {
            self.performSegueWithIdentifier("login", sender: nil)
        }
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
