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

class PhotosTabViewController: UIViewController, UIScrollViewDelegate {

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
    
    var frame = CGRect(x:0, y:0, width:0, height:0)
    private func setupGoogleImages() {
        if let images = self.images {
            for i in 0..<images.count {
                frame.origin.y = (self.scrollView.frame.size.height/1.5 * CGFloat(i))
                frame.size = CGSize(width: self.scrollView.frame.width, height: (self.scrollView.frame.size.height/1.5))
                let imageView = UIImageView(frame: frame)
                imageView.image = images[i]
                self.scrollView.addSubview(imageView)
            }
        }
        
        if let images = self.images {
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: (self.scrollView.frame.size.height/1.5 * CGFloat(images.count)))
            self.scrollView.delegate = self
        }
    
    }
    

    //======================
    
    func fetchGoogleImages(productTitle: String, completion: @escaping (JSON) -> Void) {
        
        let parameters: Parameters = ["productTitle": productTitle]
        
        Alamofire.request("http://localhost:8080/googlePhotos", method: .get, parameters: parameters).responseData { (response) -> Void in
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

