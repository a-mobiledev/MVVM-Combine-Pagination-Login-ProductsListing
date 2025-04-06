//
//  LoginViewModel.swift
//  Assessment
//
//  Created by Asad Mehmood on 06/04/2025.
//

import Foundation
import Alamofire
import Combine

final class LoginViewModel {
    
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published private(set) var authResponse: AuthResponse?
    @Published private(set) var user: User?
    let loginResult = PassthroughSubject<Void, Error>()
    let authenticationResult = PassthroughSubject<Void, Error>()
    private var subscriptions = Set<AnyCancellable>()
    
    func handleLogin() {
        
        guard let username = getValidUsername(), let _ = getValidEmail(), let password = getValidPassword() else {
            return
        }
        login(username: username, password: password)
    }
    
    func handleAuthentication(token: String) {
        isLoading = true
        let url = "https://dummyjson.com/auth/me"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        APIClient.shared
            .request(url, method: .get, headers: headers)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    print(error)
                    self?.authenticationResult.send(completion: .failure(error))
                }
            }, receiveValue: {[weak self] response in
                self?.user = response
                print("\(String(describing: self?.user))")
                self?.authenticationResult.send(())
            })
            .store(in: &subscriptions)
    }
    
    private func login(username: String, password: String) {
        isLoading = true
        let url = "https://dummyjson.com/auth/login"
        let params = [
            "username": username,
            "password": password,
            "expiresInMins": "1"
        ]
        
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        APIClient.shared
            .request(url, method: .post, parameters: params, headers: headers)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = "\(error)"
                    self?.loginResult.send(completion: .failure(error))
                }
            }, receiveValue: { [weak self] response in
                self?.authResponse = response
                UserDefaultsManager.save(value: self?.authResponse?.accessToken, key: AppConstant.accessToken)
                self?.loginResult.send(())
            })
            .store(in: &subscriptions)
    }
    
    private func getValidUsername() -> String? {
        guard username.isEmpty != true else {
            errorMessage = AppConstant.enterUsername
            return nil
        }
        return username
    }
    
    private func getValidEmail() -> String? {
        guard email.isEmpty != true else {
            errorMessage = AppConstant.enterEmail
            return nil
        }
        guard email.isValidEmail == true else {
            errorMessage = AppConstant.enterValidEmail
            return nil
        }
        return email
    }
    
    private func getValidPassword() -> String? {
        guard password.isEmpty != true else {
            errorMessage = AppConstant.enterPassword
            return nil
        }
        guard password.count >= 8 else {
            errorMessage = AppConstant.passwordValidation
            return nil
        }
        return password
    }
}
