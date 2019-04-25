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
import EasyToast

protocol SearchResultCellDelegate {
    func showString(str: String)
}

class SearchResultsViewController: UITableViewController {
    var searchFormParams: SearchFormParams?
    var products: [Product] = []
    var pro: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Search Results"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        SwiftSpinner.show("Searching...")
        if let params = self.searchFormParams {
            performSearch(searchParams: params) { swiftyJsonVar in
            
            if let productArray = swiftyJsonVar["findItemsAdvancedResponse"][0]["searchResult"][0]["item"].array {
                for productDict in productArray {
                    var priceString: String?
                    if let price = productDict["sellingStatus"][0]["currentPrice"][0]["__value__"].string {
                        priceString = "$\(price)"
                    }
                    let title = productDict["title"][0].string
                    let image = productDict["galleryURL"][0].string ?? ""
                    
                    var shippingValue: String?
                    if let costValue = productDict["shippingInfo"][0]["shippingServiceCost"][0]["__value__"].string {
                        shippingValue = (costValue == "0.0") ? "FREE SHIPPING" : "$\(costValue)"
                    }
                    
                    let zipcode = productDict["postalCode"][0].string
                    
                    var condition: String?
                    if let con  = productDict["condition"][0]["conditionId"][0].string {
                        switch con {
                        case "1000":
                            condition = "NEW"
                        case "2000", "2500":
                            condition = "REFURBISHED"
                        case "3000", "4000", "5000", "6000":
                            condition = "USED"
                        default:
                            condition = "NA"
                        }
                    }
                    let itemId = productDict["itemId"][0].string!
                    let seller = productDict["sellerInfo"][0]["sellerUserName"][0].string
                    let itemURL = productDict["viewItemURL"][0].string!
                    
                    let product = Product(itemId: itemId, image: image, title: title ?? "", price: priceString ?? "", shipping: shippingValue ?? "N/A", zipcode: zipcode ?? "", condition: condition ?? "", seller: seller ?? "", viewItemURL: itemURL)

                    self.products.append(product)
                }
            }
            SwiftSpinner.hide()
            self.tableView.reloadData()
        }
        }
    }
    
    //======================
    
    func performSearch(searchParams: SearchFormParams,completion: @escaping (JSON) -> Void) {
        
        var parameters: Parameters = ["keyword": searchParams.keyword!, "postalCode":  searchParams.postalCode!]
        
        if let categoryID = searchParams.categoryId {
            parameters["category"] = categoryID
        }
        
        if let distance = searchParams.distance {
            parameters["distance"] = distance
        }
        
        if let newC = searchParams.newC {
            parameters["new"] = String(newC)
        }
        
        if let usedC = searchParams.usedC {
            parameters["used"] = String(usedC)
        }
        
        if let unspecC = searchParams.unspec {
            parameters["unspecified"] = String(unspecC)
        }
        
        if let localpickup = searchParams.localpickup {
            parameters["localpickup"] = String(localpickup)
        }
        
        if let freeshipping = searchParams.freeshipping {
            parameters["freeshipping"] = String(freeshipping)
        }
        
        Alamofire.request("https://hw8-backend.appspot.com/searchItem", method: .get, parameters: parameters).responseData { (response) -> Void in
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchresultcell", for: indexPath) as! SearchResultCell
        let product = self.products[indexPath.row]
        cell.delegate = self
        cell.setupproductview(product: product)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pro = self.products[indexPath.row]
        performSegue(withIdentifier: SegueIdentifier.ProductDetailsViewControllerShow.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ProductDetailViewController
        {
            let vc = segue.destination as? ProductDetailViewController
            vc?.product = self.pro
        }
    }
}

extension SearchResultsViewController: SearchResultCellDelegate {
    func showString(str: String) {
        self.view.showToast(str , position: .bottom , popTime: 2.0 , dismissOnTap: false)
    }
}

