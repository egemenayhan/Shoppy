//
//  ProductListRequest.swift
//  Networking
//
//  Created by EGEMEN AYHAN on 7.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import Foundation

public struct ProductListRequest: NisnassEndpoint {
    
    public typealias Response = ProductListPage
    public var path = "/api/women/clothing"
    public var method: HTTPMethod = .get
    public var parameters: [String : Any]
    
    public init(page: Int?) {
        parameters = ["page": page ?? 0]
    }
    
}
