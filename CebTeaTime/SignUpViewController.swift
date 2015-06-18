//
//  SignUpViewController.swift
//  TeaTime
//
//  Created by tayfun biyikoglu on 02/04/15.
//  Copyright (c) 2015 tayfun biyikoglu. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    var usingFacebookPic = true
    
    
    @IBOutlet weak var photoSwitch: UISwitch!
    
    
    @IBAction func profileSwitch(sender: UISwitch) {
        if sender.on {
            cameraButton.alpha = 0
            if !usingFacebookPic {
                getFacebookProfilePicture()
            }
        }else{
            cameraButton.alpha = 1
        }
    }
    
    
    @IBAction func signUp(sender: UIButton) {
        
        var user = PFUser.currentUser()
        var userVerified = user.objectForKey("approved") as! NSString
        
        user["image"] = UIImagePNGRepresentation(profileImage.image)
        
        if(self.usingFacebookPic){
            user["usingFacebookPic"] = "1"
        }else{
            user["usingFacebookPic"] = "0"
        }
        user.save()
        
        
//        profileImage.image?.resize(CGSizeMake(150, 150), completionHandler: {
//            response, data in
//                user["image"] = data
//            if(self.usingFacebookPic){
//                user["usingFacebookPic"] = "1"
//            }else{
//                user["usingFacebookPic"] = "0"
//            }
//            user.save()
//        })
        
        if(userVerified == "0"){
          self.performSegueWithIdentifier("waiting", sender: self)
        }

    }
    @IBAction func showActionSheet(sender: AnyObject) {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        // 2
        let cameraAction = UIAlertAction(title: "Take Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Take Photo Pressed")
            let pickerC = UIImagePickerController()
            pickerC.delegate = self
            pickerC.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(pickerC, animated: true, completion: nil)
        })
        let libraryAction = UIAlertAction(title: "Photo Library", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Library Pressed")
            let pickerC = UIImagePickerController()
            pickerC.delegate = self
            pickerC.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(pickerC, animated: true, completion: nil)
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(libraryAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func getFacebookProfilePicture()  {
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
            self.usingFacebookPic = true

        })
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
        self.profileImage.layer.borderWidth = 5.0;
        self.profileImage.layer.borderColor = UIColor.grayColor().CGColor
        self.profileImage.clipsToBounds = true

        
        
        var user = PFUser.currentUser()

        self.profileImage.image = UIImage(data: user["image"] as! NSData)

        var facePic = user.objectForKey("usingFacebookPic") as? String ?? "1"
        
        
        if (facePic == "1"){
            self.usingFacebookPic = true
            photoSwitch.on = true
        }else{
            self.usingFacebookPic = false
            photoSwitch.on = false
        }
//        var FBSession = PFFacebookUtils.session()
//        
//        var accessToken = FBSession.accessTokenData.accessToken
//        
//        let url = NSURL(string: "https://graph.facebook.com/me/picture?height=200&width=200&return_ssl_resources=1&access_token="+accessToken)
//        
//        // Update - changed url to url!
//        
//        let urlRequest = NSURLRequest(URL: url!)
//        
//        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
//            response, data, error in
//            
//            let image = UIImage(data: data)
//            
//            self.profileImage.image = image
//            
//            user["image"] = data
////            user["approved"] = "0"
////            user["isAdmin"] = "0"
//            
//            user.saveInBackground()
//            
//            FBRequestConnection.startForMeWithCompletionHandler({
//                connection, result, error in
//
//                user["gender"] = result["gender"]
//                user["name"] = result["name"]
//
//                user.saveInBackground()
//
//                println(result)
//
//
//            })
//            
//        })
//        
//        
//        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func scaleUIImageToSize(let image: UIImage, let size: CGSize) -> UIImage {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("image Selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        profileImage.image = scaleUIImageToSize(image,size:CGSizeMake(150, 150))
        usingFacebookPic = false
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
