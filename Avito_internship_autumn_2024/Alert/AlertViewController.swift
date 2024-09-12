//
//  AlertViewController.swift
//  Avito_internship_autumn_2024
//
//  Created by Никита Абаев on 11.09.2024.
//

import UIKit

class AlertViewController: UIViewController {
    
    // MARK: - Properties
    
    let containerView = AlertCont()
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    let actionButton = UIButton()
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    let padding: CGFloat = 20
    
    // MARK: - Init
    init(alertTitle: String, message: String, buttonTitle: String) {
            super.init(nibName: nil, bundle: nil)
            self.alertTitle = alertTitle
            self.message = message
            self.buttonTitle = buttonTitle
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.Colors.backgroungColor.withAlphaComponent(0.75)
        configureContrainerView()
        configureTitlelabel()
        configureActionButton()
        configureMessageLabel()
        
    }
    
    // MARK: - Actions
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
}

// MARK: - Configuration

extension AlertViewController {
    
    func configureContrainerView() {
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func configureTitlelabel() {
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? R.Strings.errorTitle
        titleLabel.font = R.Fonts.pouf
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configureMessageLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        messageLabel.text = message ?? R.Strings.messageAlert
        messageLabel.font = R.Fonts.dataFont
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }
    
    func configureActionButton() {
        containerView.addSubview(actionButton)
        actionButton.setTitle(buttonTitle ?? R.Strings.OK, for: .normal)
        actionButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.layer.cornerRadius = 8
        actionButton.backgroundColor = R.Colors.buttonColor
        actionButton.setTitleColor(R.Colors.black, for: .normal)
        
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
}
