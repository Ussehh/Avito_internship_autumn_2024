//
//  Photo.swift
//  Avito_internship_autumn_2024
//
//  Created by Никита Абаев on 11.09.2024.
//

import Foundation

// MARK: - Photo
struct Photo: Codable {
    let id: String?
    let createdAt: String?
    let width: Int?
    let height: Int?
    let color: String?
    let description: String?
    let altDescription: String?
    let urls: Urls?
    let links: Links?
    let likes: Int?
    let user: User?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height, color, description
        case altDescription = "alt_description"
        case urls, links, likes
        case user
    }
}

// MARK: - Links
struct Links: Codable {
    let selfLink: String?
    let html: String?
    let download: String?
    let downloadLocation: String?
    
    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case html, download
        case downloadLocation = "download_location"
    }
}

// MARK: - Urls
struct Urls: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
    let smallS3: String?
    
    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}
