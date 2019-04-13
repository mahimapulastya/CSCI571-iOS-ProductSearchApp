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
    private let viewModel = ProductDetailsViewModel()
    var product: Product?

    override func viewDidLoad() {
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        let fbButton = UIBarButtonItem(image: UIImage(named: "facebook"), style: .plain, target: self, action: #selector(shareOnFacebook))
        let addToWishListButton = UIBarButtonItem(image: UIImage(named: "wishListEmpty"), style: .plain, target: self, action: #selector(addToWishList))
        self.navigationItem.rightBarButtonItems  = [addToWishListButton, fbButton]
    }
    
    @objc func shareOnFacebook() {
        
        let string = "https://www.facebook.com/dialog/share?app_id=335346230423144&href=\(product!.viewItemURL)&quote=Buy \(product!.productTitle) at \(product!.productPrice) from the link below&hashtag=#CSCI571Spring2019Ebay"
        let encodedAddress = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print(encodedAddress!)
        guard let addr = encodedAddress, let url = URL(string: addr) else { return }
        UIApplication.shared.open(url)
    }

    @objc func addToWishList() {
        print("Add to wishlist")
    }
}
