//
//  WeatherDataSource.swift
//  whetherWeather
//
//  Created by Brett Bauman on 6/11/21.
//

import Foundation
import Combine

let mockResponse = """
    {"lat":35,"lon":139,"timezone":"Asia/Tokyo","timezone_offset":32400,"current":{"dt":1623465740,"sunrise":1623439776,"sunset":1623491890,"temp":299.03,"feels_like":298.64,"pressure":1018,"humidity":37,"dew_point":283.24,"uvi":9.51,"clouds":100,"visibility":10000,"wind_speed":3.15,"wind_deg":301,"wind_gust":3.52,"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}]},"daily":[{"dt":1623463200,"sunrise":1623439776,"sunset":1623491890,"moonrise":1623443640,"moonset":1623498000,"moon_phase":0.05,"temp":{"day":298.76,"min":289.54,"max":299.03,"night":291.2,"eve":296.22,"morn":289.61},"feels_like":{"day":298.45,"night":291.46,"eve":296.23,"morn":289.77},"pressure":1018,"humidity":41,"dew_point":284.54,"wind_speed":3.69,"wind_deg":294,"wind_gust":5.1,"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"clouds":100,"pop":0,"uvi":9.51},{"dt":1623549600,"sunrise":1623526175,"sunset":1623578315,"moonrise":1623533220,"moonset":1623587340,"moon_phase":0.08,"temp":{"day":297.58,"min":290.52,"max":298.39,"night":292.5,"eve":296.4,"morn":290.82},"feels_like":{"day":297.67,"night":292.79,"eve":296.58,"morn":291.07},"pressure":1013,"humidity":61,"dew_point":289.02,"wind_speed":3.53,"wind_deg":301,"wind_gust":4.9,"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"clouds":100,"pop":0.28,"uvi":7.65},{"dt":1623636000,"sunrise":1623612575,"sunset":1623664738,"moonrise":1623623100,"moonset":1623676260,"moon_phase":0.12,"temp":{"day":292.54,"min":289.54,"max":294.42,"night":289.54,"eve":293.74,"morn":292.04},"feels_like":{"day":292.86,"night":289.64,"eve":293.76,"morn":292.31},"pressure":1009,"humidity":89,"dew_point":290.28,"wind_speed":2.03,"wind_deg":113,"wind_gust":2.42,"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"}],"clouds":100,"pop":0.72,"rain":4.28,"uvi":5.03},{"dt":1623722400,"sunrise":1623698977,"sunset":1623751160,"moonrise":1623713100,"moonset":1623764940,"moon_phase":0.15,"temp":{"day":296.27,"min":289.02,"max":296.27,"night":291.29,"eve":293.34,"morn":291.25},"feels_like":{"day":296.23,"night":291.54,"eve":293.56,"morn":291.36},"pressure":1008,"humidity":61,"dew_point":287.88,"wind_speed":2.29,"wind_deg":78,"wind_gust":3,"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"clouds":92,"pop":0.08,"uvi":8.68},{"dt":1623808800,"sunrise":1623785381,"sunset":1623837581,"moonrise":1623803340,"moonset":1623853440,"moon_phase":0.18,"temp":{"day":295.97,"min":290.35,"max":296.82,"night":291.81,"eve":293.62,"morn":291.68},"feels_like":{"day":295.93,"night":291.9,"eve":293.65,"morn":291.91},"pressure":1008,"humidity":62,"dew_point":287.89,"wind_speed":5.79,"wind_deg":76,"wind_gust":8.61,"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"clouds":100,"pop":0.24,"uvi":8.4},{"dt":1623895200,"sunrise":1623871786,"sunset":1623924000,"moonrise":1623893520,"moonset":1623941700,"moon_phase":0.21,"temp":{"day":297.21,"min":289.87,"max":297.21,"night":291.58,"eve":294.13,"morn":291.5},"feels_like":{"day":297.34,"night":291.91,"eve":294.4,"morn":291.58},"pressure":1006,"humidity":64,"dew_point":289.58,"wind_speed":3.81,"wind_deg":279,"wind_gust":6.4,"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"clouds":96,"pop":0.16,"uvi":9},{"dt":1623981600,"sunrise":1623958192,"sunset":1624010418,"moonrise":1623983760,"moonset":0,"moon_phase":0.25,"temp":{"day":299.53,"min":290.94,"max":299.53,"night":293.61,"eve":295.06,"morn":292.9},"feels_like":{"day":299.53,"night":293.93,"eve":295.42,"morn":293.33},"pressure":1003,"humidity":55,"dew_point":289.38,"wind_speed":5.47,"wind_deg":240,"wind_gust":11.42,"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"}],"clouds":93,"pop":0.32,"rain":0.13,"uvi":9},{"dt":1624068000,"sunrise":1624044601,"sunset":1624096834,"moonrise":1624074060,"moonset":1624029840,"moon_phase":0.28,"temp":{"day":293.84,"min":292.66,"max":295.9,"night":293.43,"eve":292.66,"morn":293.78},"feels_like":{"day":294.39,"night":294.1,"eve":293.23,"morn":294.09},"pressure":998,"humidity":93,"dew_point":292.18,"wind_speed":6.57,"wind_deg":241,"wind_gust":12.32,"weather":[{"id":501,"main":"Rain","description":"moderate rain","icon":"10d"}],"clouds":100,"pop":0.92,"rain":13,"uvi":9}]}
    """

class WeatherDataSource {
    
    func weeklyForecast(lat: Double, long: Double) -> AnyPublisher<WeeklyForecast, Error> {
        let data = mockResponse.data(using: .utf8)!
        let response = try! JSONDecoder().decode(OpenWeatherOneCallResponse.self, from: data)
        return Just(response).map(WeeklyForecast.init).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}