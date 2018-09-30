//
//  ConfigurableAttributeOption.swift
//  Networking
//
//  Created by EGEMEN AYHAN on 18.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import Foundation

public struct ConfigurableAttributeOption {
    
    public let title: String
    public let isInStock: Bool
    public let productSkus: [String]
    
}

// MARK: CodingKeys
private extension ConfigurableAttributeOption {
    
    enum CodingKeys: String, CodingKey {
        case title = "label"
        case isInStock
        case productSkus = "simpleProductSkus"
    }
    
}

// MARK: Product: Decodable
extension ConfigurableAttributeOption: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ConfigurableAttributeOption.CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        isInStock = try container.decode(Bool.self, forKey: .isInStock)
        productSkus = try container.decode([String].self, forKey: .productSkus)
    }
    
}
