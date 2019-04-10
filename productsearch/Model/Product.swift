//
//  Product.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/10/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import Foundation
import UIKit

class Product {
    var productImage: UIImage
    var productTitle: String
    var productPrice: String
    
    init(image: UIImage, title: String, price: String) {
        self.productImage = image
        self.productTitle = title
        self.productPrice = price
    }
}
