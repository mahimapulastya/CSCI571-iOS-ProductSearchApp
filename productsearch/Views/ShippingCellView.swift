//
//  ShippingCellView.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/19/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import UIKit

class ShippingCellView: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var valueView: UIView!
    
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var feedbackStarImage: UIImageView!
    
    var storeURL : String?
    
    func setUpNameValue(name: String, value: NSAttributedString) {
        
        if name == "Store Name" {
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(self.onClick(sender:)))
            valueLabel.isUserInteractionEnabled = true
            tapgesture.numberOfTapsRequired = 1
            let test = value.string.components(separatedBy: "&%$##")
            valueLabel.addGestureRecognizer(tapgesture)
            valueLabel.attributedText = NSAttributedString(string: test[0], attributes:
                [.underlineStyle: NSUnderlineStyle.single.rawValue])
            valueLabel.textColor = UIColor.blue
            valueLabel.textAlignment = .center
            valueLabel.font =  UIFont.systemFont(ofSize: 15.0)
            nameLabel.text = name
            storeURL = test[1]
        }
        
        else if name == "Feedback Star" {
            valueLabel.isHidden = true
            feedbackStarImage.isHidden = false
            setFeedbackImage(value: value.string)
            nameLabel.text = name
            valueLabel.attributedText = value
            
        } else {
            nameLabel.text = name
            valueLabel.attributedText = value
        }
    }
    
    
    func setFeedbackImage(value: String)  {
        switch value {
        case "Blue":
            feedbackStarImage.image = UIImage(named: "starBorder")!.withRenderingMode(.alwaysTemplate)
            feedbackStarImage.tintColor = UIColor.blue
        case "Green":
            feedbackStarImage.image = UIImage(named: "starBorder")!.withRenderingMode(.alwaysTemplate)
            feedbackStarImage.tintColor = UIColor.green
        case "GreenShooting":
            feedbackStarImage.image = UIImage(named: "star")!.withRenderingMode(.alwaysTemplate)
            feedbackStarImage.tintColor = UIColor.green
        case "Purple":
            feedbackStarImage.image = UIImage(named: "starBorder")!.withRenderingMode(.alwaysTemplate)
            feedbackStarImage.tintColor = UIColor.purple
        case "PurpleShooting":
            feedbackStarImage.image = UIImage(named: "star")!.withRenderingMode(.alwaysTemplate)
            feedbackStarImage.tintColor = UIColor.purple
        case "Red":
            feedbackStarImage.image = UIImage(named: "starBorder")!.withRenderingMode(.alwaysTemplate)
            feedbackStarImage.tintColor = UIColor.red
        case "RedShooting":
            feedbackStarImage.image = UIImage(named: "star")!.withRenderingMode(.alwaysTemplate)
            feedbackStarImage.tintColor = UIColor.red
        case "Silver":
            feedbackStarImage.image = UIImage(named: "starBorder")!.withRenderingMode(.alwaysTemplate)
            feedbackStarImage.tintColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
        case "SilverShooting":
            feedbackStarImage.image = UIImage(named: "star")!.withRenderingMode(.alwaysTemplate)
            feedbackStarImage.tintColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
        case "Turquoise":
            feedbackStarImage.image = UIImage(named: "starBorder")!.withRenderingMode(.alwaysTemplate)
            feedbackStarImage.tintColor = UIColor(red: 64/255, green: 224/255, blue: 208/255, alpha: 1.0)
        case "TurquoiseShooting":
            feedbackStarImage.image = UIImage(named: "star")!.withRenderingMode(.alwaysTemplate)
             feedbackStarImage.tintColor = UIColor(red: 64/255, green: 224/255, blue: 208/255, alpha: 1.0)
        case "Yellow":
            feedbackStarImage.image = UIImage(named: "starBorder")!.withRenderingMode(.alwaysTemplate)
            feedbackStarImage.tintColor = UIColor.yellow
        case "YellowShooting":
            feedbackStarImage.image = UIImage(named: "star")!.withRenderingMode(.alwaysTemplate)
            feedbackStarImage.tintColor = UIColor.yellow
        default:
            feedbackStarImage.isHidden = true
        }
    }
    
    @objc func onClick (sender: UILabel) {
        if let storeURL = storeURL {
            UIApplication.shared.open(URL(string: storeURL)!, options: [:])
        }
    }
}
