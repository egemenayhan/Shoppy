//
//  ProductListItem.swift
//  Networking
//
//  Created by EGEMEN AYHAN on 7.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import Foundation

public struct Product {
    
    public let name: String
    public let designerName: String
    public let description: String
    public let price: Double
    public let minPrice: Double
    public let thumbnailURL: URL?
    public let configurableAttributes: [ConfigurableAttribute]
    
}

// MARK: CodingKeys
private extension Product {
    
    enum CodingKeys: String, CodingKey {
        case name
        case designerName = "designerCategoryName"
        case description
        case price
        case minPrice
        case thumbnail
        case configurableAttributes
    }
    
}

// MARK: Product: Decodable
extension Product: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Product.CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        designerName = try container.decode(String.self, forKey: .designerName)
        description = try container.decode(String.self, forKey: .description)
        price = try container.decode(Double.self, forKey: .price)
        minPrice = try container.decode(Double.self, forKey: .minPrice)
        configurableAttributes = try container.decode([ConfigurableAttribute].self, forKey: .configurableAttributes)
        
        let thumbnailPath = try container.decode(String.self, forKey: .thumbnail)
        thumbnailURL = URL(string: "\(MediaEndpoint.ListEndpoint)\(thumbnailPath)") 
    }
    
}
