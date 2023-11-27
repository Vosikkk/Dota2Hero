//
//  Fetcher.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 27.11.2023.
//

import UIKit


protocol FetcherService {
    func getHeros(by endpoint: APIEndpoint, page: Int, pageSize: Int) async throws-> Result<Heroes, Dota2HeroError>
    func getImage(from endpoint: APIEndpoint) async throws -> Result<UIImage, Dota2HeroError>
}

class Fetcher: FetcherService {
    
    private let heroFetcher: APIHeroService
    
    private let imageFetcher: ImageFetcherService
    
    init(heroFetcher: APIHeroService, imageFetcher: ImageFetcherService) {
        self.heroFetcher = heroFetcher
        self.imageFetcher = imageFetcher
    }
    
    func getHeros(by endpoint: APIEndpoint, page: Int, pageSize: Int) async throws -> Result<Heroes, Dota2HeroError> {
        return await withCheckedContinuation { continuation in
            heroFetcher.fetch(endpoint, page: page, pageSize: pageSize) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    func getImage(from endpoint: APIEndpoint) async throws -> Result<UIImage, Dota2HeroError> {
        return await withCheckedContinuation { continuation in
            imageFetcher.fetchImage(from: endpoint) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
