//
//  ShippingTabTableViewController.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/11/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class ShippingTabTableViewController: UITableViewController {

    var product: Product?
    var sections = ["Seller", "Shipping Info", "Return Policy"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.clear
        product = (self.tabBarController as! ProductDetailViewController).product
        SwiftSpinner.show("Fetching Shipping Data...")
        
        if let itemId = product?.itemId {
            fetchDetails(itemID: itemId) { res in
                if let storeName = res["Item"]["Storefront"]["StoreName"].string {
                    if let storeURL = res["Item"]["Storefront"]["StoreURL"].string {
                        let linkAttributes = [
                            NSAttributedString.Key.link: URL(string: storeURL)!,
                            NSAttributedString.Key.foregroundColor: UIColor.blue
                            ] as [NSAttributedString.Key : Any]
                        
                        let attributedString = NSMutableAttributedString(string: storeName)
                        
                        // Set the 'click here' substring to be the link
                        attributedString.setAttributes(linkAttributes, range: NSMakeRange(0, attributedString.length))
                        
//                        self.textView.attributedText = attributedString
                    }
                
                }
            
                
                if let feedbackScore = res["Item"]["Seller"]["FeedbackScore"].string {
                    
                }
                
                if let feedbackpercent = res["Item"]["Seller"]["PositiveFeedbackPercent"].string {
                    
                }
                
                if let feedbackRatingStar = res["Item"]["Seller"]["FeedbackRatingStar"].string {
                    
                }
                
                if let currprice = res["Item"]["CurrentPrice"]["Value"].string {
                    
                }
                
                if let globalShipping = res["Item"]["GlobalShipping"].string {
                    
                }
                
                if let handlingTime = res["Item"]["HandlingTime"].string {
                    
                }
                
                if let returnsAccepted = res["Item"]["ReturnPolicy"]["ReturnsAccepted"].string {
                    
                }
                
                
                if let refund = res["Item"]["ReturnPolicy"]["Refund"].string {
                    
                }
                
                if let returnsWithin = res["Item"]["ReturnPolicy"]["ReturnsWithin"].string {
                    
                }
                
                if let shippingCostPaidBy = res["Item"]["ReturnPolicy"]["ShippingCostPaidBy"].string {
                    
                }
                
                SwiftSpinner.hide()
            }
        }
    }
    


    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x:0, y: view.frame.size.height, width: view.frame.size.width, height: 150))
        let separator = UIView(frame: CGRect(x:15, y: header.frame.size.height - 15, width: header.frame.size.width, height: 1))
        separator.backgroundColor = UIColor.lightGray
        let label = UILabel()
        label.text = sections[section]
//        header.addSubview(separator)
        header.addSubview(label)
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shippingCell", for: indexPath)
        let name = sections[indexPath.row]
//        cell.textLabel?.text = "\(name) Section: \(indexPath.section) Row: \(indexPath.row)"
        return cell
    }
    
    
    //======================
    
    func fetchDetails(itemID: String, completion: @escaping (JSON) -> Void) {
        
        let parameters: Parameters = ["itemID": itemID]
        
        Alamofire.request("http://localhost:8080/itemDetails", method: .get, parameters: parameters).responseData { (response) -> Void in
            guard response.result.isSuccess,
                let value = response.result.value  else {
                    let serviceError = UIAlertView(title: "Details service Error!", message: "Failed to fetch Item Details",
                                                   delegate: self, cancelButtonTitle: "Ok")
                    SwiftSpinner.hide()
                    serviceError.show()
                    return
            }
            
            let swiftyJsonVar = JSON(value)
            
            guard swiftyJsonVar["Ack"] == "Success"  else {
                let noResults = UIAlertView(title: "No Details!", message: "Failed to fetch item details",
                                            delegate: self, cancelButtonTitle: "Ok")
                SwiftSpinner.hide()
                noResults.show()
                return
            }
            
            completion(swiftyJsonVar)
        }
    }
    
    //==========================

}
