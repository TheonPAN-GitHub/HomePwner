//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Pan Qingrong on 2020/10/6.
//  Copyright © 2020 Pan Qingrong. All rights reserved.
//

import UIKit

class ItemsViewController : UITableViewController {
    var itemStore : ItemStore!
    var windowScene : UIWindowScene!
    var itemsGroupByValueInDollars : [ItemGroup]!
    let DEFAULT_GROUP_NAME : String = "Unknown Group Name"
    var imageStore : ImageStore!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    @IBAction func addNewItem(_ sender:UIBarButtonItem){
        let newItem = itemStore.createItem()
        itemsGroupByValueInDollars = itemStore.itemsGroupByValueInDollars()
        if let indexPath = self.getIndexPathOfItem(item: newItem){
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func viewDidLoad() {
//        super.viewDidLoad()
//        if let statusBarHeight = windowScene.statusBarManager?.statusBarFrame.height{
//            let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
//            tableView.contentInset = insets
//            tableView.scrollIndicatorInsets = insets
//        }
        itemsGroupByValueInDollars = itemStore.itemsGroupByValueInDollars()
        tableView.estimatedRowHeight = 65
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfRows = itemsGroupByValueInDollars[section].items?.count{
            return numberOfRows
        }else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for:indexPath) as! ItemCell
        
        if let item = itemsGroupByValueInDollars[indexPath.section].items?[indexPath.row] {
            cell.nameLabel.text = item.name
            cell.serialNumberLabel.text = item.serialNumber
            cell.valueLabel.text = "$\(item.valueInDollars)"
        }
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return itemsGroupByValueInDollars.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let itemGroupName = itemsGroupByValueInDollars[section].groupName {
            return itemGroupName
        }else{
            return DEFAULT_GROUP_NAME
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let footInfo = "\(itemsGroupByValueInDollars[section].items?.count ?? 0) items"
        return footInfo
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = itemsGroupByValueInDollars[indexPath.section].items?[indexPath.row]{
                let title = "Delete \(item.name)?"
                let message = "Are you sure you want to delete this item?"
                let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                ac.addAction(cancelAction)
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action)->Void in
                    self.itemStore.removeItem(item)
                    self.itemsGroupByValueInDollars = self.itemStore.itemsGroupByValueInDollars()
                    self.imageStore.deleteImage(forKey: item.itemKey)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                })
                ac.addAction(deleteAction)
                ac.view.translatesAutoresizingMaskIntoConstraints = false
//                popoverPresentationController?.sourceView = self.view
//                popoverPresentationController?.sourceRect = self.view.bounds
                self.present(ac, animated: true, completion: nil)
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section != destinationIndexPath.section {
            return
        }
        
        
    }
    
    private func getIndexPathOfItem(item : Item)->IndexPath?{
        if let itemsGroupByValueInDollars = itemStore.itemsGroupByValueInDollars(){
            for i in 0...itemsGroupByValueInDollars.count - 1{
                if let index = itemsGroupByValueInDollars[i].items?.firstIndex(of: item){
                    let indexPath = IndexPath(row: index, section: i)
                    return indexPath
                }else{
                    continue
                }
            }
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showItem"?:
            if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
                if let item = itemsGroupByValueInDollars[indexPathForSelectedRow.section].items?[indexPathForSelectedRow.row]{
                    let detailViewController = segue.destination as! DetailViewController
                    detailViewController.item = item
                    detailViewController.imageStore = imageStore
                    detailViewController.windowScene = windowScene
                }
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        itemsGroupByValueInDollars = itemStore.itemsGroupByValueInDollars()
        tableView.reloadData()
    }
}
