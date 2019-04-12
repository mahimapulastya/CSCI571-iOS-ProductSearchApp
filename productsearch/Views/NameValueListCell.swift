//
//  NameValueListCell.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/11/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import Foundation
import UIKit

class NameValueListCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    func setUpNameValue(name: String, value: String) {
        nameLabel.text = name
        valueLabel.text = value
    }
}
