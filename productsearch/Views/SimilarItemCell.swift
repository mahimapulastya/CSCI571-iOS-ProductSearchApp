//
//  SimilarItemCell.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/12/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import UIKit

class SimilarItemCell: UICollectionViewCell {

    @IBOutlet weak var gridImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var shippingPriceLabel: UILabel!
    
    
    @IBOutlet weak var daysLeftLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    func setupGridBox(item: SimilarItem) {
        self.contentView.layer.masksToBounds = true
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        self.backgroundColor = UIColor(red: 240, green: 240 , blue: 240, alpha: 1.0)
        self.layer.cornerRadius = 10.0
        if let image = item.image {
            self.gridImageView.image = image
        }
        
        if let title = item.title {
            self.titleLabel.text = title
        }
        
        if let price = item.price {
            self.priceLabel.text = "$\(price)"
        }
        
        if let daysLeft = item.daysLeft {
            if (daysLeft == "0" || daysLeft == "1") {
                self.daysLeftLabel.text = "\(daysLeft) Day Left"
            } else  {
                self.daysLeftLabel.text = "\(daysLeft) Days Left"
            }
        }
        
        if let shippingPrice = item.shippingPrice {
            self.shippingPriceLabel.text = "$\(shippingPrice)"
        }
        
    }
}
