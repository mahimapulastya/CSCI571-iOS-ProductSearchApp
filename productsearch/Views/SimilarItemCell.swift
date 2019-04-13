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
        self.gridImageView.image = item.image
        self.titleLabel.text = item.title
        self.shippingPriceLabel.text = item.shippingPrice
        self.daysLeftLabel.text = item.daysLeft
        self.priceLabel.text = item.price
    }
}
