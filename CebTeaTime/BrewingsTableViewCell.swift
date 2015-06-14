//
//  BrewingsTableViewCell.swift
//  CebTeaTime
//
//  Created by tayfun biyikoglu on 10/05/15.
//  Copyright (c) 2015 tayfun biyikoglu. All rights reserved.
//

import UIKit

class BrewingsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!    
    @IBOutlet weak var labelDateTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
        self.profilePic.layer.borderWidth = 1.0;
        self.profilePic.layer.borderColor = UIColor.grayColor().CGColor
        self.profilePic.clipsToBounds = true

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
