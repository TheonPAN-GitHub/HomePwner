//
//  RESTClient.swift
//  Homepwner
//
//  Created by Pan Qingrong on 2020/11/10.
//  Copyright © 2020 Pan Qingrong. All rights reserved.
//

import Foundation

protocol ApiResource {
    associatedtype ModelType : Codable
    
}

protocol RESTClient : AnyObject{
    associatedtype ModelType : Codable
    
    func encode(model: ModelType) -> Data?
    
    func decode(data : Data) -> ModelType?
    
    func load(withCompetion completion : @escaping (ModelType?) -> Void)
    
    
    
    
    
}
