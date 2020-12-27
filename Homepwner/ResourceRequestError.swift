//
//  ResourceRequestError.swift
//  Homepwner
//
//  Created by Theon.PAN on 2020/12/15.
//  Copyright © 2020 Pan Qingrong. All rights reserved.
//

import Foundation

enum ResourceRequestError : Error {
    case noData
    case decodingError
    case encodingError
}
