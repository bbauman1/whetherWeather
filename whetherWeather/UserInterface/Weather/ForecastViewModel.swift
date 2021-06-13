//
//  ForecastViewModel.swift
//  whetherWeather
//
//  Created by Brett Bauman on 6/11/21.
//

import Foundation
import Combine
import UIKit

class ForecastViewModel {
    
    @Published var state: State = .loading
    @Published var showLocationPermissionButton: Bool = false
    
    private let weatherDataSource: WeatherDataSource
    private let locationDataSource: LocationDataSource
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        weatherDataSource: WeatherDataSource,
        locationDataSource: LocationDataSource
    ) {
        self.weatherDataSource = weatherDataSource
        self.locationDataSource = locationDataSource
        
        reload()
        setUpObservers()
    }
    
    func reload() {
        state = .loading
        
        locationDataSource.requestLocation()
            .map { ($0.coordinate.latitude, $0.coordinate.longitude )}
            .catch { error -> AnyPublisher<(Double, Double)?, Error> in
                switch error {
                case .permissionsNotGranted, .permissionsDenied:
                    return Just(nil).setFailureType(to: Error.self).eraseToAnyPublisher()
                case .unknown(let unknownError):
                    return Fail(error: unknownError).eraseToAnyPublisher()
                }
            }
            .flatMap { location -> AnyPublisher<State, Never> in
                guard let location = location else {
                    return Just(State.noLocationPermission).eraseToAnyPublisher()
                }
                
                return self.weatherDataSource.weeklyForecast(lat: location.0, long: location.1)
                    .map(State.loaded)
                    .catch { Just(State.failed($0)) }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in} ) { [weak self] state in
                self?.state = state
            }
            .store(in: &cancellables)

    }
    
    func requestLocationPermissions(on viewController: UIViewController) {
        locationDataSource.requestWhenInUseAuthorization()
            .sink { completion in
                guard
                    case let .failure(locationError) = completion,
                    case .permissionsDenied = locationError
                else {
                    return
                }
                
                viewController.present(Self.makePermissionsDeniedAlert(), animated: true)
            } receiveValue: { [weak self] _ in
                self?.reload()
            }
            .store(in: &cancellables)
    }
    
    private func setUpObservers() {
        $state
            .map(Self.makeShouldShowLocationButton)
            .assign(to: &$showLocationPermissionButton)
    }
    
    private static func makeShouldShowLocationButton(from state: State) -> Bool {
        switch state {
        case .noLocationPermission:
            return true
        case .loading, .failed, .loaded:
            return false
        }
    }
    
    private static func makePermissionsDeniedAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "Location permissions are denied",
            message: "Go to the Settings app to modify permissions",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        return alert
    }
}

extension ForecastViewModel {
    enum State {
        case loading
        case loaded(WeeklyForecast)
        case failed(Error)
        case noLocationPermission
    }
}
