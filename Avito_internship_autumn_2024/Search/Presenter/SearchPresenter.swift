//
//  SearchPresenter.swift
//  Avito_internship_autumn_2024
//
//  Created by Никита Абаев on 11.09.2024.
//

import UIKit
import Dispatch

protocol SearchPresenterProtocol {
    func searchItems(term: String, page: Int, sortBy: String)
    func clearSearchResults()
    func getHistoryItems(term: String?)
    func goToDetails(selectedItemIdx: Int)
}

final class SearchPresenter: SearchPresenterProtocol {
    
    weak private var view: SearchViewControllerProtocol?
    private let networkManager: NetworkManagerProtocol
    var totalPages: Int = 0
    var hasMorePhotos = true
    private var term: String = ""
    private var currentPhotoResponse: PhotoResponse?
    private(set) var photos: [Photo] = []
    

    init() {
        self.networkManager = NetworkManager()
    }
    
    func setPhotos(_ newPhotos: [Photo]) {
        self.photos = newPhotos
    }
    
    func setView(view: SearchViewControllerProtocol) {
        self.view = view
    }
    
    private func saveTerm(term: String) {
        var allHistoryItems = UserDefaults.standard.stringArray(forKey: R.Constants.historyItemKey) ?? []
        if let idx = allHistoryItems.firstIndex(of: term) {
            allHistoryItems.remove(at: idx)
        }
        allHistoryItems.append(term)
        UserDefaults.standard.set(allHistoryItems, forKey: R.Constants.historyItemKey)
    }
    
    
    func searchItems(term: String, page: Int = 1, sortBy: String = R.Constants.sortedBy) {
        DispatchQueue.main.async {
            self.view?.startActivityIndicator()
        }
        DispatchQueue.global().async {
            self.saveTerm(term: term)
            self.term = term
            self.networkManager.getPhotoResponse(query: term, page: page, perPage: 30, sorderBy: sortBy) { result in
                DispatchQueue.main.async {
                    self.view?.stopActivityIndicator()
                }
                
                switch result {
                case .success(let response):
                    self.currentPhotoResponse = response
                    self.totalPages = response.totalPages
                    
                    DispatchQueue.main.async {
                        if page == 1 {
                            self.view?.updateSearch(photos: response.results)
                        } else {
                            self.view?.updateSearch(photos: self.currentPhotoResponse?.results ?? [])
                        }
                        self.hasMorePhotos = page < self.totalPages
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.view?.showError(error.localizedDescription)
                    }
                }
            }
        }
    }

    
    func clearSearchResults() {
        currentPhotoResponse = nil
        view?.updateSearch(photos: [])
        view?.clearView()
    }
    
    func getHistoryItems(term: String?) {
        guard let term = term else {
            self.view?.updateHistory(queries: [])
            return
        }
        let allHistoryItems = UserDefaults.standard.stringArray(forKey: R.Constants.historyItemKey) ?? []
        let historyItems: [String]
        if term == "" {
            historyItems = Array<String>(allHistoryItems.suffix(5).reversed())
        } else {
            historyItems = Array<String>(allHistoryItems.filter { $0.lowercased().contains(term.lowercased()) }.suffix(5).reversed())
        }
        self.view?.updateHistory(queries: historyItems)
    }
    
    func goToDetails(selectedItemIdx: Int) {
        guard selectedItemIdx >= 0 && selectedItemIdx < photos.count else {
            return
        }

        let selectedPhoto = photos[selectedItemIdx]
        view?.navigationToPhotoDetails(photo: selectedPhoto)
    }


    
    // MARK: - random Photos
    
    func loadRandomPhotos(count: Int = 10) {
        DispatchQueue.main.async {
            self.view?.startActivityIndicator()
        }

        networkManager.getRandomPhotos(count: count) { result in
            DispatchQueue.main.async {
                self.view?.stopActivityIndicator()
            }

            switch result {
            case .success(let photos):
                DispatchQueue.main.async {
                    self.view?.updateRandomPhotos(photos: photos)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func loadMoreRandomPhotos(count: Int = 10) {
        DispatchQueue.main.async {
            self.view?.startActivityIndicator()
        }

        networkManager.getRandomPhotos(count: count) { result in
            DispatchQueue.main.async {
                self.view?.stopActivityIndicator()
            }

            switch result {
            case .success(let photos):
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: photos)
                    self.view?.updateRandomPhotos(photos: photos)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func addRandomPhotos(_ morePhotos: [Photo]) {
        self.photos.append(contentsOf: morePhotos)
    }
    
    
    //MARK: - Sort photos
    
    func sortPhotos(by option: SortOption) {
        switch option {
        case .newest:
            self.photos.sort { $0.createdAt ?? "" > $1.createdAt ?? "" }
        case .popular:
            self.photos.sort { $0.likes ?? 0 > $1.likes ?? 0 }
        }
        
        DispatchQueue.main.async {
            self.view?.updateSearch(photos: self.photos)
        }
    }

    
}
