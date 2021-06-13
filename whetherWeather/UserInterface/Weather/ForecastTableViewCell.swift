//
//  ForecastTableViewCell.swift
//  whetherWeather
//
//  Created by Brett Bauman on 6/11/21.
//

import Combine
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
            imageView.widthAnchor.constraint(equalToConstant: 44),
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
    
    private var imageRequest: AnyCancellable?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageRequest?.cancel()
        imageRequest = nil
        iconImageView.image = nil
    }
    
    func bindForecast(_ forecast: Forecast) {
        let weekDay: String = {
            if Calendar.current.isDateInToday(forecast.date) {
                return "Today"
            } else if Calendar.current.isDateInTomorrow(forecast.date) {
                return "Tomorrow"
            } else {
                return DateFormatter.weekDay.string(from: forecast.date)
            }
        }()
        let monthAndDate = DateFormatter.monthAndDate.string(from: forecast.date)
        
        dateLabel.text = "\(weekDay), \(monthAndDate)"
        temperatureLabel.text = "👆 \(forecast.high)° / 👇 \(forecast.low)°"
        
        imageRequest = ImageLoader.shared.load(forecast.icon)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] image in
                self?.iconImageView.image = image
            })
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
