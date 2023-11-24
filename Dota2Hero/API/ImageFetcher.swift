//
//  ImageFetcher.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 06.11.2023.
//


import UIKit

protocol ImageFetcherService {
    func fetchImage(from endpoint: APIEndpoint, completion: @escaping (Result<UIImage, Dota2HeroError>) -> Void)
}

class ImageFetcher: ImageFetcherService {
   
    private let cache: Cache
    
    init(cache: Cache) {
        self.cache = cache
    }
    
    func fetchImage(from endpoint: APIEndpoint, completion: @escaping (Result<UIImage, Dota2HeroError>) -> Void) {
        
        guard let url = endpoint.request.url else { completion(.failure(Dota2HeroError.badURL)); return }
        
        if let cachedImage = cache.load(for: url.absoluteString) {
            completion(.success(cachedImage))
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                self.cache.save(image, for: url.absoluteString)
                completion(.success(image))
            } else {
                completion(.failure(Dota2HeroError.networkError))
            }
        }
    }
}

