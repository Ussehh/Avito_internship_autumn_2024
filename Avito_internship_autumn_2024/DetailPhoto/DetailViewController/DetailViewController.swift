//
//  DetailViewController.swift
//  Avito_internship_autumn_2024
//
//  Created by Никита Абаев on 11.09.2024.
//

import UIKit

protocol DetailViewControllerProtocol: AnyObject {
    func displayImage(_ image: UIImage?)
    func displayContentDescription(_ description: String?)
    func displayAuthorInfo(name: String?, bio: String?, profileImageUrl: String?)
}

class DetailViewController: UIViewController, DetailViewControllerProtocol {
    
        //MARK: - Private
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let authorNameLabel = UILabel()
    private let authorBioLabel = UILabel()
    private let authorProfileImageView = UIImageView()
    private let descriptionTitleLabel = UILabel()
    private lazy var separatorView = createSeparatorView()
    private lazy var bottomSeparatorView = createSeparatorView()
    
    var presenter: DetailPresenterProtocol!

    init(presenter: DetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCustomBackButton()
        setupNavigationButtons()
        setupSwipeBackGesture()
        presenter.viewDidLoad()
    }

}


// MARK: - UI Setup
extension DetailViewController {
    
    private func setupView() {
        view.backgroundColor = R.Colors.backgroungColor
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        view.addSubview(separatorView)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        view.addSubview(bottomSeparatorView)
        
        
        descriptionTitleLabel.text = R.Strings.description
        descriptionTitleLabel.font = R.Fonts.pouf
        descriptionTitleLabel.textAlignment = .center
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionTitleLabel)
        
        
        authorProfileImageView.contentMode = .scaleAspectFill
        authorProfileImageView.clipsToBounds = true
        authorProfileImageView.layer.cornerRadius = 40
        authorProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authorProfileImageView)
        
        authorNameLabel.font = R.Fonts.pouf
        authorNameLabel.textAlignment = .center
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authorNameLabel)
        
        authorBioLabel.numberOfLines = 0
        authorBioLabel.textAlignment = .left
        authorBioLabel.font = R.Fonts.dataFont
        authorBioLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authorBioLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.9),
            
            separatorView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
                
            descriptionTitleLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            bottomSeparatorView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            bottomSeparatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomSeparatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            
            authorProfileImageView.topAnchor.constraint(equalTo: bottomSeparatorView.bottomAnchor, constant: 20),
            authorProfileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            authorProfileImageView.widthAnchor.constraint(equalToConstant: 80),
            authorProfileImageView.heightAnchor.constraint(equalTo: authorProfileImageView.widthAnchor),
            
            authorNameLabel.topAnchor.constraint(equalTo: bottomSeparatorView.bottomAnchor, constant: 20),
            authorNameLabel.leadingAnchor.constraint(equalTo:  view.leadingAnchor, constant: 20),
            
            authorBioLabel.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 10),
            authorBioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authorBioLabel.trailingAnchor.constraint(equalTo: authorProfileImageView.leadingAnchor, constant: -20)
        ])
    }
    
    
    private func createSeparatorView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.separator
        return view
    }
    
    func setupCustomBackButton() {
        let backButton = UIBarButtonItem(
            image: R.Image.chevronLeft,
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = R.Colors.black
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupNavigationButtons() {
        let shareButton = UIBarButtonItem(
            image: R.Image.squareAndArrowUp,
            style: .plain,
            target: self,
            action: #selector(shareButtonTapped)
        )
        shareButton.tintColor = .black

        let saveButton = UIBarButtonItem(
            image: R.Image.squareAndArrowDown,
            style: .plain,
            target: self,
            action: #selector(saveImageToGallery)
        )
        saveButton.tintColor = .black

        navigationItem.rightBarButtonItems = [shareButton, saveButton]
    }


}

// MARK: - Button Actions

extension DetailViewController {
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func shareButtonTapped() {
        guard let image = imageView.image else {
            print(R.Strings.imageSaveError)
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func saveImageToGallery() {
        guard let image = imageView.image else {
            print(R.Strings.imageSaveError)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            presentAlert(alertTitle: R.Strings.errorTitle, message: error.localizedDescription, buttonTitle: R.Strings.OK)
        } else {
            presentAlert(alertTitle: R.Strings.successfully, message: R.Strings.imageSave, buttonTitle: R.Strings.OK)
        }
    }

}


// MARK: - DetailViewControllerProtocol methods
extension DetailViewController {
    
    func displayImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    func displayContentDescription(_ description: String?) {
        descriptionLabel.text = description ?? R.StringsMessage.noDescription
    }

    func displayAuthorInfo(name: String?, bio: String?, profileImageUrl: String?) {
        authorNameLabel.text = name
        authorBioLabel.text = bio ?? R.StringsMessage.noBio
        
        if let profileImageUrl = profileImageUrl {
            NetworkManager.shared.downloadImage(from: profileImageUrl) { [weak self] image in
                DispatchQueue.main.async {
                    self?.authorProfileImageView.image = image
                }
            }
        }
    }

}


// MARK: - Swipe back support
extension DetailViewController: UIGestureRecognizerDelegate {
    
    func setupSwipeBackGesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
