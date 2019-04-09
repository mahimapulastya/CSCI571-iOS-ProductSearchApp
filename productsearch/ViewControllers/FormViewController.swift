//
//  FormViewController.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/7/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var searchButton: UIButton!
    
    private func setupActions() {
        searchButton.addTarget(self, action: #selector(performSearch), for: .touchUpInside)
    }
    
    @objc func performSearch(sender: UIButton) {
    
        if let searchResultsViewController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifier.SearchResultsViewControllerIdentifier.rawValue) {
            self.navigationController?.pushViewController(searchResultsViewController, animated: true)
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
