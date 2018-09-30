//
//  ProductListItem.swift
//  Networking
//
//  Created by EGEMEN AYHAN on 7.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import Foundation

public struct Product {
    
    public let sku: String
    public let name: String
    public let color: String
    public let size: String
    public let designerName: String
    public let description: String
    public let price: Double
    public let minPrice: Double
    public let thumbnailURL: URL?
    public let configurableAttributes: [ConfigurableAttribute]
    public let media: [Media]
    
}

// MARK: CodingKeys
private extension Product {
    
    enum CodingKeys: String, CodingKey {
        case sku
        case name
        case color
        case size = "sizeCode"
        case designerName = "designerCategoryName"
        case description
        case price
        case minPrice
        case thumbnail
        case configurableAttributes
        case media
    }
    
}

// MARK: Product: Decodable
extension Product: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Product.CodingKeys.self)
        sku = try container.decode(String.self, forKey: .sku)
        name = try container.decode(String.self, forKey: .name)
        color = try container.decode(String.self, forKey: .color)
        size = try container.decode(String.self, forKey: .size)
        designerName = try container.decode(String.self, forKey: .designerName)
        description = try container.decode(String.self, forKey: .description)
        price = try container.decode(Double.self, forKey: .price)
        minPrice = try container.decode(Double.self, forKey: .minPrice)
        configurableAttributes = try container.decode([ConfigurableAttribute].self, forKey: .configurableAttributes)
        media = try container.decode([Media].self, forKey: .media)
        
        let thumbnailPath = try container.decode(String.self, forKey: .thumbnail)
        thumbnailURL = URL(string: "\(MediaEndpoint.ListEndpoint)\(thumbnailPath)") 
    }
    
}