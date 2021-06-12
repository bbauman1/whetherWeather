//
//  Endpoint+OpenWeather.swift
//  whetherWeather
//
//  Created by Brett Bauman on 6/11/21.
//

import Foundation

extension Endpoint {
    private static let appId = "6da46359a398adeca2c1c6436f968e2e"
    
    static func openWeatherOneCall(lat: Double, long: Double) -> Endpoint {
        Endpoint(
            host: "api.openweathermap.org",
            path: "/data/2.5/onecall",
            queryItems: [
                .init(name: "lat", value: String(lat)),
                .init(name: "lon", value: String(long)),
                .init(name: "exclude", value: "minutely,hourly,alerts"),
                .init(name: "appid", value: Self.appId),
            ])
    }
}
