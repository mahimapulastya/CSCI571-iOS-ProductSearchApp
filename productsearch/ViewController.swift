//
//  ViewController.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/7/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum TabIndex : Int {
        case searchTab = 0
        case wishListTab = 1
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var containerView: UIView!
    
    
    var currentViewController: UIViewController?
    lazy var searchTabVC: UIViewController? = {
        let searchTabVC = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifier.FormViewControllerIdentifier.rawValue)
        return searchTabVC
    }()
    lazy var wishlistTabVC : UIViewController? = {
        let wishlistTabVC = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifier.WishListViewControllerIdentifier.rawValue)
        
        return wishlistTabVC
    }()

   
    @IBAction func switchBetweenTabs(_ sender: UISegmentedControl) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParent()
        
        displayCurrentTab(sender.selectedSegmentIndex)
        
    }
    
    
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            self.addChild(vc)
            vc.didMove(toParent: self)
            
            vc.view.frame = self.containerView.bounds
            self.containerView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex.searchTab.rawValue :
            vc = searchTabVC
        case TabIndex.wishListTab.rawValue :
            vc = wishlistTabVC
        default:
            return nil
        }
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        segmentedControl.selectedSegmentIndex = TabIndex.searchTab.rawValue
        displayCurrentTab(TabIndex.searchTab.rawValue)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
}

