//
//  SingleDayForecastViewController.swift
//  whetherWeather
//
//  Created by Brett Bauman on 6/11/21.
//

import Foundation
import UIKit

class SingleDayForecastViewController: UIViewController {
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    
    private let forecast: Forecast
    
    init(forecast: Forecast) {
        self.forecast = forecast
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpLayout()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        
        descriptionLabel.text = forecast.description
    }
    
    private func setUpLayout() {
        let stackView = UIStackView(arrangedSubviews: [UIView(), descriptionLabel, UIView()])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.directionalLayoutMargins = .init(top: 24, leading: 24, bottom: 24, trailing: 24)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        view.coverWithSubview(stackView)
    }
}
