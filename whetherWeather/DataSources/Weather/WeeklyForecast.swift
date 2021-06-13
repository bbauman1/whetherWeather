//
//  WeeklyForecast.swift
//  whetherWeather
//
//  Created by Brett Bauman on 6/11/21.
//

import Foundation

typealias WeeklyForecast = [Forecast]

extension WeeklyForecast {
    
    init(from response: OpenWeatherOneCallResponse) {
        self = response.daily.compactMap { day in
            guard
                let primaryWeather = day.weather.first,
                let url = URL(string: "https://openweathermap.org/img/wn/\(primaryWeather.icon)@2x.png")
            else {
                return nil
            }
            
            return Forecast(
                date: Date(timeIntervalSince1970: day.dt),
                high: day.temp.max,
                low: day.temp.min,
                description: primaryWeather.description,
                icon: url)
        }
    }
}

