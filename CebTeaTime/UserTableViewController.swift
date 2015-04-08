//
//  UserTableViewController.swift
//  CebTeaTime
//
//  Created by tayfun biyikoglu on 06/04/15.
//  Copyright (c) 2015 tayfun biyikoglu. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {


    var parseUsers = [PFUser]()
    var users = [Brewer]()
    var brewers:NSArray = NSArray()
    

    class Brewer:NSObject {
        
        var user:PFUser
        var userName:String
        
         init(user:PFUser){
            self.user = user
            self.userName = user["name"] as String
        }
    }
    
    func loadUsers() {
        
        var usersQuery = PFQuery(className: "_User")
        
        usersQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                
                for user in objects {
                    self.parseUsers.append(user as PFUser)
                    self.users.append(Brewer(user: user as PFUser))
                }
                
                self.brewers = self.partitionObjects(self.users as NSArray, collationStringSelector: "userName")
                
                self.tableView.reloadData()
                
            }else{
                println(error)
            }
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Users"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .Bordered, target: self, action: "shareTapped:")
        loadUsers()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
         var numberOfSections = UILocalizedIndexedCollation.currentCollation().sectionTitles.count
                //println("numberOfSections: \(numberOfSections)")
         return numberOfSections
//        return 1
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return (brewers.count > 0) ? brewers.objectAtIndex(section).count : 0
//        return parseUsers.count
    }
    
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as UserTableViewCell
//        let row = indexPath.row
//        var  user:AnyObject = parseUsers[indexPath.row]
//        
//        cell.name.text = user["name"] as NSString
//        cell.gender.text = decideStatus(user["approved"] as String)
//        cell.profilePic!.image =  UIImage(data: user["image"] as NSData)
//        
//        if user["approved"]  as NSString == "1" {
//            cell.gender.backgroundColor = UIColor.greenColor()
//        }else{
//            cell.gender.backgroundColor = UIColor.redColor()
//        }
//        
//        
//        return cell
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as UserTableViewCell
        
        if(brewers.count > 0){
            
            let brewer:Brewer = brewers[indexPath.section][indexPath.row] as Brewer
            println(brewer.userName)
            
            let user:PFUser = brewer.user           
            
            cell.name.text = user["name"] as NSString
            cell.gender.text = decideStatus(user["approved"] as String)
            cell.profilePic!.image =  UIImage(data: user["image"] as NSData)
            
            if user["approved"]  as NSString == "1" {
                cell.gender.backgroundColor = UIColor.greenColor()
            }else{
                 cell.gender.backgroundColor = UIColor.redColor()
            }
          
   
        }
        return cell
    }
    
    
    func decideStatus(approved:String) -> String {
        var result = ""
        if approved == "1" {
            result = "Approved User"
        }else {
            result = "Not Approved"
        }
        
        return result
    }
    
    func partitionObjects(array:NSArray, collationStringSelector:Selector) -> NSArray{
        
        let collation:UILocalizedIndexedCollation = UILocalizedIndexedCollation.currentCollation() as UILocalizedIndexedCollation
        
        //section count is take from sectionTitles and not sectionIndexTitles
        let sectionCount = collation.sectionTitles.count
        
        let unsortedSections = NSMutableArray(capacity: sectionCount)
        
        //create an array to hold the data for each section
        for i in collation.sectionTitles{
            var emptyArray = NSMutableArray()
            unsortedSections.addObject(emptyArray);
        }
        
        //put each object into a section
        for object in array{
            let index:Int = collation.sectionForObject(object, collationStringSelector: collationStringSelector)
            unsortedSections.objectAtIndex(index).addObject(object)
        }
        
        var sections = NSMutableArray(capacity: sectionCount)
        
        //sort each section
        for section in unsortedSections{
            sections.addObject(collation.sortedArrayFromArray(section as NSMutableArray, collationStringSelector: collationStringSelector))
        }
        
        return sections;
    }


    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        
        //sectionForSectionIndexTitleAtIndex: is a bit buggy, but is still useable
        return UILocalizedIndexedCollation.currentCollation().sectionForSectionIndexTitleAtIndex(index)
        
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return UILocalizedIndexedCollation.currentCollation().sectionIndexTitles
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
