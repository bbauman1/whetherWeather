//
//  LocationDataSource.swift
//  whetherWeather
//
//  Created by Brett Bauman on 6/12/21.
//

import Foundation
import Combine

class LocationDataSource {
    
    var location: Future<(Double, Double), Error> {
        .init { promise in
            promise(.success((35, 150)))
        }
    }
}

extension LocationDataSource {
    enum Error: Swift.Error {
        case permissionsNotGranted
    }
}
