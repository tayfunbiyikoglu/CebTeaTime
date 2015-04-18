//
//  HomeViewController.swift
//  CebTeaTime
//
//  Created by tayfun biyikoglu on 05/04/15.
//  Copyright (c) 2015 tayfun biyikoglu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    enum TeaStates {
        case NoTea, Brewing, Brewed
        
        init(){
            self = .NoTea
        }
    }
    
    class BrewInfo {
        
        var brewDate:NSDate
        var brewUser:PFUser
        var teaState:TeaStates {
            let mins = NSDate().minutesFrom(brewDate)
            println("\(mins)")
            switch mins {
            case 0..<16 : return .Brewing
            case 16...130 : return .Brewed
            default:  return .NoTea
            }

        }
        
        init(brewing: PFObject){
            self.brewDate = brewing.objectForKey("brewDateTime") as! NSDate
            self.brewUser = brewing.objectForKey("user") as! PFUser
        }
        
        func explanation() -> String {
            switch self.teaState {
            case .NoTea: return "We don't have tea"
            case .Brewing: return "Tea will be ready in \(16 - NSDate().minutesFrom(brewDate))"
            case .Brewed: return "We have tea"
            }
        }
        
        class func last() -> BrewInfo {
            var query = PFQuery(className: "Brewing")
            query.orderByDescending("brewDateTime")
            return BrewInfo(brewing: query.getFirstObject())
        }
    }
    
    @IBOutlet weak var statusView: UIView!
    
    
    @IBOutlet weak var explanationLabel: UILabel!
    
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

        var brewInfo = BrewInfo.last()
        println("\(brewInfo.brewDate) - \(brewInfo.brewUser) - \(brewInfo.teaState)")
        
        explanationLabel.text = brewInfo.explanation()
        
        switch brewInfo.teaState {
            case .NoTea: statusView.backgroundColor = UIColor.redColor()
            case .Brewed: statusView.backgroundColor = UIColor.greenColor()
            case .Brewing: statusView.backgroundColor = UIColor.yellowColor()
        }
        
        
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
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        
//        // 4
//        let image = UIImage(data: PFUser.currentUser()["image"] as! NSData)
//                // 5
//        
//        
//        
//        imageView.layer.cornerRadius = 10;
//        imageView.layer.borderWidth = 1.0;
//        imageView.layer.borderColor = UIColor.grayColor().CGColor
//        imageView.clipsToBounds = true
//
//        imageView.image = image
//        
//        navigationItem.titleView = imageView
        

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
