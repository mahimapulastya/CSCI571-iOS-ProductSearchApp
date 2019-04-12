//
//  PhotosTabViewController.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/11/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner

class PhotosTabViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    
    var images: [UIImage]? = []
    var productTitle: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        productTitle = (self.tabBarController as! ProductDetailViewController).product?.productTitle
        SwiftSpinner.show("Fetching Google Images...")
        if let title = productTitle {
            fetchGoogleImages(productTitle: title) { res in
                
                if let imagesArray = res["items"].array {
                    for image in imagesArray {
                        let url = URL(string: image["link"].string ?? "")
                        let data = try? Data(contentsOf: url!)
                        var image: UIImage?
                        if let imageData = data {
                            image = UIImage(data: imageData)
                        }
                        self.images?.append(image ?? UIImage(named: "trojan")!)
                    }
                    }
                self.setupGoogleImages()
                SwiftSpinner.hide()
                }
            }
    }
    
    var yIndex = CGFloat(0)
    
    private func setupGoogleImages() {
        if let images = self.images {
            for img in images {
                let imageView = UIImageView()
                imageView.image = img
                imageView.frame.size.width = 343
                imageView.frame.size.height = 300
                imageView.frame.origin.x = 10
                imageView.frame.origin.y = yIndex
                
                self.scrollView.addSubview(imageView)
                yIndex += 300

//                scrollViewContentSize += 300
//                scrollView.contentSize = CGSize(width: imageWidth, height:scrollViewContentSize)
                
            }
        }
    }
            
        
    

    //======================
    
    func fetchGoogleImages(productTitle: String, completion: @escaping (JSON) -> Void) {
        
        let parameters: Parameters = ["productTitle": productTitle]
        
        Alamofire.request("https://myweb-hw8-backend.appspot.com/googlePhotos", method: .get, parameters: parameters).responseData { (response) -> Void in
            guard response.result.isSuccess,
                let value = response.result.value  else {
                    let serviceError = UIAlertView(title: "Google Image service Error!", message: "Failed to fetch the images",
                                                   delegate: self, cancelButtonTitle: "Ok")
                    SwiftSpinner.hide()
                    serviceError.show()
                    return
            }
            
            let swiftyJsonVar = JSON(value)
            
            guard swiftyJsonVar["items"].array?.count != nil && swiftyJsonVar["items"].array!.count > 0  else {
                let noResults = UIAlertView(title: "No Google Image Found!", message: "",
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

