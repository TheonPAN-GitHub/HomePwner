//
//  Item.swift
//  Homepwner
//
//  Created by Pan Qingrong on 2020/10/6.
//  Copyright © 2020 Pan Qingrong. All rights reserved.
//

import UIKit

class Item : NSObject, NSCoding, Codable{
    var name : String
    var valueInDollars : Int
    var serialNumber : String?
    var itemKey : String
    let dateCreated : Date
    
//    enum CodingKeys:CodingKey{
//        typealias RawValue = String
//        case name, valueInDollars,serialNumber, itemKey, dateCreated
//        
//        
//    }
    init(name:String, serialNumber:String?, valueInDollars:Int) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = Date()
        self.itemKey = UUID().uuidString
        super.init()
    }

    convenience init(random:Bool = false){
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Mac"]
            var idx = arc4random_uniform(UInt32(adjectives.count))
            let randomAdjective = adjectives[Int(idx)]
            idx = arc4random_uniform(UInt32(nouns.count))
            let randomNoun = nouns[Int(idx)]
            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int(arc4random_uniform(100))
            let randomSerialNumber = UUID( ).uuidString.components( separatedBy:"-").first!
            self.init(name: randomName, serialNumber: randomSerialNumber, valueInDollars: randomValue)
        } else {
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        }
    }

    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as! String
        valueInDollars = coder.decodeInteger(forKey: "valueInDollars")
        itemKey = coder.decodeObject(forKey: "itemKey") as! String
        dateCreated = coder.decodeObject(forKey: "dateCreated") as! Date
        serialNumber = coder.decodeObject(forKey: "serialNumber") as! String?
        super.init()
    }

    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(serialNumber, forKey: "serialNumber")
        coder.encode(dateCreated, forKey: "dateCreated")
        coder.encode(itemKey, forKey: "itemKey")
        coder.encode(valueInDollars, forKey: "valueInDollars")
    }
}

