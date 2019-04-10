//
//  SearchViewCell.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/10/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import Foundation
import UIKit

class SearchResultCell : UITableViewCell {
    
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productTitleLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    @IBOutlet weak var shippingLabel: UILabel!
    
    
    @IBOutlet weak var zipcodeLabel: UILabel!
    
    
    @IBOutlet weak var conditionLabel: UILabel!

    
    @IBOutlet weak var heartButton: UIButton!

    func setupproductview(product: Product) {
        productImageView.image = product.productImage
        productTitleLabel.text = product.productTitle
        priceLabel.text = product.productPrice
        shippingLabel.text =  "FREE SHIPPING"
        conditionLabel.text = "NEW"
        zipcodeLabel.text = "90007"
    }
}
