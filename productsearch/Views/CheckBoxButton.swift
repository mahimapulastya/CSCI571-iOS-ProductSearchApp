//
//  CheckBoxButton.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/9/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import Foundation
import UIKit

class CheckBoxButton: UIButton {
    let checkedImage = UIImage(named : "checked")
    let uncheckedImage = UIImage(named : "unchecked")
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    func isSelected() -> Bool {
        return self.isChecked
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(checkBoxSelected), for: .touchUpInside)
        self.isChecked = false
    }
    
    @objc func checkBoxSelected(sender: UIButton) {
        if sender == self {
            (isChecked == true) ? (isChecked = false) : (isChecked = true)
        }
    }
}
