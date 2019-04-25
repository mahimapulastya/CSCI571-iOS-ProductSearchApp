//
//  FormViewController.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/7/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import UIKit
import Toast_Swift
import Alamofire
import SwiftyJSON

class FormViewController: UIViewController {

    var keywordText = ""
    @IBOutlet weak var keywordTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var customLocationSwitch: UISwitch!
    
    @IBOutlet weak var distanceTextField: UITextField!
    
    @IBOutlet weak var customLocationStackView: UIStackView!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var customZipCodesView: UITableView!
    @IBOutlet weak var clearButton: UIButton!
    
    
    @IBOutlet weak var newButton: CheckBoxButton!
    @IBOutlet weak var usedButton: CheckBoxButton!
    @IBOutlet weak var unspecifiedButton: CheckBoxButton!
    
    
    @IBOutlet weak var localPickupButton: CheckBoxButton!
    @IBOutlet weak var freeShippingButton: CheckBoxButton!
    
    var selectedCategory: String = ""
    private let categoryPicker = CategoryPickerView()
    let categoryList = ["All", "Art" , "Baby" , "Books", "Clothing, Shoes & Accessories", "Computer/Tablets & Networking", "Health & Beauty", "Music", "Video Games & Console"]
    let categoryCode = ["", "550", "2984", "267", "11450", "58058", "26395", "11233", "1249" ]
    
    @IBOutlet weak var searchButton: UIButton!
    var zipCodes: [String] = []
    var currLocZip: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryTextField.inputView = self.categoryPicker
        self.categoryTextField.inputAccessoryView = self.categoryPicker.toolbar
        self.categoryPicker.dataSource = self
        self.categoryPicker.delegate = self
        self.categoryPicker.categoryDelegate = self
        self.distanceTextField.placeholder = "10"
        self.zipcodeTextField.placeholder = "Zipcode"
        self.customLocationSwitch.isOn = false
        
        setUpZipTableView()
        setupCustomZipTableView()
        fetchCurrentLocation()
        zipcodeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.categoryPicker.reloadAllComponents()
    }
    
    func setupCustomZipTableView() {
        self.customZipCodesView.delegate = self
        self.customZipCodesView.dataSource = self
        self.customZipCodesView.register(UITableViewCell.self, forCellReuseIdentifier: "postalCodeCell")
    }
    
    func fetchCurrentLocation() {
        fetchCurrentLoc() { res in
            self.currLocZip = res
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text!.isEmpty  {
            self.customZipCodesView.isHidden = true
            self.buttonStackView.isHidden = false
        }
        
        if let code  = textField.text {
            fetchZipCode(code: code) { swiftyJsonVar in
                
                if let postalCodesArray = swiftyJsonVar["postalCodes"].array {
                    self.zipCodes = []
                     for itemDict in postalCodesArray {
                        if let zipcode = itemDict["postalCode"].string {
                            self.zipCodes.append(zipcode)
                        }
                    }
                }
                self.customZipCodesView.reloadData()
                self.customZipCodesView.isHidden = false
                self.buttonStackView.isHidden = true
            }
        }
    }
    
    
    //======================
    
    func fetchZipCode(code: String, completion: @escaping (JSON) -> Void) {
        
        let parameters: Parameters = ["code": code]
        
        Alamofire.request("https://hw8-backend.appspot.com/geoname", method: .get, parameters: parameters).responseData { (response) -> Void in
            guard response.result.isSuccess,
                let value = response.result.value  else {
                    return
            }
            
            let swiftyJsonVar = JSON(value)
            let res = swiftyJsonVar["postalCodes"].array
            
            guard (res?.count)! > 0  else {
                return
            }
            
            completion(swiftyJsonVar)
        }
    }
    
    
    func fetchCurrentLoc(completion: @escaping (String) -> Void) {
        
        let parameters: Parameters = ["fields": "zip"]
        
        Alamofire.request("http://ip-api.com/json", method: .get, parameters: parameters).responseData { (response) -> Void in
            guard response.result.isSuccess,
                let value = response.result.value  else {
                    return
            }
            
            let swiftyJsonVar = JSON(value)
            let res = swiftyJsonVar["zip"].string
            
            guard let zip = res else {
                return
            }
            
            completion(zip)
        }
    }
    
    //==========================
    
    func setUpZipTableView() {
        self.customZipCodesView.layer.borderColor = UIColor.black.cgColor
        self.customZipCodesView.layer.borderWidth = 1.0
        self.customZipCodesView.layer.cornerRadius = 6.0
    }

    @IBAction func locationSwitchValueChange(_ sender: Any) {
        if customLocationSwitch.isOn {
            self.customLocationStackView.isHidden = false
            self.zipcodeTextField.isHidden = false
        } else {
            self.customLocationStackView.isHidden = true
            self.zipcodeTextField.isHidden = true
        }
    }
    
    
    @IBAction func performSearch(_ sender: UIButton) {
        if(isValidForm()) {
            self.keywordText = keywordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            performSegue(withIdentifier: SegueIdentifier.SearchResultsViewControllerControllerShow.rawValue, sender: self)
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SearchResultsViewController
        {
            let vc = segue.destination as? SearchResultsViewController
           
            if self.customLocationSwitch.isOn {
                vc?.searchFormParams = SearchFormParams(keyword: self.keywordText, postalCode: self.zipcodeTextField.text, categoryId: self.selectedCategory, distance: (((self.distanceTextField.text?.isEmpty)!) ? 10 : Int(self.distanceTextField.text!)), newC: newButton.isSelected(), usedC: usedButton.isSelected(), unspec: unspecifiedButton.isSelected(), localpickup: localPickupButton.isSelected(), freeshipping: freeShippingButton.isSelected())
            } else {
                vc?.searchFormParams = SearchFormParams(keyword: self.keywordText, postalCode: self.currLocZip, categoryId: self.selectedCategory, distance: (((self.distanceTextField.text?.isEmpty)!) ? 10 : Int(self.distanceTextField.text!)), newC: newButton.isSelected(), usedC: usedButton.isSelected(), unspec: unspecifiedButton.isSelected(), localpickup: localPickupButton.isSelected(), freeshipping: freeShippingButton.isSelected())
            }
        }
    }

    func isValidForm() -> Bool {
        var isValid: Bool = true
        if keywordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            isValid = false
            self.view.makeToast("Keyword is mandatory")
        }
        
        if customLocationSwitch.isOn && zipcodeTextField.text!.isEmpty {
            isValid = false
            self.view.makeToast("Zipcode is mandatory")
        }

        return isValid
    }
    
    @IBAction func clearForm(_ sender: UIButton) {
        self.keywordTextField.text = ""
        self.categoryTextField.text = ""
        self.distanceTextField.text = ""
        self.zipcodeTextField.text = ""
        self.selectedCategory = ""
        
        self.newButton.isChecked = false
        self.usedButton.isChecked = false
        self.unspecifiedButton.isChecked = false
        self.localPickupButton.isChecked = false
        self.freeShippingButton.isChecked = false
        
        self.customLocationSwitch.isOn = false
        self.customLocationStackView.isHidden = true
        self.zipcodeTextField.isHidden = true
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
        self.selectedCategory = self.categoryCode[row]
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

extension FormViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.zipCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postalCodeCell", for: indexPath)
        let code = self.zipCodes[indexPath.row]
        cell.textLabel?.text = code
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.zipcodeTextField.text = self.zipCodes[indexPath.row]
        self.customZipCodesView.isHidden = true
        self.buttonStackView.isHidden = false
    }
}
