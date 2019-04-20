//
//  SearchViewCell.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/10/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift

class SearchResultCell : UITableViewCell {
    
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productTitleLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    @IBOutlet weak var shippingLabel: UILabel!
    
    
    @IBOutlet weak var zipcodeLabel: UILabel!
    
    
    @IBOutlet weak var conditionLabel: UILabel!

    
    @IBOutlet weak var heartButton: UIButton!
    
    var productClicked: Product?
    var delegate: SearchResultCellDelegate?
    
    let defaults = UserDefaults.standard
    
    func setupproductview(product: Product) {
        self.productClicked = product
        let url = URL(string: product.productImage)
        let data = try? Data(contentsOf: url!)
        var image: UIImage?
        if let imageData = data {
            image = UIImage(data: imageData)
        }
        productTitleLabel.text = product.productTitle
        if let image = image {
            productImageView.image = image
        }
        priceLabel.text = product.productPrice
        shippingLabel.text =  product.shipping
        conditionLabel.text = product.condition
        zipcodeLabel.text = product.zipcode
        heartButton.addTarget(self, action: #selector(addToWishList(sender:)), for: .touchUpInside)
        
        if let _ = defaults.object(forKey: product.itemId) {
            let wishListFilled = UIImage(named: "wishListFilled")
            self.heartButton.setImage(wishListFilled, for: .normal)
        } else {
            let wishListEmpty = UIImage(named: "wishListEmpty")
            self.heartButton.setImage(wishListEmpty, for: .normal)
        }
    }
    
   
    @objc func addToWishList(sender: UIButton) {
        let array = createProductArray()
        if let product = self.productClicked {
            if let _ = defaults.object(forKey: product.itemId) {
                defaults.removeObject(forKey: product.itemId)
                let wishListEmpty = UIImage(named: "wishListEmpty")
                self.heartButton.setImage(wishListEmpty, for: .normal)
                self.delegate?.showString(str: "\(product.productTitle) was removed from the wishList")
            } else {
                defaults.set(array, forKey: product.itemId)
                let wishListFilled = UIImage(named: "wishListFilled")
                self.heartButton.setImage(wishListFilled, for: .normal)
                self.delegate?.showString(str: "\(product.productTitle) was added to from the wishList")
            }
        }
    }

    func createProductArray() -> Array<String> {
        var array = [String]()
        
        if let product = self.productClicked {
            array.append(product.itemId)
            array.append(product.productImage)
            array.append(product.productTitle)
            array.append(product.productPrice)
            array.append(product.shipping)
            array.append(product.zipcode)
            array.append(product.condition)
            array.append(product.seller)
            array.append(product.viewItemURL)
        }
        return array
    }
}
