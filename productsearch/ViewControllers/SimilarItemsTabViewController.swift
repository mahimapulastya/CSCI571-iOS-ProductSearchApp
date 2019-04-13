//
//  SimilarItemsTabViewController.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/11/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class SimilarItemsTabViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var gridView: UICollectionView!
    var productItemId: String?
    
    var similarItems: [SimilarItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.delegate = self
        gridView.dataSource = self
        productItemId = (self.tabBarController as! ProductDetailViewController).product?.itemId
        SwiftSpinner.show("Fetching Similar Items")
        if let itemId = productItemId {
            self.fetchSimilarItems(itemID: itemId) { res in
                
                if let itemArray = res["getSimilarItemsResponse"]["itemRecommendations"]["item"].array {
                    for itemDict in itemArray {
                        var priceString: String?
                        if let price = itemDict["buyItNowPrice"]["__value__"].string {
                            priceString = "$\(price)"
                        }
                        let title = itemDict["title"].string
                        let url = URL(string: itemDict["imageURL"].string ?? "")
                        let data = try? Data(contentsOf: url!)
                        var image: UIImage?
                        if let imageData = data {
                            image = UIImage(data: imageData)
                        }
                        
                        var shippingPrice: String?
                        if let costValue = itemDict["shippingCost"]["__value__"].string {
                            shippingPrice = "$\(costValue)"
                        }
                        
                        var daysLeft: String?
                        if let daysValue = itemDict["timeLeft"].string {
                            if let range = daysValue.range(of: "D"){
                                if let range1 = daysValue.range(of: "P"){
                                    let nextIndex = daysValue.index(range1.lowerBound, offsetBy: 1)
                                    let substring = daysValue[nextIndex..<range.lowerBound]   // ab
                                    let string = String(substring)
                                    if (string == "0" || string == "1") {
                                        daysLeft = "$\(string) Day Left"
                                    } else  {
                                        daysLeft = "$\(string) Days Left"
                                    }
                                }
                            }
                        }
                        let viewItemURL = itemDict["viewItemURL"].string
                        
                        let similarItem = SimilarItem(image: image ?? UIImage(named: "trojan")!, title: title ?? "", price: priceString ?? "", daysLeft: daysLeft ?? "", shippingPrice: shippingPrice ?? "", itemURL: viewItemURL ?? "")
                        self.similarItems.append(similarItem)
                    }
                }
                
                SwiftSpinner.hide()
                self.gridView.reloadData()
            }
        }
    }
    
    //======================
    
    func fetchSimilarItems(itemID: String, completion: @escaping (JSON) -> Void) {
        
        let parameters: Parameters = ["itemID": itemID]
        
        Alamofire.request("http://localhost:8080/similarItems", method: .get, parameters: parameters).responseData { (response) -> Void in
            guard response.result.isSuccess,
                let value = response.result.value  else {
                    let serviceError = UIAlertView(title: "Details service Error!", message: "Failed to fetch Item Details",
                                                   delegate: self, cancelButtonTitle: "Ok")
                    SwiftSpinner.hide()
                    serviceError.show()
                    return
            }
            
            let swiftyJsonVar = JSON(value)
            
            guard swiftyJsonVar["getSimilarItemsResponse"]["ack"] == "Success" else {
                let noResults = UIAlertView(title: "No Details!", message: "Failed to fetch item details",
                                            delegate: self, cancelButtonTitle: "Ok")
                SwiftSpinner.hide()
                noResults.show()
                return
            }
            
//            guard swiftyJsonVar["getSimilarItemsResponse"]["itemRecommendations"]["item"].array?.count > 0 else {
//                let noResults = UIAlertView(title: "No Similar Items!", message: "No Similar Items",
//                                            delegate: self, cancelButtonTitle: "Ok")
//                SwiftSpinner.hide()
//                noResults.show()
//                return
//            }
            
            completion(swiftyJsonVar)
        }
    }
    
    //==========================
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gridView.dequeueReusableCell(withReuseIdentifier: "similarItemCell", for: indexPath) as! SimilarItemCell
        let item = self.similarItems[indexPath.row]
        cell.setupGridBox(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.similarItems[indexPath.row]
        guard let url = URL(string: item.itemURL) else { return }
        UIApplication.shared.open(url)
    }
}
