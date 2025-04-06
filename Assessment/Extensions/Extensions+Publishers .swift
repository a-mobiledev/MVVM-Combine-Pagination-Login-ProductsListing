//
//  Extensions+Publishers .swift
//  Assessment
//
//  Created by Asad Mehmood on 06/04/2025.
//

import Foundation
import UIKit
import Combine

extension UITextField {
    var textChangePublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField) }
            .compactMap(\.text)
            .eraseToAnyPublisher()
    }
}
