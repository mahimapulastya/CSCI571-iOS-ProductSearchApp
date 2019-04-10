//
//  SearchResultsViewController.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/8/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import Foundation
import UIKit
import SwiftSpinner
import Alamofire
import SwiftyJSON

class SearchResultsViewController: UITableViewController {
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Search Results"
        SwiftSpinner.show("Searching...")
        performSearch(keyword: "iphone") { res in
            SwiftSpinner.hide()
        }
        products = getAllProducts()
    }
    
    //======================
    
    func performSearch(keyword: String, completion: @escaping (Any) -> Void) {
        
        let parameters: Parameters = ["keyword": keyword, "postalCode":  "90007"]
        
        Alamofire.request("https://myweb-hw8-backend.appspot.com/searchItem", method: .get, parameters: parameters).responseData { (response) -> Void in
            guard response.result.isSuccess,
                let value = response.result.value  else {
                    let serviceError = UIAlertView(title: "Search service Error!", message: "Failed to fetch search results",
                                                   delegate: self, cancelButtonTitle: "Ok")
                    SwiftSpinner.hide()
                    serviceError.show()
                    return
            }
            
            let swiftyJsonVar = JSON(value)
            let res = swiftyJsonVar["findItemsAdvancedResponse"][0]
            
            guard res["ack"][0] == "Success", res["searchResult"][0]["@count"] > "0"  else {
                let noResults = UIAlertView(title: "No Results!", message: "Failed to fetch search results",
                                            delegate: self, cancelButtonTitle: "Ok")
                SwiftSpinner.hide()
                noResults.show()
                return
            }
            completion(swiftyJsonVar)
        }
    }
    
    //==========================
    
    func getAllProducts() -> [Product] {
        var products: [Product] = []
        
        let product1 = Product(image: UIImage(named: "trojan")! , title: "fhjhkhfkjhkgh", price: "$123456")
        products.append(product1)
        
        return products
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchresultcell", for: indexPath) as! SearchResultCell
        let product = self.products[indexPath.row]
        cell.setupproductview(product: product)
        return cell
    }
}
