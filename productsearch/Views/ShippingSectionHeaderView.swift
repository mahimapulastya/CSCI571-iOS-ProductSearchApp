//
//  ShippingSectionHeaderView.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/19/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import UIKit

class ShippingSectionHeaderView: UITableViewCell {

    @IBOutlet weak var sectionImage: UIImageView!
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    func setTitle(title: String?, image: UIImage?) {
        if let title = title {
            self.sectionTitleLabel.text = title
        }
        if let image = image {
             self.sectionImage.image = image
        }
    }
}
