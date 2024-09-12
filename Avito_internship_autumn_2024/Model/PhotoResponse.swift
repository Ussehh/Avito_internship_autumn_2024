//
//  PhotoResponse.swift
//  Avito_internship_autumn_2024
//
//  Created by Никита Абаев on 11.09.2024.
//

import Foundation

struct PhotoResponse: Codable {
    let total: Int
    let totalPages: Int
    let results: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
    
}
