//
//  CategoryPickerView.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/9/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import Foundation
import UIKit

protocol CategoryPickerViewDelegate: class {
    func didTapDone()
    func didTapCancel()
}

class CategoryPickerView: UIPickerView {
    
    public private(set) var toolbar: UIToolbar?
    public weak var categoryDelegate: CategoryPickerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.white
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.toolbar = toolBar
    }
    
    @objc func doneTapped() {
        self.categoryDelegate?.didTapDone()
    }
    
    @objc func cancelTapped() {
        self.categoryDelegate?.didTapCancel()
    }
}
