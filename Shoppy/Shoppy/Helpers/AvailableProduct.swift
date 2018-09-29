//
//  AvailableProduct.swift
//  Shoppy
//
//  Created by EGEMEN AYHAN on 22.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import Foundation
import Networking

class AvailableProduct {
    
    let productSku: String
    var color: String?
    var size: String?
    
    init(sku: String) {
        productSku = sku
    }
    
    convenience init(product: Product) {
        self.init(sku: product.sku)
        
        color = product.color
        size = product.size
    }
    
}
