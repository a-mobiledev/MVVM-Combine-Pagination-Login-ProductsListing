//
//  HomeViewController.swift
//  Assessment
//
//  Created by Asad Mehmood on 05/04/2025.
//

import UIKit
import Combine

class ProductsHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let productsViewModel: ProductsViewModel
    private var subscriptions = Set<AnyCancellable>()
    private let tableView = UITableView()
    
    lazy var activityIndicator = ActivityIndicatorView(style: .large)
    
    var isLoading: Bool = false {
        didSet {
            isLoading ? startLoading() : finishLoading()
        }
    }
    
    var errorMessage: String? {
        didSet {
            if let error = errorMessage {
                showAlert(title: AppConstant.error, message: error)
            }
        }
    }
    
    init(productsViewModel: ProductsViewModel = ProductsViewModel()) {
        self.productsViewModel = productsViewModel
        super.init(nibName: nil, bundle: nil) 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
        productsViewModel.fetchProducts()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = AppConstant.products
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductCategoryTableCell.self, forCellReuseIdentifier: ProductCategoryTableCell.identifier)
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    private func setupBindings() {
        productsViewModel.$isLoading
            .assign(to: \.isLoading, on: self)
            .store(in: &subscriptions)
        
        productsViewModel.$errorMessage
            .assign(to: \.errorMessage, on: self)
            .store(in: &subscriptions)
        
        productsViewModel.productsResult
            .sink { _ in
                return
            } receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)
    }
    
    private func startLoading() {
        self.view.isUserInteractionEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func finishLoading() {
        self.view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return productsViewModel.categories.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "  \(productsViewModel.categories[section].name)".capitalized
        label.backgroundColor = .clear
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCategoryTableCell.identifier, for: indexPath) as? ProductCategoryTableCell else {
            return UITableViewCell()
        }
        cell.configure(with: productsViewModel.categories[indexPath.section].products)
        cell.itemTapped
            .sink { [weak self] in
                let photoVC = PhotosViewController()
                self?.navigationController?.pushViewController(photoVC, animated: true)
            }
            .store(in: &subscriptions)
        return cell
    }
}
