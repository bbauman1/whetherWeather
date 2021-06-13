//
//  ApiClient.swift
//  TableTest
//
//  Created by Brett Bauman on 5/12/21.
//

import Foundation
import Combine

enum ApiClientError: Swift.Error {
    case invalidUrl
    case invalidData
    case decoding
    case network(Swift.Error)
    case unknown
}


class ApiClient {
    
    static let shared = ApiClient()
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    func performDataTask<T: Decodable>(for endpoint: Endpoint, type: T.Type = T.self) -> AnyPublisher<T, Error> {
        guard let url = endpoint.makeUrl() else {
            return Fail(error: ApiClientError.invalidUrl).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: type, decoder: decoder)
            .eraseToAnyPublisher()
    }    
}
