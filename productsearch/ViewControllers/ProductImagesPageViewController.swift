//
//  ProductImagesPageViewController.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/11/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import UIKit

class ProductImagesPageViewController: UIPageViewController {

    var displayImages: [UIImage]?
    lazy var controllers: [UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var controllers = [UIViewController]()
        
        if let disImages = self.displayImages {
            for image in disImages {
                let displayImagesVC = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.ProductImageViewControllerIdentifier.rawValue)
                controllers.append(displayImagesVC)
            }
        }
        
        return controllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        dataSource = self
        delegate = self
        
    }
}

extension ProductImagesPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let i = controllers.index(of: viewController) {
            if i > 0 {
                return controllers[i-1]
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
}

extension ProductImagesPageViewController: UIPageViewControllerDataSource {
    
}

