//
//  SignUpViewController.swift
//  TeaTime
//
//  Created by tayfun biyikoglu on 02/04/15.
//  Copyright (c) 2015 tayfun biyikoglu. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
        self.profileImage.layer.borderWidth = 3.0;
        self.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.profileImage.clipsToBounds = true

        
        
        var user = PFUser.currentUser()
        
        var FBSession = PFFacebookUtils.session()
        
        var accessToken = FBSession.accessTokenData.accessToken
        
        let url = NSURL(string: "https://graph.facebook.com/me/picture?height=200&width=200&return_ssl_resources=1&access_token="+accessToken)
        
        // Update - changed url to url!
        
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            let image = UIImage(data: data)
            
            self.profileImage.image = image
            
            user["image"] = data
            user["verified"] = "0"
            
            user.save()
            
            //            FBRequestConnection.startForMeWithCompletionHandler({
            //                connection, result, error in
            //
            //                user["gender"] = result["gender"]
            //                user["name"] = result["name"]
            //
            //                user.save()
            //
            //                println(result)
            //
            //
            //            })
            
        })
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
