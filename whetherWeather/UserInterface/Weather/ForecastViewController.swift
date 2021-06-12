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
    
    private let viewModel: ForecastViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init(weatherDataSource: WeatherDataSource) {
        self.viewModel = .init(weatherDataSource: weatherDataSource)
        
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
    
    private func setUpNavBar() {
        navigationItem.title = "Forecast"
        navigationItem.backButtonTitle = "Back"
    }
    
    private func setUpLayout() {
        view.coverWithSubview(tableView)
        view.coverWithSubview(loadingView)
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
        
        
    }
}