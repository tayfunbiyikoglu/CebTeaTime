//
//  UserViewController.swift
//  CebTeaTime
//
//  Created by tayfun biyikoglu on 09/04/15.
//  Copyright (c) 2015 tayfun biyikoglu. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    
    var selectedUser:UserTableViewController.Brewer?
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var myView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circulizeImage()
        
        if selectedUser != nil {
            title = selectedUser?.userName
            testLabel.text = selectedUser?.userName
            profilePic.image = UIImage(data: selectedUser?.user["image"] as! NSData)
            if selectedUser?.user["approved"] as! String == "1" {
                statusSwitch.on = true
            }else{
                statusSwitch.on = false
            }

            if (PFUser.currentUser()["isAdmin"] as! String  == "0") {
                myView.alpha = 0
            }
        }

        // Do any additional setup after loading the view.
    }


    
    @IBAction func statusChanged(sender: UISwitch) {
        var user = selectedUser?.user
        let params = NSMutableDictionary()
        var status:String = "0"
        
        if sender.on {
            status = "1"
        }else{
            status = "0"
        }
        
        params.setObject( status, forKey: "approved" )
        params.setObject( user!.objectId, forKey: "userId" )
        
        PFCloud.callFunctionInBackground("editUser", withParameters: params as [NSObject : AnyObject], block: {
            (result: AnyObject!, error: NSError!) -> Void in
            if ( error === nil) {
                NSLog("Approved Status: \(result) ")
            }
            else if (error != nil) {
                NSLog("error")
            }
        });
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func circulizeImage() {
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
        self.profilePic.layer.borderWidth = 1.0;
        self.profilePic.layer.borderColor = UIColor.grayColor().CGColor
        self.profilePic.clipsToBounds = true
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
