//
//  ConfigurableAttribute.swift
//  Networking
//
//  Created by EGEMEN AYHAN on 18.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import Foundation

public struct ConfigurableAttribute {
    
    public enum ConfigurableAttributeType: String {
        case size = "sizeCode"
        case color = "color"
        case unknown = ""
    }
    
    // MARK: - Properties
    public let type: ConfigurableAttributeType
    public let options: [ConfigurableAttributeOption]
    public var title: String {
        var title: String
        
        switch type {
        case .size:
            title = "Size"
        case .color:
            title = "Colors"
        case .unknown:
            title = "Unknown"
        }
        
        return title
    }
    
}

// MARK: CodingKeys
private extension ConfigurableAttribute {
    
    enum CodingKeys: String, CodingKey {
        case type = "code"
        case options
    }
    
}

// MARK: Product: Decodable
extension ConfigurableAttribute: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ConfigurableAttribute.CodingKeys.self)
        let code = try container.decode(String.self, forKey: .type)
        type = ConfigurableAttributeType(rawValue: code) ?? .unknown
        options = try container.decode([ConfigurableAttributeOption].self, forKey: .options)
    }
    
}
