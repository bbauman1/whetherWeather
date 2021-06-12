//
//  ViewController.swift
//  whetherWeather
//
//  Created by Brett Bauman on 6/11/21.
//

import UIKit

class RootCoordinator: UINavigationController {

    private let weatherDataSource = WeatherDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("did laod")
        let _ = weatherDataSource
            .forecast(lat: 35, long: 139)
            .sink(receiveCompletion: { _ in }) { response in
                print("got response: \(response)")
            }

    }


}

