//
//  BrewingsViewController.swift
//  CebTeaTime
//
//  Created by tayfun biyikoglu on 10/05/15.
//  Copyright (c) 2015 tayfun biyikoglu. All rights reserved.
//

import UIKit

class BrewingsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    
    var brewings = [Brewing]()
    
    enum DateCriteria {
        case Today, ThisWeek, ThisMonth
        
        init(){
            self = .Today
        }
    }
    
    
    class Brewing:NSObject {
        var user:PFUser
        var week:Int
        var month:Int
        var brewingDateTime:NSDate
        var brewing:PFObject
            
        func getLikeCount() -> Int {
            var count = 0
            var query = PFQuery(className:"Brewing_Likes")
            query.whereKey("brewing", equalTo:brewing)
            count = query.countObjects()
//            query.findObjectsInBackgroundWithBlock {
//                (objects: [AnyObject]!, error: NSError?) -> Void in
//                if error == nil {
//                    // The find succeeded.
//                    println("Successfully retrieved \(objects!.count) scores.")
//                    count = objects!.count
//                    
//                } else {
//                    // Log details of the failure
//                    println("Error: \(error!) \(error!.userInfo!)")
//                }
//            }
            return count
        }
        
        init(brewing:PFObject){
            self.user = brewing.objectForKey("user") as! PFUser
            self.week = brewing.objectForKey("week") as! Int
            self.month = brewing.objectForKey("month") as! Int
            self.brewingDateTime = brewing.objectForKey("brewDateTime") as! NSDate
            self.brewing = brewing
            
        }
        
        func brewingMessage() -> String {
            var today = NSDate()
            var h = today.daysFrom(brewingDateTime)
            var formatter = NSDateFormatter()
            if h < 1 {
                formatter.dateFormat = "H:mm"
                
            }else if h < 2 {
                return "Yesterday"
            } else if h < 7 {
                formatter.dateFormat = "EEEE"
            }else {
                formatter.dateFormat = "dd/MM/yy"
            }

            return formatter.stringFromDate(brewingDateTime)
        
    }
        
        func likesMessage() -> String {
            let likes = getLikeCount()
            switch(likes){
             case 0: return "No Likes"
             case 1: return "1 Like"
            default: return "\(likes) Likes"
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    let tableCellIdentifier = "BrewingCell"
    
    
    @IBAction func dateSegment(sender: UISegmentedControl) {
        let selection = sender.selectedSegmentIndex
        
        switch(selection){
          case 0: loadBrewings(.Today)
          case 1: loadBrewings(.ThisWeek)
          case 2: loadBrewings(.ThisMonth)
        default: break
        }
    }
   
    func loadBrewings(criteria:DateCriteria){
        var query = createBrewingQuery(criteria)
        brewings.removeAll(keepCapacity: false)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if(error == nil ){
                for brewing in objects {
                    self.brewings.append(Brewing(brewing: brewing as! PFObject))
//                    println("\(brewing)")
                }
//                 println("\(self.brewings.count)")
                 self.tableView.reloadData()
            }
        }
        
    }
    
    func createBrewingQuery(criteria:DateCriteria) -> PFQuery {
        var query = PFQuery(className: "Brewing")
        query.includeKey("user")
        query.orderByDescending("brewDateTime")
//        query.limit = 10
        switch(criteria) {
            case .Today :
                query.whereKey("brewDate", equalTo: getToday())
            case .ThisWeek:
//                query.whereKey("year", equalTo: getCurrentYear())
                query.whereKey("week", equalTo: getCurrentWeekMonth().week)
            case .ThisMonth:
//                query.whereKey("year", equalTo: getCurrentYear())
                query.whereKey("month", equalTo: getCurrentWeekMonth().month)
        }
        
        return query
    }
    
    func getToday() -> String {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var today = formatter.stringFromDate(NSDate())
        println(today)
        return today
    }
    
    func getCurrentYear() -> String {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy"
        var year = formatter.stringFromDate(NSDate())
        println(year)
        return year
    }
    
    func getCurrentWeekMonth() -> (month:Int,week:Int) {
        let flags: NSCalendarUnit = NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitWeekOfYear
        let dateComponent = NSCalendar.currentCalendar().components(flags, fromDate: NSDate())
        let month = dateComponent.month
        let week = dateComponent.weekOfYear
        println("month: \(month)   week: \(week)")
        return (month,week)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBrewings(.Today)
        tableView.delegate = self
        tableView.dataSource = self
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        title = "Brewing History"
//        loadBrewings()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        println("\(brewings.count)")
        return brewings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(tableCellIdentifier, forIndexPath: indexPath) as! BrewingsTableViewCell
        
        if brewings.count > 0 {
            let row = indexPath.row
            let brewing:Brewing = brewings[row]
            let user:PFUser = brewing.user
//            println("\(user)")
            cell.profilePic!.image =  UIImage(data: user["image"] as! NSData)
            cell.labelName.text = user["name"] as? String
            var formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
//            cell.labelDateTime.text = formatter.stringFromDate(brewing.brewingDateTime)
            cell.labelDateTime.text = brewing.brewingMessage()
            cell.likesLabel.text = brewing.likesMessage()

        }
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        
    }
    
}
