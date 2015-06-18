//
//  BrewingLikeBrain.swift
//  CebTeaTime
//
//  Created by tayfun biyikoglu on 17/06/15.
//  Copyright (c) 2015 tayfun biyikoglu. All rights reserved.
//

import Foundation

class BrewingLikeBrain{
    
    var brewing:PFObject?
    var user:PFUser?
    var labelText = "Like"
    
    var brewingLike:PFObject?
    
    
    func setBrewingLike() {
       var query = PFQuery(className: "Brewing_Likes")
       query.whereKey("brewing", equalTo: self.brewing)
       query.whereKey("user", equalTo: self.user)
       brewingLike = query.getFirstObject()
        if (liked()){
            labelText = "Unlike"
        }else{
            labelText = "Like"
        }
    }
    
    init(brewing:PFObject, user:PFUser){
        self.brewing = brewing
        self.user = user
        setBrewingLike()
    }
    
    func likeToggle(){
        if(liked()){
            unlike()
        }else{
            like()
        }
    }
    
    func unlike(){
        brewingLike?.deleteInBackground()
        setBrewingLike()
    }
    
    func like(){
        var brewingLike = PFObject(className: "Brewing_Likes")
        brewingLike["user"] = user
        brewingLike["brewing"] = brewing
        brewingLike.saveInBackground()
        setBrewingLike()
        
    }
    
    func liked() -> Bool{
        return brewingLike != nil
    }
}