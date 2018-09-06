//
//  Response.swift
//  Networking
//
//  Created by EGEMEN AYHAN on 6.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import Foundation

/// Holds all response related information
public struct Response<Value> {
    
    /// The request object that this response belongs to
    public let request: URLRequest?
    
    /// HTTP response data for the request
    public let response: HTTPURLResponse?
    
    /// Raw response data for the request
    public let data: Data?
    
    /// Parsed response value for the given type
    public let result: Result<Value>
    
}
