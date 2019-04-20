//
//  SimilarItem.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/12/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import Foundation
import UIKit

class SimilarItem {
    var image: UIImage?
    var title: String?
    var price: String?
    var daysLeft: String?
    var shippingPrice: String?
    var itemURL: String?
    
    init(image: UIImage?, title: String?, price: String?, daysLeft: String?, shippingPrice: String?, itemURL : String?) {
        self.image = image
        self.title = title
        self.price = price
        self.daysLeft = daysLeft
        self.shippingPrice = shippingPrice
        self.itemURL = itemURL
    }
}
