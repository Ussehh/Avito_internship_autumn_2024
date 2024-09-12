//
//  NetworkManager.swift
//  Avito_internship_autumn_2024
//
//  Created by Никита Абаев on 11.09.2024.
//

import UIKit
// MARK: - Enum

enum APIConstants {

    static let accessKey      = "1sSzF0q_9Ch7nIdKSDdmKQsv8A5o24MydXUv6wwx9_M"
    static let baseURL        = "https://api.unsplash.com"
    static let searchEndpoint = "/search"
    static let photosEndpoint = "/photos"
    static let usersEndpoint  = "/users"
}
// MARK: - Protocol

protocol NetworkManagerProtocol {
    
    typealias HandlerPhotoResponse = (Result<PhotoResponse, NetworkError>) -> Void
    typealias HandlerPhoto = (Result<Photo, NetworkError>) -> Void
    typealias HandlerUser = (Result<User, NetworkError>) -> Void
    
    
    func getPhotoResponse(query: String, page: Int?, perPage: Int?, sorderBy: String?, completion: @escaping HandlerPhotoResponse)
    func getPhoto(by id: String, completion: @escaping HandlerPhoto)
    func getUser(by username: String, completion: @escaping HandlerUser)
    func getRandomPhotos(count: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void)
}

// MARK: - Class

class NetworkManager: NetworkManagerProtocol {
    
    var session = URLSession.shared
    static let shared = NetworkManager()
    let cache = NSCache<NSString, UIImage>()
    
    private func performRequest<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
         let task = URLSession.shared.dataTask(with: url) { data, response, error in
             if let _ = error {
                 completion(.failure(.unableToComplete))
                 return
             }
             
             guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                 completion(.failure(.invalidResponse))
                 return
             }
             
             guard let data = data else {
                 completion(.failure(.invalidData))
                 return
             }
              
             do {
                 let decoder = JSONDecoder()
                 let decodedData = try decoder.decode(T.self, from: data)
                 completion(.success(decodedData))
             } catch {
                 completion(.failure(.invalidData))
             }
         }
         task.resume()
     }
    
}

// MARK: - Image Downloading

extension NetworkManager {
    
    func downloadImage(from url: String?, completed: @escaping (UIImage?) -> Void) {
        guard let url = url else { return }
        let cacheKey = NSString(string: url)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        guard let url = URL(string: url) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse,response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }

}


// MARK: - API Requests

extension NetworkManager {
    
    func getPhotoResponse(query: String, page: Int? = 1, perPage: Int? = 30, sorderBy: String? = R.Constants.sortedBy, completion: @escaping HandlerPhotoResponse) {
        let components = URLComponents(string: "\(APIConstants.baseURL)\(APIConstants.searchEndpoint)\(APIConstants.photosEndpoint)?")
        guard var components = components else { return }
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page ?? 1)"),
            URLQueryItem(name: "per_page", value: "\(perPage ?? 30)"),
            URLQueryItem(name: "order_by", value: sorderBy ?? "relevant"),
            URLQueryItem(name: "client_id", value: APIConstants.accessKey)
        ]
        
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        performRequest(url: url, completion: completion)
    }
    
    
    func getPhoto(by id: String, completion: @escaping HandlerPhoto) {
        let urlString = "\(APIConstants.baseURL)\(APIConstants.photosEndpoint)/\(id)?client_id=\(APIConstants.accessKey)"
            guard let url = URL(string: urlString) else {
                completion(.failure(.invalidURL))
                return
            }
            
            performRequest(url: url, completion: completion)
}
    
    
    func getUser(by username: String, completion: @escaping HandlerUser) {
        let urlString = "\(APIConstants.baseURL)\(APIConstants.usersEndpoint)/\(username)?client_id=\(APIConstants.accessKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        performRequest(url: url, completion: completion)
    }
    
    
    func getRandomPhotos(count: Int = 10, completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        let urlString = "\(APIConstants.baseURL)\(APIConstants.photosEndpoint)/random?count=\(count)&client_id=\(APIConstants.accessKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        performRequest(url: url, completion: completion)
    }
    
}

