//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Pan Qingrong on 2020/10/17.
//  Copyright © 2020 Pan Qingrong. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialNumberField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    var imageStore : ImageStore!
    
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
    
    var item : Item!{
        didSet {
            self.navigationItem.title = item.name
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: NSNumber(value : item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        let key = item.itemKey
        let imageToDisplay = imageStore.image(forKey: key)
        
        imageView.image = imageToDisplay
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text ?? ""
        
        if let valueText = valueField.text, let value = numberFormatter.number(from: valueText){
            item.valueInDollars = value.intValue
        } else{
            item.valueInDollars = 0
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        imageStore.setImage(image, forKey: item.itemKey)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BackgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
