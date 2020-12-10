//
//  ImageStore.swift
//  Homepwner
//
//  Created by Pan Qingrong on 2020/10/28.
//  Copyright © 2020 Pan Qingrong. All rights reserved.
//

import UIKit

class ImageStore {
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image:UIImage, forKey key:String){
        cache.setObject(image, forKey: key as NSString)
        let imageURLToSave = imageURL(forKey: key)
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            let _ = try? imageData.write(to: imageURLToSave)
        }
    }
    
    func image(forKey key:String) -> UIImage?{
        if let image = cache.object(forKey: key as NSString){
            return image
        }
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else{
            return nil
        }
        cache.setObject(imageFromDisk, forKey: key as NSString)
        
        return imageFromDisk
    }
    
    func deleteImage(forKey key:String){
        cache.removeObject(forKey: key as NSString)
        let url = imageURL(forKey: key)
        do{
            try FileManager.default.removeItem(at: url)
        }catch let deleteError{
            print("Error when removing the image from disk: \(deleteError)")
        }
        
    }
    
    func imageURL(forKey key:String)->URL{
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appendingPathComponent(key)
    }
    
}
