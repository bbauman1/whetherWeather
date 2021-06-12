//
//  Forecast.swift
//  whetherWeather
//
//  Created by Brett Bauman on 6/11/21.
//

import Foundation

struct Forecast: Hashable, Equatable {
    let date: Date
    let high: Double
    let low: Double
    let description: String
    let icon: URL
}
