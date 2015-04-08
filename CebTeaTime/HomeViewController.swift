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
    
    
    @IBAction func logOff(sender: UIButton) {
        PFUser.logOut()
        self.performSegueWithIdentifier("login", sender: nil)
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
