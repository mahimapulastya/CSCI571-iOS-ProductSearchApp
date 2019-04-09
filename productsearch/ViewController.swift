//
//  ViewController.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/7/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    var formView : UIView!
    var wishlistView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        formView = FormViewController().view
        wishlistView = WishListViewController().view
        containerView.addSubview(wishlistView)
        containerView.addSubview(formView)
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func switchToWishlistView(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            containerView.bringSubviewToFront(formView)
            break
        case 1:
            containerView.bringSubviewToFront(wishlistView)
            break
        default:
            break
        }
        
    }
}

