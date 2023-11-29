//
//  Dota2Hero+Error.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 24.11.2023.
//

import Foundation


enum Dota2HeroError: LocalizedError {
   
    case networkError
    case badURL
    case decodingError(String)
    case unknown
    
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            return NSLocalizedString("Invalid URL", comment: "Description for badURL error")
        case .networkError:
            return NSLocalizedString("Network error occurred", comment: "Description for networkError")
        case .decodingError(let description):
            return NSLocalizedString("Decoding error: \(description)", comment: "Description for decoding")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Description for Unknown")
        }
    }
}
