//
//  ProductDetailViewModel.swift
//  Shoppy
//
//  Created by EGEMEN AYHAN on 9.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import Foundation
import Networking

struct ProductDetailState {
    
    let product: Product
    
    init(product: Product) {
        self.product = product
    }
    
}

class ProductDetailViewModel {
    
    let state: ProductDetailState!
    
    init(product: Product) {
        state = ProductDetailState(product: product)
    }
    
}
