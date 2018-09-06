//
//  NetworkingError.swift
//  Networking
//
//  Created by EGEMEN AYHAN on 6.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import Foundation

/// Error type to be used in Networking module
public enum NetworkingError: Error {
    
    /// Indicates that there has been a connection error to the server
    case connectionError(Error)
    
    /// Indicates that parsing is not possible with the current data and
    /// given type to parse into.
    case decodingFailed(DecodingError)
    
    /// In case an error occures which is not identified
    case undefined
    
}
