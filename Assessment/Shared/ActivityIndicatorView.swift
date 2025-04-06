//
//  ActivityIndicatorView.swift
//  Assessment
//
//  Created by Asad Mehmood on 06/04/2025.
//

import UIKit

class ActivityIndicatorView: UIActivityIndicatorView {
    
    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        color = .gray
        backgroundColor = .darkGray
        layer.cornerRadius = 5.0
        hidesWhenStopped = true
    }
}
