//
//  Media.swift
//  Networking
//
//  Created by EGEMEN AYHAN on 30.09.2018.
//  Copyright © 2018 NSIstanbul. All rights reserved.
//

import Foundation

public struct Media {
    
    public let position: Int
    public let url: URL?
    
}

// MARK: CodingKeys
private extension Media {
    
    enum CodingKeys: String, CodingKey {
        case position
        case path = "src"
    }
    
}

// MARK: Decodable
extension Media: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Media.CodingKeys.self)
        position = try container.decode(Int.self, forKey: .position)
        let path = try container.decode(String.self, forKey: .path)
        url = URL(string: "\(MediaEndpoint.DetailEndpont)\(path)")
    }
    
}
