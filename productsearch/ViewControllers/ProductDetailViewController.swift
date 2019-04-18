//
//  ProductDetailViewController.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/10/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import Foundation
import UIKit

class ProductDetailViewController: UITabBarController {
    
    //MARK: - Properties
    var product: Product?
    var addToWishListButton : UIBarButtonItem?
    override func viewDidLoad() {
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        let fbButton = UIBarButtonItem(image: UIImage(named: "facebook"), style: .plain, target: self, action: #selector(shareOnFacebook))
        addToWishListButton = UIBarButtonItem(image: UIImage(named: "wishListEmpty"), style: .plain, target: self, action: #selector(addToWishList))
        if let product = self.product {
            if let _ = UserDefaults.standard.object(forKey: product.itemId) {
                self.addToWishListButton?.image = UIImage(named: "wishListFilled")
            } else {
                self.addToWishListButton?.image = UIImage(named: "wishListEmpty")
            }
        }
        self.navigationItem.rightBarButtonItems  = [addToWishListButton!, fbButton]
    }
    
    @objc func shareOnFacebook() {
        
        let string = "https://www.facebook.com/dialog/share?app_id=335346230423144&href=\(product!.viewItemURL)&quote=Buy \(product!.productTitle) at \(product!.productPrice) from the link below&hashtag=#CSCI571Spring2019Ebay"
        let encodedAddress = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print(encodedAddress!)
        guard let addr = encodedAddress, let url = URL(string: addr) else { return }
        UIApplication.shared.open(url)
    }

    @objc func addToWishList() {
        let array = createProductArray()
        if let product = self.product {
            if let _ = UserDefaults.standard.object(forKey: product.itemId) {
                UserDefaults.standard.removeObject(forKey: product.itemId)
                self.addToWishListButton?.image = UIImage(named: "wishListEmpty")
                self.view.makeToast("\(product.productTitle) was removed from the wishList")
            } else {
                UserDefaults.standard.set(array, forKey: product.itemId)
                self.addToWishListButton?.image = UIImage(named: "wishListFilled")
                self.view.makeToast("\(product.productTitle) was added to the wishList")
            }
        }
    }
    
    func createProductArray() -> Array<String> {
        var array = [String]()
        
        if let product = self.product {
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
