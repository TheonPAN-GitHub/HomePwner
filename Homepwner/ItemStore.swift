//
//  ItemStore.swift
//  Homepwner
//
//  Created by Pan Qingrong on 2020/10/6.
//  Copyright © 2020 Pan Qingrong. All rights reserved.
//

import UIKit
import Foundation

extension DateFormatter{
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
      }()
}

class ItemStore{
    var allItems = [Item]()
    let encoder :JSONEncoder = JSONEncoder()
    let decoder :JSONDecoder = JSONDecoder()
    
    let itemArchiveURL:URL = {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appendingPathComponent("items.archive")
    }()
    
    init() {
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            if let archivedItems = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Item] {
                allItems = archivedItems
                return
            }
        } catch{
            print("Couldn't load data from: \(itemArchiveURL.path)")
        }
        for _ in 0..<5{
            createItem()
        }
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        if let url = URL(string: "http://127.0.0.1:8080/item") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)

        }
        
        
        encoder.dateEncodingStrategy = .formatted(.dateFormatter)
        decoder.dateDecodingStrategy = .formatted(.dateFormatter)
    } 
    
    @discardableResult func createItem()->Item{
        let newItem = Item(random:true)
        if let itemData = try? encoder.encode(newItem) {
            print("\(String(data:itemData, encoding: .utf8) ?? "null")")
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
            var request = URLRequest(url: URL(string: "http://127.0.0.1:8080/item")!)
            request.httpMethod = "POST"
            request.httpBody = itemData
            let task = session.dataTask(with: request, completionHandler: { [weak self] (data:Data?, response:URLResponse?, error:Error?) -> Void   in
                guard let data = data else{
                    return
                }
                
                print("\(String(data:data, encoding: .utf8) ?? "null")")
                
                guard let item = try? self!.decoder.decode(Item.self, from: data) else {
                    return
                }
                print(item.dateCreated)
                
            })
            task.resume()
            
        }
        allItems.append(newItem)
        return newItem
    }
    
    func itemsGroupByValueInDollars()->[ItemGroup]!{
        var itemsGroupBy = [ItemGroup]()
        let itemGroupLessThenFifty = ItemGroup(groupName:"Less than $50", items:allItems.filter(){$0.valueInDollars <= 50})
        let itemGroupMoreThenFifty = ItemGroup(groupName:"More than $50", items:allItems.filter(){$0.valueInDollars > 50})
        
        itemsGroupBy.append(itemGroupLessThenFifty)
        itemsGroupBy.append(itemGroupMoreThenFifty)
        
        return itemsGroupBy
    }
    
    func removeItem(_ item : Item){
//        if let index = allItems.firstIndex(of: item){
//            allItems.remove(at: index)
//        }
    }
    
    func moveItem(from fromIndex:Int, to toIndex:Int){
        if fromIndex == toIndex {
            return
        }
        
        let movedItem = allItems[fromIndex]
        
        allItems.remove(at: fromIndex)
        allItems.insert(movedItem, at: toIndex)
    }
    
    func saveChanges() -> Bool{
        print("Save changes to : \(itemArchiveURL.path)")
    
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject:allItems, requiringSecureCoding: false)
            try data.write(to: itemArchiveURL)
            return true
        }catch {
            print("Items archiving error: \(error.localizedDescription)")
            return false
        }
    }
}
