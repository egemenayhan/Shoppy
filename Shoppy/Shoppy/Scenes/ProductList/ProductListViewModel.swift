//
//  ProductListViewModel.swift
//  Shoppy
//
//  Created by EGEMEN AYHAN on 7.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import Foundation
import Networking

// MARK: - State
struct ProductListState {
    
    var page = 0
    var products: [Product] = []
    
    enum Change {
        case productsUpdated
    }
    
    enum Error {
        case fetchFailed(String)
    }
    
}

fileprivate extension ProductListState {
    
    mutating func update(with newProducts: [Product]) -> Change {
        products.append(contentsOf: newProducts)
        
        return .productsUpdated
    }
    
    @discardableResult mutating func resetProducts() -> Change {
        products = []
        
        return .productsUpdated
    }
    
    mutating func nextPage() {
        page += 1
    }
    
}

// MARK: - View model
class ProductListViewModel {
    
    var stateChangeHandler: ((ProductListState.Change)->())?
    var errorHandler: ((ProductListState.Error)->())?
    private(set) var state = ProductListState()
    private var activeTask: URLSessionTask?
    
    func fetchNextPage() {
        var nextPageNumber = state.page
        if state.products.count != 0 {
            nextPageNumber += 1
        }
        
        fetch(page: nextPageNumber)
    }
    
    func reloadProducts()  {
        state.resetProducts()
        fetch(page: 0)
    }
    
}

// MARK: - Private extension
private extension ProductListViewModel {
    
    func fetch(page: Int) {
        if let task = activeTask {
            task.cancel()
        }
        
        let request = ProductListRequest(page: page)
        activeTask = Networking.shared.execute(request: request) { [weak self] (response: Response<ProductListRequest.Response>) in
            guard let strongSelf = self else { return }
            
            switch response.result {
            case .success(let page):
                if page.products.count > 0 {
                    strongSelf.state.nextPage()
                    strongSelf.stateChangeHandler?(strongSelf.state.update(with: page.products))
                }
            case .failure(_):
                // TODO: handle error
                break
            }
        }
    }
    
}
