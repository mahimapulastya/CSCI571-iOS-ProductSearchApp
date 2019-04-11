//
//  ProductInfoViewController.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/11/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import Foundation
import UIKit

class ProductInfoViewController: UIViewController {
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var productTitleLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var product: Product?
    
    var frame = CGRect(x:0, y:0, width:0, height:0)
    
    var images: [UIImage] = [UIImage(named: "trojan")!, UIImage(named: "trojan")!
        , UIImage(named: "trojan")!, UIImage(named: "trojan")!]
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = images.count
        for index in 0..<images.count {
            frame.origin.x = imageScrollView.frame.size.width * CGFloat(index)
            frame.size = imageScrollView.frame.size
            let imageView = UIImageView(frame: frame)
            imageView.image = images[index]
            self.imageScrollView.addSubview(imageView)
        }
        imageScrollView.contentSize = CGSize(width: (imageScrollView.frame.size.width * CGFloat(images.count)), height: imageScrollView.frame.size.height)
        imageScrollView.delegate = self
//        productTitleLabel.text = product?.productTitle
//        priceLabel.text = product?.productPrice
    }
}

extension ProductInfoViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pgNo = scrollView.contentOffset.x/scrollView.frame.size.width
        pageControl.currentPage = Int(pgNo)
    }
}
