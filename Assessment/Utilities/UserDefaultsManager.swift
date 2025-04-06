//
//  UserDefaultsManager.swift
//  Assessment
//
//  Created by Asad Mehmood on 06/04/2025.
//

import Foundation

class UserDefaultsManager {
    static func save(value: String?, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    static func get(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
}
