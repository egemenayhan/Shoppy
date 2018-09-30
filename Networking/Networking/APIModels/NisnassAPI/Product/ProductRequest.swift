//
//  ProductRequest.swift
//  Networking
//
//  Created by EGEMEN AYHAN on 30.09.2018.
//  Copyright © 2018 NSIstanbul. All rights reserved.
//

import Foundation

import Foundation

public struct ProductRequest: NisnassEndpoint {
    
    public typealias Response = Product
    public var path = "/product/findbyslug"
    public var method: HTTPMethod = .get
    public var parameters: [String : Any]
    
    public init(sku: String) {
        parameters = ["slug": sku]
    }
    
}
