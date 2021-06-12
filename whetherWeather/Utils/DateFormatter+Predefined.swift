//
//  DateFormatter+Predefined.swift
//  whetherWeather
//
//  Created by Brett Bauman on 6/11/21.
//

import Foundation

extension DateFormatter {
    
    static let weekDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    static let monthAndDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        return formatter
    }()
}
