//
//  WishListViewController.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/7/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import UIKit
import Toast_Swift

class WishListViewController: UIViewController {

   
    @IBOutlet weak var noResultsView: NoResultsView!
    
    @IBOutlet weak var resultsView: UIView!
    
    
    @IBOutlet weak var itemsCountLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    
    @IBOutlet weak var wishListTable: UITableView!
    
    var items: [Product] = []
    var itemProduct: Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        wishListTable.delegate = self
        wishListTable.dataSource = self
        setupNoResultsView()
    }
    
    
    func calculateCost(items: [Product]) -> Double {
        var totalCost: Double = 0.0
        for item in items {
            var price = item.productPrice
            price.remove(at: price.startIndex)
            totalCost += Double(price) ?? 0.0
        }
        
        return totalCost
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        items = []
        for element in UserDefaults.standard.dictionaryRepresentation().keys {
            if var values = UserDefaults.standard.stringArray(forKey: element) {
                if values.count == 9 {
                    items.append(Product(itemId: values[0], image: values[1], title: values[2], price: values[3], shipping: values[4], zipcode: values[5], condition: values[6], seller: values[7], viewItemURL: values[8]))
                }
            }
        }
        itemsCountLabel.text = "WishList Total (\(items.count) items)"
        totalPriceLabel.text = "$\(String(format: "%.2f", calculateCost(items: items)))"

        if(items.count == 0) {
            self.noResultsView.isHidden = false
            self.resultsView.isHidden = true
        } else {
            self.noResultsView.isHidden = true
            self.resultsView.isHidden = false
            setupTableView()
        }
    }

    func setupNoResultsView() {
        noResultsView.message = "No Items in WishList"
    }
    
    private func setupTableView() {
        wishListTable.reloadData()
    }
    
}

extension WishListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchresultcell", for: indexPath) as! SearchResultCell
        let product = self.items[indexPath.row]
        cell.setupproductview(product: product)
        cell.heartButton.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            UserDefaults.standard.removeObject(forKey: items[indexPath.row].itemId)
            self.view.makeToast("\(items[indexPath.row].productTitle) was removed from the wishList")
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            itemsCountLabel.text = "WishList Total (\(items.count) items)"
            totalPriceLabel.text = "$\(String(format: "%.2f", calculateCost(items: items)))"
            
            if(items.count == 0) {
                self.noResultsView.isHidden = false
                self.resultsView.isHidden = true
            } else {
                self.noResultsView.isHidden = true
                self.resultsView.isHidden = false
                setupTableView()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.itemProduct = self.items[indexPath.row]
        performSegue(withIdentifier: SegueIdentifier.ProductDetailsViewControllerShow.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ProductDetailViewController
        {
            let vc = segue.destination as? ProductDetailViewController
            vc?.product = self.itemProduct
        }
    }
}
