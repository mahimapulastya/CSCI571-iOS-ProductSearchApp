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
    
    enum sortOrder : Int {
        case ascending = 0
        case descending = 1
    }
    
    
    enum sortType : Int {
        case defaulttab = 0
        case name = 1
        case price = 2
        case daysLeft = 3
        case shipping = 4
    }
    

    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var gridView: UICollectionView!
    var productItemId: String?
    
    @IBOutlet weak var sortOrderSegment: UISegmentedControl!
    @IBOutlet weak var sortTypeSegment: UISegmentedControl!
    @IBOutlet weak var noResultsView: NoResultsView!
    
    var similarItems: [SimilarItem] = []
    var similarItemsCopy: [SimilarItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNoResultsView()
        gridView.delegate = self
        gridView.dataSource = self
        productItemId = (self.tabBarController as! ProductDetailViewController).product?.itemId
        SwiftSpinner.show("Fetching Similar Items")
        if let itemId = productItemId {
            self.fetchSimilarItems(itemID: itemId) { res in
                
                if let itemArray = res["getSimilarItemsResponse"]["itemRecommendations"]["item"].array {
                    for itemDict in itemArray {
                        let price = itemDict["buyItNowPrice"]["__value__"].string
                        let title = itemDict["title"].string
                        let url = URL(string: itemDict["imageURL"].string ?? "")
                        let data = try? Data(contentsOf: url!)
                        var image: UIImage?
                        if let imageData = data {
                            image = UIImage(data: imageData)
                        }
                        
                        let costValue = itemDict["shippingCost"]["__value__"].string
                        
                        var daysLeft: String?
                        if let daysValue = itemDict["timeLeft"].string {
                            if let range = daysValue.range(of: "D"){
                                if let range1 = daysValue.range(of: "P"){
                                    let nextIndex = daysValue.index(range1.lowerBound, offsetBy: 1)
                                    let substring = daysValue[nextIndex..<range.lowerBound]   // ab
                                    daysLeft = String(substring)
                                }
                            }
                        }
                        let viewItemURL = itemDict["viewItemURL"].string
                        if let image = image {
                            let similarItem = SimilarItem(image: image, title: title, price: price, daysLeft: daysLeft, shippingPrice: costValue, itemURL: viewItemURL)
                            self.similarItems.append(similarItem)
                            self.similarItemsCopy.append(similarItem)
                        }
                    }
                }
                
                SwiftSpinner.hide()
                self.gridView.reloadData()
            }
        }
    }
    
    func setupNoResultsView() {
        noResultsView.message = "No Similar Items found"
    }
    
    //======================
    
    func fetchSimilarItems(itemID: String, completion: @escaping (JSON) -> Void) {
        
        let parameters: Parameters = ["itemID": itemID]
        
        Alamofire.request("http://localhost:8080/similarItems", method: .get, parameters: parameters).responseData { (response) -> Void in
            guard response.result.isSuccess,
                let value = response.result.value  else {
                    SwiftSpinner.hide()
                    self.noResultsView.isHidden = false
                    self.gridView.isHidden = true
                    self.topStackView.isHidden = true
                    return
            }
            
            let swiftyJsonVar = JSON(value)
            
            guard swiftyJsonVar["getSimilarItemsResponse"]["ack"] == "Success" else {
                
                SwiftSpinner.hide()
                self.noResultsView.isHidden = false
                self.gridView.isHidden = true
                self.topStackView.isHidden = true
                return
            }
            
            guard swiftyJsonVar["getSimilarItemsResponse"]["itemRecommendations"]["item"].array!.count > 0 else {
                SwiftSpinner.hide()
                self.noResultsView.isHidden = false
                self.gridView.isHidden = true
                self.topStackView.isHidden = true
                return
            }
            
            completion(swiftyJsonVar)
        }
    }
    
    //==========================
    
    @IBAction func changeSortType(_ sender: UISegmentedControl) {
        sortByCurrentType(sender.selectedSegmentIndex)
        self.gridView.reloadData()
    }
    
    
    @IBAction func changeSortOrder(_ sender: UISegmentedControl) {
        sortByCurrentOrder(sender.selectedSegmentIndex)
        self.gridView.reloadData()
    }
    
    func sortByCurrentType(_ index: Int){
        guard let order = sortOrderSegment.titleForSegment(at: sortOrderSegment.selectedSegmentIndex) else {
         return
        }
        
        if order == "Ascending" {
            sortItems(index, sortOrder.ascending.rawValue)
        } else {
            sortItems(index, sortOrder.descending.rawValue)
        }
    }
    
    func sortByCurrentOrder(_ index: Int){
        guard let order = sortTypeSegment.titleForSegment(at: sortTypeSegment.selectedSegmentIndex) else {
            return
        }
        
        switch order {
        case "Default":
            sortItems(sortType.defaulttab.rawValue, index)
        case "Name":
            sortItems(sortType.name.rawValue, index)
        case "Price":
            sortItems(sortType.price.rawValue, index)
        case "Days Left":
            sortItems(sortType.daysLeft.rawValue, index)
        case "Shipping":
            sortItems(sortType.shipping.rawValue, index)
        default:
            sortItems(sortType.defaulttab.rawValue, index)
        }
    }
    
    
    func resumeOrder() {
        for i in 0..<similarItemsCopy.count{
            self.similarItems[i] = self.similarItemsCopy[i]
        }
    }
    
    func sortItems(_ sortType: Int, _ sortOrder: Int) {
        switch(sortType) {
        case 0:
            sortOrderSegment.selectedSegmentIndex = 0
            resumeOrder()
            
        case 1:
            if (sortOrder == 0) {
                similarItems.sort { $0.title! < $1.title! }
            } else {
                similarItems.sort { $0.title! > $1.title! }
            }

        case 2:
            if (sortOrder == 0) {
                similarItems.sort { Double($0.price!)! < Double($1.price!)! }
            } else {
                similarItems.sort { Double($0.price!)! > Double($1.price!)! }
            }

        case 3:
            if (sortOrder == 0) {
                similarItems.sort { Double($0.daysLeft!)! < Double($1.daysLeft!)! }
            } else {
                similarItems.sort { Double($0.daysLeft!)! > Double($1.daysLeft!)! }
            }

        case 4:
            if (sortOrder == 0) {
                similarItems.sort { Double($0.shippingPrice!)! < Double($1.shippingPrice!)!}
            } else {
                similarItems.sort { Double($0.shippingPrice!)! > Double($1.shippingPrice!)! }
            }

        default:
            sortOrderSegment.selectedSegmentIndex = 0
            resumeOrder()
        }

    }
    
    
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
        if let itemURL = item.itemURL {
            guard let url = URL(string: itemURL) else { return }
            UIApplication.shared.open(url)
        }
    }
}
