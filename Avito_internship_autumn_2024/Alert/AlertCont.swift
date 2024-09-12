//
//  AlertCont.swift
//  Avito_internship_autumn_2024
//
//  Created by Никита Абаев on 11.09.2024.
//

import UIKit

class AlertCont: UIView {
    
    // MARK: - Constants
    
    private let cornerRadius: CGFloat = 16
    private let borderWidth: CGFloat = 2
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    private func configure() {
        backgroundColor = R.Colors.backgroungColor
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = R.Colors.backgroungColor.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
