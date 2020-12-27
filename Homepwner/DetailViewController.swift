//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Pan Qingrong on 2020/10/17.
//  Copyright © 2020 Pan Qingrong. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController, UINavigationControllerDelegate{
    //MARK: -Properties
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialNumberField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    var imageStore : ImageStore!
    var item : Item?{
        didSet {
            if let _ = item {
                self.navigationItem.title = item!.name
            }
        }
    }
    var windowScene : UIWindowScene!
    
    let numberFormatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var isNewItem :Bool = false
    var itemRequest = ResourceRequest<Item>(resourcePath: "items")
    
    //MARK: -IBActions
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        let imaginPicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imaginPicker.sourceType = .camera
        }else{
            imaginPicker.sourceType = .photoLibrary
        }
        imaginPicker.delegate = self
        
        present(imaginPicker, animated: true, completion: nil)
        
    }
    
    //MARK: -View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = item {
            nameField.text = item!.name
            serialNumberField.text = item!.serialNumber
            valueField.text = numberFormatter.string(from: NSNumber(value : item!.valueInDollars))
            dateLabel.text = dateFormatter.string(from: item!.dateCreated)
            
            let key = item!.itemKey ?? ""
            let imageToDisplay = imageStore.image(forKey: key)
            
            imageView.image = imageToDisplay
            self.isNewItem = false
        }else{
            navigationItem.title = "New item"
            self.isNewItem = true
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
//        item.name = nameField.text ?? ""
//        item.serialNumber = serialNumberField.text ?? ""
//
//        if let valueText = valueField.text, let value = numberFormatter.number(from: valueText){
//            item.valueInDollars = value.intValue
//        } else{
//            item.valueInDollars = 0
//        }
    }
    
    //MARK: -Private Methods
    private func genItemFromFields() -> Item? {
        guard let name = nameField.text, !name.isEmpty else{
            ErrorPresenter.showError(message: "The name of the item should be specified.", on: self)
            return nil
        }
        guard let valueText = valueField.text, let value = numberFormatter.number(from: valueText) else{
            ErrorPresenter.showError(message: "The value of the item should be specified.", on: self)
            return nil
        }
//        guard let dateText = dateLabel.text, let _ = dateFormatter.date(from: dateText) else{
//            ErrorPresenter.showError(message: "The created date of the item should be specified.", on: self)
//            return nil
//        }
        var item : Item?
        if isNewItem {
            item = Item(name: name, serialNumber: serialNumberField.text, valueInDollars: value.intValue)
        }else{
            if let item = self.item{
                item.name = name
                item.valueInDollars = value.intValue
                item.serialNumber = serialNumberField.text
            }
        }
        return self.item
    }
    
    // MARK: -IBActions
    @IBAction func BackgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func save(_ sender:UIBarButtonItem) {
        if let item = self.genItemFromFields() {
            if isNewItem {
                itemRequest.save(item){ [weak self] result in
                    switch result {
                    case .failure:
                        let errmsg = "There are some errors when saving data."
                        ErrorPresenter.showError(message: errmsg, on: self)
                    case .success:
                        DispatchQueue.main.async { [weak self] in
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }else{
                itemRequest.update(item){ [weak self] result in
                    switch result {
                    case .failure:
                        let errmsg = "There are some errors when saving data."
                        ErrorPresenter.showError(message: errmsg, on: self)
                    case .success:
                        DispatchQueue.main.async { [weak self] in
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }else{
            return
        }
        
    }
    @IBAction func cancel(_ sender:UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: -UIImagePickerControllerDelegate
extension DetailViewController : UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        imageStore.setImage(image, forKey: item!.itemKey ?? "")
        dismiss(animated: true, completion: nil)
    }
}
