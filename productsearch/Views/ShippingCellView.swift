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
    
    func setUpNameValue(name: String, value: NSAttributedString) {
        
        valueLabel.isUserInteractionEnabled = true
        if name == "Store Name" {
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(onClick))
            tapgesture.numberOfTapsRequired = 1
            valueLabel.addGestureRecognizer(tapgesture)
        }
        
        if name == "Feedback Star" {
            valueLabel.isHidden = true
            feedbackStarImage.isHidden = false
            setFeedbackImage(value: value.string)
            
        }
        nameLabel.text = name
        valueLabel.attributedText = value
    
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
    
    @objc func onClick () -> Bool {
        print("something")
//        UIApplication.shared.open(URL(string: valueString!.value(forKey: NSAttributedString.Key.link.rawValue) as! String)!, options: [:])
        return false
    }
    
    
}
