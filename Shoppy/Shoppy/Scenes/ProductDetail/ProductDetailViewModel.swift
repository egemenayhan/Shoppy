//
//  ProductDetailViewModel.swift
//  Shoppy
//
//  Created by EGEMEN AYHAN on 9.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import Foundation
import Networking

// MARK: - State
struct ProductDetailState {
    
    // MARK: - Properties
    enum Change {
        case productUpdated
        case selectedproductChanged
        case showLoader(Bool)
    }
    
    enum Error {
        case productUpdateFailed(String)
    }
    
    private(set) var product: Product
    private(set) var availableProducts: [AvailableProduct] = []
    private(set) var selectedAvailableProduct: AvailableProduct?
    
    // MARK: - Lifecycle
    init(product: Product) {
        self.product = product
        processAvailableProducts(product.configurableAttributes)
        
        // Searching for current product
        let result = availableProducts.filter({ (availableProduct) -> Bool in
            var found: Bool = false
            if availableProduct.size == product.size {
                found = true
            }
            
            if let color = availableProduct.color, color != product.color {
                found = false
            }
            
            return found
        })
        
        if result.count == 1 {
            // Current product found
            selectedAvailableProduct = result.first
        }
    }
    
    mutating func update(product: Product) -> Change {
        self.product = product
        return .productUpdated
    }
    
    @discardableResult mutating func update(selectedAvailableProduct: AvailableProduct) -> Change {
        self.selectedAvailableProduct = selectedAvailableProduct
        return .selectedproductChanged
    }
    
}

// MARK: - State private extension
private extension ProductDetailState {
    
    mutating func processAvailableProducts(_ configurableAttributes: [ConfigurableAttribute]) {
        for attribute: ConfigurableAttribute in configurableAttributes {
            createAvailableProducts(from: attribute.options, forType: attribute.type)
        }
    }
    
    mutating func createAvailableProducts(from options: [ConfigurableAttributeOption], forType type: ConfigurableAttribute.ConfigurableAttributeType) {
        for option: ConfigurableAttributeOption in options {
            optionLoop: for productSku: String in option.productSkus {
                // We must search in availableProducts to check if it exist.
                availableProductLoop: for index in 0..<availableProducts.count {
                    let availableProduct = availableProducts[index]
                    
                    // If availableProduct exist, we will fill its fields
                    if availableProduct.productSku == productSku {
                        switch type {
                        case .color:
                            availableProduct.color = option.title
                        case .size:
                            availableProduct.size = option.title
                        case .unknown:
                            break
                        }
                        
                        // AvailableProduct found no need to create new one so we break the inner loop
                        continue optionLoop
                    }
                }
                
                // AvailableProduct not found for sku so we create new one
                let product = AvailableProduct(sku: productSku)
                switch type {
                case .color:
                    product.color = option.title
                case .size:
                    product.size = option.title
                case .unknown:
                    break
                }
                availableProducts.append(product)
            }
        }
    }
    
}
    
// MARK: - View Model
class ProductDetailViewModel {
    
    // MARK: - Properties
    private(set) var state: ProductDetailState!
    var stateChangeHandler: ((ProductDetailState.Change)->())?
    var errorHandler: ((ProductDetailState.Error)->())?
    
    // MARK: - Lifecycle
    init(product: Product) {
        state = ProductDetailState(product: product)
    }
    
    func load(product availableProduct: AvailableProduct) {
        stateChangeHandler?(.showLoader(true))
        let request = ProductRequest(sku: availableProduct.productSku)
        Networking.shared.execute(request: request) { [weak self] (response: Response<ProductRequest.Response>) in
            guard let strongSelf = self else { return }
            
            switch response.result {
            case .success(let product):
                // Update product and selectedAvailableProduct
                let productChange = strongSelf.state.update(product: product)
                strongSelf.stateChangeHandler?(productChange)
                let selectedChange = strongSelf.state.update(selectedAvailableProduct: availableProduct)
                strongSelf.stateChangeHandler?(selectedChange)
            case .failure(_):
                // TODO: handle error
                break
            }
            strongSelf.stateChangeHandler?(.showLoader(false))
        }
    }
    
}
