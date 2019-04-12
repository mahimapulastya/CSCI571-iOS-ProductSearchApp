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
    var itemId: String
    var productImage: UIImage
    var productTitle: String
    var productPrice: String
    var shipping: String
    var zipcode: String
    var condition: String
    var seller: String
    var viewItemURL: String
    
    init(itemId: String, image: UIImage, title: String, price: String, shipping: String, zipcode: String, condition: String, seller: String, viewItemURL: String) {
        self.itemId = itemId
        self.productImage = image
        self.productTitle = title
        self.productPrice = price
        self.shipping = shipping
        self.zipcode = zipcode
        self.condition = condition
        self.seller = seller
        self.viewItemURL = viewItemURL
    }
    
    func getProductID() -> String {
        return itemId
    }
}
