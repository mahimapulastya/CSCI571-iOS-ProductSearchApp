//
//  ProductImagePageViewController.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/11/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import Foundation
import UIKit

class ProductImageViewController: UIViewController {
    
    @IBOutlet weak var productImageView: UIImageView!
    var productImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productImageView.image = productImage
    }
    
}
