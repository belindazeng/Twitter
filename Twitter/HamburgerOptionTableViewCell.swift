//
//  HamburgerOptionTableViewCell.swift
//  Twitter
//
//  Created by Belinda Zeng on 11/4/16.
//  Copyright © 2016 LemonBunny. All rights reserved.
//

import UIKit

class HamburgerOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    var option: NSString? {
        didSet {
            optionLabel.text = option as String?
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
