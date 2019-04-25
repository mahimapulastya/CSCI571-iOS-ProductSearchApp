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

class KeyValue {
    var key : String
    var value: NSAttributedString
    
    init(key: String, value: NSAttributedString) {
        self.key = key
        self.value = value
    }
}

class ShippingTabTableViewController: UITableViewController {

    var product: Product?
    var sections: [String] = []
    var sectionImages: [UIImage]? = []
    
    var sellerKeyValue: [KeyValue] = []
    var shippingKeyValue: [KeyValue] = []
    var returnPolicyKeyValue: [KeyValue] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.clear
        tableView.alwaysBounceVertical = false
        product = (self.tabBarController as! ProductDetailViewController).product
        SwiftSpinner.show("Fetching Shipping Data...")
        
        if let itemId = product?.itemId {
            fetchDetails(itemID: itemId) { res in
                if let storeName = res["Item"]["Storefront"]["StoreName"].string {
                    if let storeURL = res["Item"]["Storefront"]["StoreURL"].string {
                        let attributedString = NSAttributedString(string: storeName)
                        let linkedText = NSMutableAttributedString(attributedString: attributedString)
                        let hyperlinked = linkedText.setAsLink(textToFind: storeName, linkURL: storeURL)
                        
                        if hyperlinked {
                            self.sellerKeyValue.append(KeyValue(key: "Store Name", value: NSAttributedString(attributedString: linkedText)))
                        }
                    }
                }
            
                
                if let feedbackScore = res["Item"]["Seller"]["FeedbackScore"].number {
                    self.sellerKeyValue.append(KeyValue(key: "Feedback Score", value: NSAttributedString(string: "\(feedbackScore)")))
                }
                
                if let feedbackpercent = res["Item"]["Seller"]["PositiveFeedbackPercent"].rawString() {
                    self.sellerKeyValue.append(KeyValue(key: "Popularity", value: NSAttributedString(string: feedbackpercent)))
                }
                
                if let feedbackRatingStar = res["Item"]["Seller"]["FeedbackRatingStar"].string {
                    if feedbackRatingStar != "None" {
                       self.sellerKeyValue.append(KeyValue(key: "Feedback Star", value: NSAttributedString(string: feedbackRatingStar)))
                    }
                }
                
                if var currprice = res["Item"]["CurrentPrice"]["Value"].rawString() {
                    if currprice == "0.0" {
                        currprice = "FREE"
                    } else {
                        currprice = "$\(currprice)"
                    }
                    self.shippingKeyValue.append(KeyValue(key: "Shipping Cost", value: NSAttributedString(string: currprice)))
                }
                
                if let globalShipping = res["Item"]["GlobalShipping"].bool {
                    
                    self.shippingKeyValue.append(KeyValue(key: "Global Shipping", value: NSAttributedString(string: globalShipping == true ? "Yes" : "No")))
                }
                
                if let handlingTime = res["Item"]["HandlingTime"].rawString() {
                    self.shippingKeyValue.append(KeyValue(key: "Handling Time", value: NSAttributedString(string: res["Item"]["HandlingTime"].number!.intValue <= 1 ? "\(handlingTime) Day": "\(handlingTime) Days")))
                }
                
                if let returnsAccepted = res["Item"]["ReturnPolicy"]["ReturnsAccepted"].string {
                    self.returnPolicyKeyValue.append(KeyValue(key: "Policy", value: NSAttributedString(string: returnsAccepted)))
                }
                
                
                if let refund = res["Item"]["ReturnPolicy"]["Refund"].string {
                     self.returnPolicyKeyValue.append(KeyValue(key: "Refund Mode", value: NSAttributedString(string: refund)))
                }
                
                if let returnsWithin = res["Item"]["ReturnPolicy"]["ReturnsWithin"].string {
                    self.returnPolicyKeyValue.append(KeyValue(key: "Return Within", value: NSAttributedString(string: returnsWithin)))
                }
                
                if let shippingCostPaidBy = res["Item"]["ReturnPolicy"]["ShippingCostPaidBy"].string {
                    self.returnPolicyKeyValue.append(KeyValue(key: "Shipping Cost Paid By", value: NSAttributedString(string: shippingCostPaidBy)))
                }
                
                if self.sellerKeyValue.count > 0 {
                    self.sections.append("Seller")
                    self.sectionImages?.append(UIImage(named: "Seller")!)
                }

                if self.sellerKeyValue.count > 0 {
                    self.sections.append("Shipping Info")
                    self.sectionImages?.append(UIImage(named: "Shipping Info")!)
                }

                if self.sellerKeyValue.count > 0 {
                    self.sections.append("Return Policy")
                    self.sectionImages?.append(UIImage(named: "Return Policy")!)
                }
                
                SwiftSpinner.hide()
                self.tableView.reloadData()
            }
        }
    }
    


    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.sections[section] == "Seller" {
            return sellerKeyValue.count
        }
        if self.sections[section] == "Shipping Info" {
            return shippingKeyValue.count
        }
        
        if self.sections[section] == "Return Policy" {
            return returnPolicyKeyValue.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: NibIdentifiers.shippingSectionHeaderView.rawValue) as? ShippingSectionHeaderView
        header?.setTitle(title: sections[section], image: sectionImages?[section])
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(70)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shippingCell", for: indexPath) as! ShippingCellView
        cell.selectionStyle = .none
        if self.sections[indexPath.section] == "Seller" {
            let nv = self.sellerKeyValue[indexPath.row]
            cell.setUpNameValue(name: nv.key, value: nv.value)
        }
        
        else if self.sections[indexPath.section] == "Shipping Info" {
            let nv = self.shippingKeyValue[indexPath.row]
            cell.setUpNameValue(name: nv.key, value: nv.value)
        }
        
        else if self.sections[indexPath.section] == "Return Policy" {
            let nv = self.returnPolicyKeyValue[indexPath.row]
            cell.setUpNameValue(name: nv.key, value: nv.value)
        }
        return cell
    }
    
    
    //======================
    
    func fetchDetails(itemID: String, completion: @escaping (JSON) -> Void) {
        
        let parameters: Parameters = ["itemID": itemID]
        
        Alamofire.request("https://hw8-backend.appspot.com/itemDetails", method: .get, parameters: parameters).responseData { (response) -> Void in
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

extension NSMutableAttributedString {
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            
            self.addAttribute(.link, value: linkURL, range: foundRange)
            
            return true
        }
        return false
    }
}
