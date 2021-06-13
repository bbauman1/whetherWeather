//
//  ForecastViewController.swift
//  whetherWeather
//
//  Created by Brett Bauman on 6/11/21.
//

import Foundation
import UIKit
import Combine

protocol ForecastViewControllerDelegate: AnyObject {
    func forecastViewController(
        _ forecastViewController: ForecastViewController,
        didSelect forecast: Forecast
    )
}

class ForecastViewController: UIViewController {
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Forecast>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Forecast>
    
    weak var delegate: ForecastViewControllerDelegate?
    
    private lazy var dataSource = makeDataSource()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
        tableView.backgroundView = locationPermissionsPromptView
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: activityIndicator.centerYAnchor)
        ])
        
        return view
    }()
    
    private lazy var locationPermissionsPromptView: UIView = {
        let promptLabel = UILabel()
        promptLabel.text = "Tap the button in the top right corner to grant location permissions"
        promptLabel.font = .preferredFont(forTextStyle: .body)
        promptLabel.numberOfLines = 0
        promptLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [UIView(), promptLabel, UIView()])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.directionalLayoutMargins = .init(top: 24, leading: 24, bottom: 24, trailing: 24)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let viewModel: ForecastViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        weatherDataSource: WeatherDataSource,
        locationDataSource: LocationDataSource
    ) {
        self.viewModel = .init(weatherDataSource: weatherDataSource, locationDataSource: locationDataSource)
        
        super.init(nibName: nil, bundle: nil)
        
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        setUpLayout()
        observeViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.indexPathsForSelectedRows?.forEach { tableView.deselectRow(at: $0, animated: false) }
    }
    
    private func observeViewModel() {
        viewModel.$state
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
        
        viewModel.$showLocationPermissionButton
            .sink { [weak self] showButton in
                self?.showLocationButton(showButton)
            }
            .store(in: &cancellables)
    }

    private func render(_ state: ForecastViewModel.State) {
        switch state {
        case .loading:
            showLoading(true)
        case .loaded(let retailLocations):
            updateList(with: retailLocations)
            showLoading(false)
        case .failed(let error):
            showAlert(for: error)
        case .noLocationPermission:
            updateList(with: [])
            showLoading(false)
        }
    }
    
    private func updateList(with forecast: WeeklyForecast) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(forecast, toSection: .forecast)
        dataSource.apply(snapshot)
    }
    
    private func showLoading(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.loadingView.alpha = show ? 1 : 0
        } completion: { _ in
            self.loadingView.isHidden = show ? false : true
        }
    }
    
    private func showAlert(for error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(.init(title: "Retry", style: .default, handler: { _ in
            self.viewModel.reload()
        }))
        present(alert, animated: true)
    }
    
    private func showLocationButton(_ show: Bool) {
        if show {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "location"),
                style: .plain,
                target: self,
                action: #selector(locationPermissionsButtonTapped))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func setUpNavBar() {
        navigationItem.title = "7 Day Forecast"
        navigationItem.backButtonTitle = "Back"
    }
    
    private func setUpLayout() {
        view.coverWithSubview(tableView)
        view.coverWithSubview(loadingView)
    }
    
    @objc private func locationPermissionsButtonTapped() {
        viewModel.requestLocationPermissions(on: self)
    }
}

extension ForecastViewController {
    
    enum Section: Int, CaseIterable {
        case forecast
    }
    
    private func makeDataSource() -> DataSource {
        .init(tableView: tableView) { tableView, indexPath, forecast in
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: ForecastTableViewCell.reuseIdentifier) as? ForecastTableViewCell
            else {
                return UITableViewCell()
            }
            
            cell.bindForecast(forecast)
            return cell
        }
    }
}

extension ForecastViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let forecast = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        delegate?.forecastViewController(self, didSelect: forecast)
    }
}
