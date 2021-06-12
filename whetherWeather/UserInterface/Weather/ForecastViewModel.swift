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
    
    init(
        weatherDataSource: WeatherDataSource
    ) {
        self.weatherDataSource = weatherDataSource
        
        reload()
    }
    
    func reload() {
        state = .loading
        
        weatherDataSource
            .weeklyForecast(lat: 35, long: 150)
            .map(State.loaded)
            .catch { Just(State.failed($0)) }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }
}

extension ForecastViewModel {
    enum State {
        case loading
        case loaded(WeeklyForecast)
        case failed(Error)
    }
}
