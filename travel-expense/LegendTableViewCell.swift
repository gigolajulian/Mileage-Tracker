//
//  LegendTableViewCell.swift
//  travel-expense
//
//  Created by cisstudents on 12/3/14.
//  Copyright (c) 2014 Saan Saeteurn. All rights reserved.
//

import UIKit

class LegendTableViewCell: UITableViewCell {

    @IBOutlet var title:UILabel!
    @IBOutlet var subTitle:UILabel!
    @IBOutlet var leftBorder:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
