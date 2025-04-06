//
//  LoginModel.swift
//  Assessment
//
//  Created by Asad Mehmood on 06/04/2025.
//

import Foundation

struct AuthResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let email: String
    let firstName: String
    let lastName: String
    let gender: String
    let id: Int
    let image: String
    let username: String
}


struct User: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let maidenName: String
    let age: Int
    let gender: String
    let email: String
    let phone: String
    let username: String
    let password: String
    let birthDate: String
    let image: String
    let bloodGroup: String
    let height: Double
    let weight: Double
    let eyeColor: String
    let ein: String
    let ssn: String
    let userAgent: String
    let macAddress: String
    let ip: String
    let role: String
    let university: String
}
