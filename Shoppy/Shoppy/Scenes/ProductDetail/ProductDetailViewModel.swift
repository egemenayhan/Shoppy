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
    let product: Product
    private(set) var availableProducts: [AvailableProduct] = []
    private(set) var selectedAvailableProduct: AvailableProduct!
    
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
    let state: ProductDetailState!
    
    // MARK: - Lifecycle
    init(product: Product) {
        state = ProductDetailState(product: product)
    }
    
}
