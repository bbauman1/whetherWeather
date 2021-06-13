//
//  WeatherDataSource.swift
//  whetherWeather
//
//  Created by Brett Bauman on 6/11/21.
//

import Foundation
import Combine

class WeatherDataSource {
    
    func weeklyForecast(lat: Double, long: Double) -> AnyPublisher<WeeklyForecast, Error> {
        ApiClient.shared
            .performDataTask(
                for: .openWeatherOneCall(lat: lat, long: long),
                type: OpenWeatherOneCallResponse.self)
            .map(WeeklyForecast.init)
            .eraseToAnyPublisher()
    }
}
