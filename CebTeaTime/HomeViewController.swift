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
        var minsPassed:Int = 0
        var minsFromLastBrew:Int {
            return NSDate().minutesFrom(brewDate)
        }
        
        var teaState:TeaStates {
            let mins = minsFromLastBrew
//            println("\(mins)")
            switch mins {
            case 0..<18 : return .Brewing
            case 18...100 : return .Brewed
            default:  return .NoTea
            }
        }
        
        init(brewing: PFObject){
            self.brewDate = brewing.objectForKey("brewDateTime") as! NSDate
            self.brewUser = brewing.objectForKey("user") as! PFUser
        }
        
        func oneMinutePassed(){
            minsPassed++
        }
        
        func explanation() -> String {
            switch self.teaState {
            case .NoTea: return "Sorry, we don't have tea"
            case .Brewing: return "Tea will be ready in \(18 - minsFromLastBrew) min(s)"
            case .Brewed:
                if(minsFromLastBrew == 18){
                    return "Tea has just brewed, enjoy.."
                }else{
                    return "We have tea since \(minsFromLastBrew-18) min(s)"
                }
                
            }
        }
        
        func nonBrewable() -> Bool {
            return self.teaState != .NoTea
        }
        
        class func last() -> BrewInfo {
            var query = PFQuery(className: "Brewing")
            query.includeKey("user")
            query.orderByDescending("brewDateTime")
            return BrewInfo(brewing: query.getFirstObject())
        }
    }
    
    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var brewButton: UIButton!
    
    @IBOutlet weak var explanationLabel: UILabel!
    
    var brewInfo:BrewInfo?
    
    var timer = NSTimer()
    
    @IBAction func goToUsers(sender: UIButton) {
        self.performSegueWithIdentifier("users", sender: self)
    }
    
    
    @IBAction func brew(sender: UIButton) {
        self.performSegueWithIdentifier("brew", sender: nil)
    }
    
    
    @IBAction func brewings(sender: UIButton) {
        self.performSegueWithIdentifier("brewings", sender: nil)
    }
    
    @IBAction func signOut(sender: UIBarButtonItem) {
        
        let optionMenu = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .ActionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "log out", style: UIAlertActionStyle.Destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            PFUser.logOut()
            self.performSegueWithIdentifier("login", sender: nil)
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
       

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        println("View Did Load run")
        brewInfo = BrewInfo.last()
        setupTimer()
        refreshUI()
        
        // Do any additional setup after loading the view.
    }

    func setupTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("updateMin"), userInfo: nil, repeats: true)
    }
    
    func updateMin(){
        brewInfo!.oneMinutePassed()
        refreshUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        title = "Tea Track"

        if PFUser.currentUser() == nil {
            self.performSegueWithIdentifier("login", sender: nil)
        }
        brewInfo = BrewInfo.last()
        refreshUI()
//        println("view did appear run")
    }
    
    func refreshUI(){

        explanationLabel.text = brewInfo!.explanation()
        
        switch brewInfo!.teaState {
          case .NoTea: statusView.backgroundColor = UIColor.redColor()
          case .Brewed: statusView.backgroundColor = UIColor.greenColor()
          case .Brewing: statusView.backgroundColor = UIColor.yellowColor()
        }
        
        if(brewInfo!.nonBrewable()){
            brewButton.alpha = 0
        }else{
            brewButton.alpha = 1
        }


    }
    

}
