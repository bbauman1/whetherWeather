//
//  LocationDataSource.swift
//  whetherWeather
//
//  Created by Brett Bauman on 6/12/21.
//

import Foundation
import Combine
import CoreLocation

/// Based on https://medium.com/livefront/a-core-location-abstraction-layer-with-combine-and-swiftui-5689ef427e98
class LocationDataSource: NSObject {
    
    private let locationManager = CLLocationManager()
    
    private var authorizationRequests: [(Result<Void, LocationError>) -> Void] = []
    private var locationRequests: [(Result<CLLocation, LocationError>) -> Void] = []
    
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    func requestWhenInUseAuthorization() -> Future<Void, LocationError> {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return Future { $0(.success(())) }
        case .denied, .restricted:
            return Future { $0(.failure(.permissionsDenied)) }
        case .notDetermined:
            break
        @unknown default:
            fatalError()
        }
        
        let future = Future<Void, LocationError> { completion in
            self.authorizationRequests.append(completion)
        }
        
        locationManager.requestWhenInUseAuthorization()
        
        return future
    }
    
    func requestLocation() -> Future<CLLocation, LocationError> {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            break
        case .denied, .notDetermined, .restricted:
            return Future { $0(.failure(.permissionsNotGranted))}
        @unknown default:
            fatalError()
        }
        
        let future = Future<CLLocation, LocationError> { completion in
            self.locationRequests.append(completion)
        }
        
        locationManager.requestLocation()
        
        return future
    }
    
    private func handleLocationRequestResult(_ result: Result<CLLocation, LocationError>) {
        while locationRequests.count > 0 {
            let request = locationRequests.removeFirst()
            request(result)
        }
    }
    
}

extension LocationDataSource {
    enum LocationError: Swift.Error {
        case permissionsNotGranted
        case permissionsDenied
        case unknown(Swift.Error)
    }
}

extension LocationDataSource: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            handleLocationRequestResult(.failure(.permissionsNotGranted))
            return
        }
        
        handleLocationRequestResult(.success(location))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        handleLocationRequestResult(.failure(.unknown(error)))
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        while authorizationRequests.count > 0 {
            let request = authorizationRequests.removeFirst()
            request(.success(()))
        }
    }
}
