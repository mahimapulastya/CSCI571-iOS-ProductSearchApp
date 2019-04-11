//
//  Constants.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/8/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import Foundation

//View Controller Identifiers
public enum ViewControllerIdentifier: String {
    case FormViewControllerIdentifier = "FormViewController"
    case SearchResultsViewControllerIdentifier = "SearchResultsViewController"
    case WishListViewControllerIdentifier = "WishListViewController"
    case ProductImageViewControllerIdentifier = "ProductImageViewController"
   
}

public enum SegueIdentifier: String {
    case SearchResultsViewControllerControllerShow = "SearchResultsViewControllerControllerShow"
    case ProductDetailsViewControllerShow = "ProductDetailsViewControllerShow"
}
