//
//  SearchCollectionCell.swift
//  Avito_internship_autumn_2024
//
//  Created by Никита Абаев on 11.09.2024.
//

import UIKit

class SearchCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "SearchCollectionCell"
    
    private let mainImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        image.contentMode = .scaleAspectFill
        image.backgroundColor = R.Colors.black.withAlphaComponent(0.8)
        return image
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = R.Colors.black
        label.font = R.Fonts.subheadFont
        return label
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = R.Colors.textColor
        label.font = R.Fonts.dataFont
        return label
    }()
    
    private lazy var likesImageView: UIImageView = {
        let imageView = UIImageView(image: R.Image.heart )
        imageView.tintColor = R.Colors.textColor
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.Colors.textColor
        label.font = R.Fonts.dataFont
        return label
    }()
    
    private lazy var dateImageView: UIImageView = {
        let imageView = UIImageView(image: R.Image.calendar)
        imageView.tintColor = R.Colors.textColor
        return imageView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(mainImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likesLabel)
        contentView.addSubview(likesImageView)
        contentView.addSubview(loadingIndicator)
        contentView.addSubview(dateLabel)
        contentView.addSubview(dateImageView)
        
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }
    
    private func setupConstraints() {
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesImageView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor, multiplier: 1),
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),

            likesImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            likesImageView.heightAnchor.constraint(equalToConstant: 15),
            likesImageView.widthAnchor.constraint(equalTo: likesImageView.heightAnchor),
            likesImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),

            likesLabel.centerYAnchor.constraint(equalTo: likesImageView.centerYAnchor),
            likesLabel.leadingAnchor.constraint(equalTo: likesImageView.trailingAnchor, constant: 5),
            likesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),

            dateImageView.topAnchor.constraint(equalTo: likesImageView.bottomAnchor, constant: 8),
            dateImageView.heightAnchor.constraint(equalToConstant: 15),
            dateImageView.widthAnchor.constraint(equalTo: dateImageView.heightAnchor),
            dateImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),

            dateLabel.centerYAnchor.constraint(equalTo: dateImageView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: dateImageView.trailingAnchor, constant: 5),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
        ])
    }
    
    func configureCell(photo: Photo) {
        descriptionLabel.text = photo.description ?? R.StringsMessage.noDescription
        
        let likesCount = photo.likes ?? 0
        likesLabel.text = getLikesText(for: likesCount)
        
        if let createdAt = photo.createdAt {
            dateLabel.text = formatDate(from: createdAt)
        } else {
            dateLabel.text = R.StringsMessage.noData
        }
        
        guard let urlPhoto = photo.urls?.regular else { return }
        loadingIndicator.startAnimating()
        NetworkManager.shared.downloadImage(from: urlPhoto) { [weak self] image in
            DispatchQueue.main.async {
                self?.mainImageView.image = image
                self?.loadingIndicator.stopAnimating()
            }
        }
    }

    private func formatDate(from string: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: string) else { return R.StringsMessage.noData }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .none
        return displayFormatter.string(from: date)
    }
    
    private func getLikesText(for count: Int) -> String {
        let lastDigit = count % 10
        let lastTwoDigits = count % 100

        if lastTwoDigits >= 11 && lastTwoDigits <= 19 {
            return "\(count) лайков"
        } else if lastDigit == 1 {
            return "\(count) лайк"
        } else if lastDigit >= 2 && lastDigit <= 4 {
            return "\(count) лайка"
        } else {
            return "\(count) лайков"
        }
    }

}
