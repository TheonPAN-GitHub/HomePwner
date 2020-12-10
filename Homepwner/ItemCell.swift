//
//  ItemCell.swift
//  Homepwner
//
//  Created by Pan Qingrong on 2020/10/8.
//  Copyright © 2020 Pan Qingrong. All rights reserved.
//

import UIKit

class ItemCell : UITableViewCell{
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var serialNumberLabel : UILabel!
    @IBOutlet var valueLabel :UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.adjustsFontForContentSizeCategory = true
        serialNumberLabel.adjustsFontForContentSizeCategory = true
        valueLabel.adjustsFontForContentSizeCategory = true
    }
    
}
