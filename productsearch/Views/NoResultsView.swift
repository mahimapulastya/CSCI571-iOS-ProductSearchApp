//
//  NoResultsView.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/13/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import UIKit

class NoResultsView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupNib()
    }
    
    var message: String? {
        didSet {
            messageLabel.text = message;
        }
    }
    
    private func setupNib() {
        UINib(nibName: NibIdentifiers.noResultsView.rawValue, bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
    }
    
    //MARK: - Methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
