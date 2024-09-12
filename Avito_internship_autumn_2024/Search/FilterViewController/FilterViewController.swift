//
//  FilterViewController.swift
//  Avito_internship_autumn_2024
//
//  Created by Никита Абаев on 11.09.2024.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didSelectSortOption(_ option: SortOption)
}

enum SortOption {
    case newest
    case popular
}

class FilterViewController: UIViewController {
    
    weak var delegate: FilterViewControllerDelegate?
    private var selectedOption: SortOption?
    
    private lazy var newestButton: UIButton = {
        let button = createFilterButton(title: R.Strings.newsButton)
        button.addTarget(self, action: #selector(selectNewest), for: .touchUpInside)
        return button
    }()
    
    private lazy var popularButton: UIButton = {
        let button = createFilterButton(title: R.Strings.popularButton)
        button.addTarget(self, action: #selector(selectPopular), for: .touchUpInside)
        return button
    }()
    
    private lazy var okButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(R.Strings.OK, for: .normal)
        button.backgroundColor = R.Colors.filterButton
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(applyFilter), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let backArrowImage = R.Image.chevronLeft
        button.setImage(backArrowImage, for: .normal)
        button.tintColor = R.Colors.black
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var filterButtonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [newestButton, popularButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.Colors.backgroungColor
        setupViews()
        setupBackButton()
    }
    
    
    // MARK: - Setup UI
    
    private func setupViews() {
        view.addSubview(filterButtonsStack)
        view.addSubview(okButton)
        
        NSLayoutConstraint.activate([
            filterButtonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButtonsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            filterButtonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            filterButtonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            okButton.topAnchor.constraint(equalTo: filterButtonsStack.bottomAnchor, constant: 32),
            okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            okButton.widthAnchor.constraint(equalToConstant: 100),
            okButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupBackButton() {
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
    
    // MARK: - Button Actions
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func selectNewest() {
        selectedOption = .newest
        updateButtons()
    }
    
    @objc private func selectPopular() {
        selectedOption = .popular
        updateButtons()
    }
    
    @objc private func applyFilter() {
        if let selectedOption = selectedOption {
            delegate?.didSelectSortOption(selectedOption)
        }
        dismiss(animated: true)
    }
    
    // MARK: - Update Button States
    
    private func updateButtons() {
            newestButton.isSelected = selectedOption == .newest
            popularButton.isSelected = selectedOption == .popular
            
            updateCheckmarkVisibility(for: newestButton, isVisible: newestButton.isSelected)
            updateCheckmarkVisibility(for: popularButton, isVisible: popularButton.isSelected)
        }
    
    private func updateCheckmarkVisibility(for button: UIButton, isVisible: Bool) {
            button.subviews.compactMap { $0 as? UIImageView }.first?.isHidden = !isVisible
        }
    
    
    // MARK: -  Methods for UI Elements
    
    private func createFilterButton(title: String) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.title = title
        config.baseForegroundColor = .black
        config.background.backgroundColor = R.Colors.filterButton
        config.background.cornerRadius = 8
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 40)

        let button = UIButton(configuration: config)
        
       
        let chevronImageView = UIImageView(image: R.Image.checkmark)
        chevronImageView.tintColor = .black
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(chevronImageView)

        
        NSLayoutConstraint.activate([
            chevronImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        chevronImageView.isHidden = true
        
        return button
    }

}
