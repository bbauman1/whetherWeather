//
//  Endpoint.swift
//  TableTest
//
//  Created by Brett Bauman on 5/12/21.
//

import Foundation

struct Endpoint {
    let host: String
    let path: String
    let queryItems: [URLQueryItem]?
    
    func makeUrl() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
