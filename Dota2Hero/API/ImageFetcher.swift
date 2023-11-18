//
//  ImageFetcher.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 06.11.2023.
//


import UIKit

class ImageFetcher {
   
    private let cache = NSCache<NSString, UIImage>()
    
    func fetchImage(from endpoint: APIEndpoint, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        guard let url = endpoint.request.url else { completion(.failure(ImageFetcherError.badURL)); return }
        
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            completion(.success(cachedImage))
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: url.absoluteString as NSString)
                completion(.success(image))
            } else {
                completion(.failure(ImageFetcherError.networkError))
            }
        }
    }
}

enum ImageFetcherError: Error {
    case networkError
    case badURL
}
