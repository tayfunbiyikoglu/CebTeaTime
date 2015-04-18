//
//  BrewViewController.swift
//  CebTeaTime
//
//  Created by tayfun biyikoglu on 12/04/15.
//  Copyright (c) 2015 tayfun biyikoglu. All rights reserved.
//

import UIKit

class BrewViewController: UIViewController {

    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var screenDate: UILabel!
    @IBOutlet weak var dateName: UILabel!
    
    let buffer: Double = -1200 //20 min
    
    enum Weekdays: Int {
        case Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
        static let names = [Monday: "Monday", Tuesday: "Tuesday", Wednesday: "Wednesday", Thursday: "Thursday", Friday: "Friday", Saturday: "Saturday", Sunday: "Sunday"]
        
        func name()-> String {
            if let name = Weekdays.names[self]
            {
                return name
            }else{
                return "Undefined"
            }
        }
    }
    
    var user = PFUser.currentUser()
    
    
    @IBAction func brew(sender: UIButton) {
        
        let flags: NSCalendarUnit = NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitWeekOfYear
        let dateComponent = NSCalendar.currentCalendar().components(flags, fromDate: timePicker.date)
        let month = dateComponent.month
        let week = dateComponent.weekOfYear
        
        var brewing = PFObject(className: "Brewing")
        
        brewing["user"] = user
        brewing["brewDateTime"] = timePicker.date
        brewing["operationDateTime"] = NSDate()
        brewing["week"] = week
        brewing["month"] = month
        
        brewing.saveInBackground()
        
        self.performSegueWithIdentifier("home", sender: nil)
        

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Brew Tea"
        
        var date = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        screenDate.text = formatter.stringFromDate(date)
        let myWeekday = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate: date).weekday
        dateName.text = Weekdays(rawValue: myWeekday)?.name()
        
        circulizeImage()
        timePicker.minimumDate = date.dateByAddingTimeInterval(buffer)
        timePicker.maximumDate = date
        
        profilePic.image = UIImage(data: user["image"] as! NSData)
        
        
        // Do any additional setup after loading the view.
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
