//
//  ItemGroup.swift
//  Homepwner
//
//  Created by Pan Qingrong on 2020/10/7.
//  Copyright © 2020 Pan Qingrong. All rights reserved.
//

import UIKit

class ItemGroup : NSObject{
    var groupName :String?
    var items : [Item]?
    
    init(groupName:String?, items:[Item]?) {
        self.groupName = groupName
        self.items = items
    }
}
