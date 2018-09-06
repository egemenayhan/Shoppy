//
//  API.swift
//  Networking
//
//  Created by EGEMEN AYHAN on 6.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import Foundation

/// Represents an environment to connect to
public struct API {
    
    /// Root URL to the environment
    public var baseURL: BaseURL
    
    /// Default header values to be included in every request for this environment
    public var headers: [String: String]
    
    /// Init
    init(baseURL: BaseURL, headers: [String: String] = [:]) {
        self.baseURL = baseURL
        self.headers = headers
    }
    
}
