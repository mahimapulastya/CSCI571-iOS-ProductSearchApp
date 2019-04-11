//
//  ProductDetailViewController.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/10/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import Foundation
import UIKit
import FBSDKShareKit

class ProductDetailViewController: UITabBarController {
    
    //MARK: - Properties
    private let viewModel = ProductDetailsViewModel()
    var product: Product?

    override func viewDidLoad() {
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        let fbButton = UIBarButtonItem(image: UIImage(named: "facebook"), style: .plain, target: self, action: #selector(shareOnFacebook))
//        let fbButton = FBSDKShareButton()
//        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
//        if let url = product?.viewItemURL {
//            content.contentURL = URL(string: url)
//        }
//        fbButton.shareContent = content
        let addToWishListButton = UIBarButtonItem(image: UIImage(named: "wishListEmpty"), style: .plain, target: self, action: #selector(addToWishList))
        self.navigationItem.rightBarButtonItems  = [addToWishListButton, fbButton]
    }
    
    /* ====== Api Calls ====== */
    private func getProductDetails() {
//        guard let itemID = product?.itemId else { return }
//        viewModel.getDetails(for: itemID)
    }
    
    
    @objc func shareOnFacebook() {
        print("Share on fb")
    }
    
    @objc func addToWishList() {
        print("Add to wishlist")
    }
}
