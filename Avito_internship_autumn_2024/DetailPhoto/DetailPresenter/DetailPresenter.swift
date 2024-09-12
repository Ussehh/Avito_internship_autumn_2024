//
//  DetailPresenter.swift
//  Avito_internship_autumn_2024
//
//  Created by Никита Абаев on 11.09.2024.
//

import Foundation

protocol DetailPresenterProtocol {
    func viewDidLoad()
}

class DetailPresenter: DetailPresenterProtocol {
    weak var view: DetailViewControllerProtocol?
    var photo: Photo
    
    init(view: DetailViewControllerProtocol?, photo: Photo) {
        self.view = view
        self.photo = photo
    }
    
    func viewDidLoad() {
        view?.displayContentDescription(photo.description)
        
        if let imageUrl = photo.urls?.regular {
            NetworkManager.shared.downloadImage(from: imageUrl) { [weak self] image in
                DispatchQueue.main.async {
                    self?.view?.displayImage(image)
                }
            }
        }
        
        view?.displayAuthorInfo(name: photo.user?.name,
                                bio: photo.user?.bio,
                                profileImageUrl: photo.user?.profileImage?.large)
        
    }
}
