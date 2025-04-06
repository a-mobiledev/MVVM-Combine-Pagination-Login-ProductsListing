//
//  ViewController.swift
//  Assessment
//
//  Created by Asad Mehmood on 03/04/2025.
//

import UIKit
import Combine
import Alamofire


class LoginViewController: UIViewController {

    // MARK: - Properties
    
    private let loginViewModel: LoginViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    private let FYILabel: UILabel = {
        let label = UILabel()
        label.text = "FYI: Sorry! I am using additional USERNAME field, because I could not find any email/password supporting API, that also gives session timeout support, if you know any, please let me know. I will update my code in few moments."
        label.textAlignment = .center
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 3
        return label
    }()
    
    private let usernameTextField: UITextField = {
            let textField = UITextField()
        textField.placeholder = AppConstant.usernamePlaceholder
            textField.borderStyle = .roundedRect
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.returnKeyType = .next
            textField.clearButtonMode = .whileEditing
            textField.translatesAutoresizingMaskIntoConstraints = false
            return textField
        }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = AppConstant.emailPlaceholder
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = AppConstant.passwordPlaceholder
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.clearButtonMode = .whileEditing
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.textContentType = .password
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(AppConstant.login, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let loginStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.distribution = .fillEqually
        return sv
    }()
    
    lazy var activityIndicator = ActivityIndicatorView(style: .large)
    
    private let waitingLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstant.pleaseWait
        label.textAlignment = .center
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    
    // MARK: - Methods
        
    init(loginViewModel: LoginViewModel = LoginViewModel()) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil) //  WHY CALL THIS ?
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        UpdateUIAsPerAuthStatus()
        setupTargets()
        setupBindings()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(loginStackView)
        view.addSubview(waitingLabel)
        view.addSubview(activityIndicator)
        
        loginStackView.addArrangedSubview(FYILabel)
        loginStackView.addArrangedSubview(usernameTextField)
        loginStackView.addArrangedSubview(emailTextField)
        loginStackView.addArrangedSubview(passwordTextField)
        loginStackView.addArrangedSubview(loginButton)
        
        loginStackView.translatesAutoresizingMaskIntoConstraints = false
        waitingLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            waitingLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            waitingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            waitingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func UpdateUIAsPerAuthStatus() {
        if let token = UserDefaultsManager.get(key: AppConstant.accessToken) {
            showAuthenticatingUI()
            loginViewModel.handleAuthentication(token: token)
        } else {
            showLoginUI()
        }
    }
    
    private func showLoginUI() {
        waitingLabel.isHidden = true
        loginStackView.isHidden = false
    }
    
    private func showAuthenticatingUI() {
        waitingLabel.isHidden = false
        loginStackView.isHidden = true
    }
    
    private func setupTargets() {
        loginButton.addTarget(self, action: #selector(onLoginClick), for: .touchUpInside)
    }
    
    private func setupBindings() {
        func bindViewToModel() {
            self.usernameTextField.textChangePublisher
                .receive(on: RunLoop.main)
                .assign(to: \.username, on: loginViewModel)
                .store(in: &subscriptions)
            
            self.emailTextField.textChangePublisher
                .receive(on: RunLoop.main)
                .assign(to: \.email, on: loginViewModel)
                .store(in: &subscriptions)
            
            self.passwordTextField.textChangePublisher
                .receive(on: RunLoop.main)
                .assign(to: \.password, on: loginViewModel)
                .store(in: &subscriptions)
            
        }
        
        func bindModelToView() {
            loginViewModel.$isLoading
                .assign(to: \.isLoading, on: self)
                .store(in: &subscriptions)
            
            loginViewModel.$errorMessage
                .assign(to: \.errorMessage, on: self)
                .store(in: &subscriptions)
            
            loginViewModel.authenticationResult
                .sink { [weak self] completion in
                    if case .failure(_) = completion {
                        DispatchQueue.main.async {
                            self?.showLoginUI()
                        }
                    }
                } receiveValue: { [weak self] _ in
                    DispatchQueue.main.async {
                        self?.navigateToHome()
                    }
                }
                .store(in: &subscriptions)
            loginViewModel.loginResult
                .sink { _ in
                    return
                } receiveValue: { [weak self] _ in
                    DispatchQueue.main.async {
                        self?.navigateToHome()
                    }
                }
                .store(in: &subscriptions)
        }
        
        bindViewToModel()
        bindModelToView()
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
    
    
    
    @objc private func onLoginClick() {
        loginViewModel.handleLogin()
    }
    
    private func navigateToHome() {
        let homeViewController = ProductsHomeViewController()
        navigationController?.setViewControllers([homeViewController], animated: true)
    }
}

