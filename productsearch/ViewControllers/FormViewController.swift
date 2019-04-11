//
//  FormViewController.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/7/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import UIKit
import Toast_Swift

class FormViewController: UIViewController {

    var keywordText = ""
    @IBOutlet weak var keywordTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    
    private let categoryPicker = CategoryPickerView()
    let categoryList = ["All", "Art" , "Baby" , "Books", "Clothing, Shoes & Accessories", "Computer/Tablets & Networking", "Health & Beauty", "Music", "Video Games & Console"]
    
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryTextField.inputView = self.categoryPicker
        self.categoryTextField.inputAccessoryView = self.categoryPicker.toolbar
        self.categoryPicker.dataSource = self
        self.categoryPicker.delegate = self
        self.categoryPicker.categoryDelegate = self
        
        self.categoryPicker.reloadAllComponents()
    }

    @IBAction func performSearch(_ sender: UIButton) {
        if(isValidForm()) {
            self.keywordText = keywordTextField.text!
            performSegue(withIdentifier: SegueIdentifier.SearchResultsViewControllerControllerShow.rawValue, sender: self)
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SearchResultsViewController
        {
            let vc = segue.destination as? SearchResultsViewController
            vc?.keyword = self.keywordText
        }
    }
    
    
    
    func isValidForm() -> Bool {
        var isValid: Bool = true
        if keywordTextField.text!.isEmpty {
            isValid = false
            self.view.makeToast("Keyword is mandatory")
        }
        
        // zipcode validation
        return isValid
    }


}

extension FormViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categoryList.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categoryList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryTextField.text = self.categoryList[row]
    }
}

extension FormViewController: CategoryPickerViewDelegate {
    
    func didTapDone() {
        let row = self.categoryPicker.selectedRow(inComponent: 0)
        self.categoryPicker.selectRow(row, inComponent: 0, animated: false)
        self.categoryTextField.text = self.categoryList[row]
        self.categoryTextField.resignFirstResponder()
    }
    
    func didTapCancel() {
        self.categoryTextField.text = nil
        self.categoryTextField.resignFirstResponder()
    }
}
