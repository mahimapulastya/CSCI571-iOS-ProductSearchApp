//
//  ProductInfoViewController.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/11/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner


struct NameValue {
    var name: String
    var value: String
}

class ProductInfoViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var productTitleLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var itemSpecificsTableView: UITableView!
    
    
    @IBOutlet weak var descriptionImage: UIImageView!
    
    
    @IBOutlet weak var descriptiontext: UILabel!
    
    var product: Product?
    var ItemId = ""
    var frame = CGRect(x:0, y:0, width:0, height:0)
    
    var images: [UIImage]? = []
    var nameValueList: [NameValue] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        product = (self.tabBarController as! ProductDetailViewController).product
        self.itemSpecificsTableView.dataSource = self
        self.descriptionImage.isHidden = true
        self.descriptiontext.isHidden = true
        productTitleLabel.text = product?.productTitle
        priceLabel.text = product?.productPrice
        SwiftSpinner.show("Fetching Product Details...")
        
        if let itemId = product?.itemId {
            fetchDetails(itemID: itemId) { res in
                if let pictureURL = res["Item"]["PictureURL"].array {
                    for url in pictureURL {
                        let pictureurl = URL(string: url.string ?? "")
                        let data = try? Data(contentsOf: pictureurl!)
                        var image: UIImage?
                        if let imageData = data {
                            image = UIImage(data: imageData)
                        }
                        if let image = image {
                            self.images?.append(image)
                        }
                    }
                }
                
                if let nvList = res["Item"]["ItemSpecifics"]["NameValueList"].array {
                    self.descriptionImage.isHidden = false
                    self.descriptiontext.isHidden = false
                    for nv in nvList {
                        let name = nv["Name"].string ?? ""
                        let value = nv["Value"][0].string ?? ""
                        self.nameValueList.append(NameValue(name: name, value: value))
                    }
                }
                
                SwiftSpinner.hide()
                self.setUpImageView()
                self.setUpTableView()
            }
        }
    }
    
    private func setUpImageView() {
        guard let images = self.images else { return }
        pageControl.numberOfPages = images.count
        for index in 0..<images.count {
        frame.origin.x = imageScrollView.frame.size.width * CGFloat(index)
        frame.size = imageScrollView.frame.size
        let imageView = UIImageView(frame: frame)
        imageView.image = images[index]
        self.imageScrollView.showsHorizontalScrollIndicator = false
        self.imageScrollView.showsVerticalScrollIndicator = false
        self.imageScrollView.addSubview(imageView)
        }
        imageScrollView.contentSize = CGSize(width: (imageScrollView.frame.size.width * CGFloat(images.count)), height: imageScrollView.frame.size.height)
        imageScrollView.delegate = self
    }
    
    private func setUpTableView() {
        var frame = self.itemSpecificsTableView.frame
        frame.size.height = itemSpecificsTableView.contentSize.height
        itemSpecificsTableView.frame = frame
        self.itemSpecificsTableView.reloadData()
        itemSpecificsTableView.layoutIfNeeded()
        itemSpecificsTableView.heightAnchor.constraint(equalToConstant: itemSpecificsTableView.contentSize.height).isActive = true
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameValueList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameValueListCell", for: indexPath) as! NameValueListCell
        let nv = self.nameValueList[indexPath.row]
        cell.setUpNameValue(name: nv.name, value: nv.value)
        return cell
    }

}

extension ProductInfoViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pgNo = scrollView.contentOffset.x/scrollView.frame.size.width
        pageControl.currentPage = Int(pgNo)
    }
}
