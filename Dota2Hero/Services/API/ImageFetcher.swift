//
//  ImageFetcher.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 06.11.2023.
//


import UIKit

// Protocol defining the contract for an image fetching service

protocol ImageFetcherService {
    
    // Asynchronous method to fetch an image from a given API endpoint
    func fetchImage(from endpoint: APIEndpoint) async throws -> UIImage
}

class ImageFetcher: ImageFetcherService {
    
    
    // Cache instance to store and retrieve images
    private let cache: Cache
    
    
    init(cache: Cache) {
        self.cache = cache
    }
    
    
    // Asynchronous method to fetch an image from a given API endpoint
    
    func fetchImage(from endpoint: APIEndpoint) async throws -> UIImage {
        
        var image: UIImage
        
        guard let url = endpoint.request.url else  {
            throw Dota2HeroError.badURL
        }
        
        if let cachedImage = cache.load(for: url.absoluteString) {
            image = cachedImage
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let res = UIImage(data: data) {
                image = res
                cache.save(image, for: url.absoluteString)
            } else {
                throw Dota2HeroError.networkError
            }
        } catch {
            throw Dota2HeroError.networkError
        }
        return image
    }
}

