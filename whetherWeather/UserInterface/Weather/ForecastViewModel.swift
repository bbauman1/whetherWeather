//
//  ForecastViewModel.swift
//  whetherWeather
//
//  Created by Brett Bauman on 6/11/21.
//

import Foundation
import Combine

class ForecastViewModel {
    
    @Published var state: State = .loading
    
    private let weatherDataSource: WeatherDataSource
    private let locationDataSource: LocationDataSource
    
    init(
        weatherDataSource: WeatherDataSource,
        locationDataSource: LocationDataSource
    ) {
        self.weatherDataSource = weatherDataSource
        self.locationDataSource = locationDataSource
        
        reload()
    }
    
    func reload() {
        state = .loading
        
            
        
        
        
            
        self.weatherDataSource.weeklyForecast(lat: 30, long: 1)
            .map(State.loaded)
            .catch { _ in Just(State.loading) }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)                
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
