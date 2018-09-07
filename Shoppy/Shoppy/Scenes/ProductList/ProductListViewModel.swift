//
//  ProductListViewModel.swift
//  Shoppy
//
//  Created by EGEMEN AYHAN on 7.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import Foundation

struct ProductListState {
    
    enum Change {
        case productsUpdated
    }
    
    enum Error {
        case fetchFailed(String)
    }
    
}

class ProductListViewModel {
    
    var state = ProductListState()
    var stateChangeHandler: ((ProductListState.Change)->())?
    var errorHandler: ((ProductListState.Error)->())?
    
}
