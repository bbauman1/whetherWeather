//
//  OpenWeatherOneCallResponse.swift
//  whetherWeather
//
//  Created by Brett Bauman on 6/11/21.
//

import Foundation

struct OpenWeatherOneCallResponse: Decodable {
    let daily: [Daily]
}

extension OpenWeatherOneCallResponse {
    struct Daily: Decodable {
        let dt: Double
        let temp: Temp
        let weather: [Weather]
    }
}

extension OpenWeatherOneCallResponse.Daily {
    struct Temp: Decodable {
        let min: Double
        let max: Double
    }
}

extension OpenWeatherOneCallResponse.Daily {
    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
}
