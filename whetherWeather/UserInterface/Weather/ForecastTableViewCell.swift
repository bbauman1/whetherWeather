//
//  ForecastTableViewCell.swift
//  whetherWeather
//
//  Created by Brett Bauman on 6/11/21.
//

import Foundation
import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.cornerCurve = .continuous
        imageView.image = UIImage(systemName: "sun.min")
        imageView.tintColor = .black
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private var imageRequestToken: RequestToken?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        UIImageLoader.shared.cancel(requestToken: imageRequestToken)
    }
    
    func bindForecast(_ forecast: Forecast) {
        let weekDay = DateFormatter.weekDay.string(from: forecast.date)
        let monthAndDate = DateFormatter.monthAndDate.string(from: forecast.date)
        dateLabel.text = "\(weekDay)), \(monthAndDate)"
        temperatureLabel.text = "👆 \(forecast.high)° / 👇 \(forecast.low)°"
        
        imageRequestToken = UIImageLoader.shared.load(forecast.icon, into: iconImageView)
    }
    
    private func setUpLayout() {
        let labelStackView = UIStackView(arrangedSubviews: [dateLabel, temperatureLabel])
        labelStackView.axis = .vertical
        labelStackView.spacing = 4
        labelStackView.isLayoutMarginsRelativeArrangement = true
        labelStackView.directionalLayoutMargins = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let stackView = UIStackView(arrangedSubviews: [iconImageView, labelStackView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        contentView.coverWithSubview(stackView)
    }
}
