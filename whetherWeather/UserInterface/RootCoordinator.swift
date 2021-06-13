//
//  ViewController.swift
//  whetherWeather
//
//  Created by Brett Bauman on 6/11/21.
//

import UIKit

class RootCoordinator: UINavigationController {

    private let weatherDataSource = WeatherDataSource()
    private let locationDataSource = LocationDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRootViewControllers()
    }

    private func setRootViewControllers() {
        let forecastViewController = ForecastViewController(
            weatherDataSource: weatherDataSource,
            locationDataSource: locationDataSource)
        forecastViewController.delegate = self
        
        setViewControllers([forecastViewController], animated: true)
    }
}

extension RootCoordinator: ForecastViewControllerDelegate {
    func forecastViewController(
        _ forecastViewController: ForecastViewController,
        didSelect forecast: Forecast
    ) {
        pushViewController(SingleDayForecastViewController(forecast: forecast), animated: true)
    }
}

