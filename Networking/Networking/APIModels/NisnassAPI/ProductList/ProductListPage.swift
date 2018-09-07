//
//  ProductListResponse.swift
//  Networking
//
//  Created by EGEMEN AYHAN on 7.09.2018.
//  Copyright © 2018 NSIstanbul. All rights reserved.
//

import Foundation

public struct ProductListPage {
    
    public let page: Int
    public let products: [Product]
    
}

// MARK: CodingKeys
private extension ProductListPage {
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case products = "hits"
    }
    
}

// MARK: ProductListPage: Decodable
extension ProductListPage: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ProductListPage.CodingKeys.self)
        page = try container.decode(Int.self, forKey: .page)
        products = try container.decode([Product].self, forKey: .products)
    }
    
}

