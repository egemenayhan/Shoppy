//
//  ProductListResponse.swift
//  Networking
//
//  Created by EGEMEN AYHAN on 7.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import Foundation

public struct ProductListPage {
    
    public let pageNumber: Int
    public let products: [Product]
    
}

// MARK: CodingKeys
private extension ProductListPage {
    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "page"
        case products = "hits"
    }
    
}

// MARK: ProductListPage: Decodable
extension ProductListPage: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ProductListPage.CodingKeys.self)
        pageNumber = try container.decode(Int.self, forKey: .pageNumber)
        products = try container.decode([Product].self, forKey: .products)
    }
    
}

