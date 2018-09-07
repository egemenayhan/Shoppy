//
//  NisnassEndpoint.swift
//  Networking
//
//  Created by EGEMEN AYHAN on 7.09.2018.
//  Copyright © 2018 NSIstanbul. All rights reserved.
//

import Foundation

public protocol NisnassEndpoint: Endpoint {}

extension NisnassEndpoint {
    
    public var api: API {
        return API(baseURL: BaseURL(scheme: "https", host: "www.nisnass.ae"))
    }
    
}
