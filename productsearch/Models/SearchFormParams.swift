//
//  SearchFormParams.swift
//  productsearch
//
//  Created by Mahima Pulastya on 4/25/19.
//  Copyright © 2019 Mahima Pulastya. All rights reserved.
//

import Foundation

class SearchFormParams {
    var keyword: String?
    var postalCode: String?
    var categoryId: String?
    var distance: Int?
    var newC: Bool?
    var usedC: Bool?
    var unspec: Bool?
    var localpickup: Bool?
    var freeshipping: Bool?
    
    init(keyword: String?, postalCode: String?, categoryId: String?, distance: Int?, newC: Bool?, usedC: Bool?, unspec: Bool?, localpickup: Bool?, freeshipping: Bool?) {
        self.keyword = keyword
        self.postalCode = postalCode
        self.categoryId = categoryId
        self.distance = distance
        self.newC = newC
        self.usedC = usedC
        self.unspec = unspec
        self.localpickup = localpickup
        self.freeshipping = freeshipping
    }
}
