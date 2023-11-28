//
//  Fetcher.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 27.11.2023.
//

import UIKit


protocol FetcherService {
    func getHeroes(by endpoint: APIEndpoint, page: Int, pageSize: Int) async throws -> Heroes
    func getImage(by endpoint: APIEndpoint) async throws -> UIImage
}

class Fetcher: FetcherService {
    
    private let heroFetcher: APIHeroService
    
    private let imageFetcher: ImageFetcherService
    
    init(heroFetcher: APIHeroService, imageFetcher: ImageFetcherService) {
        self.heroFetcher = heroFetcher
        self.imageFetcher = imageFetcher
    }
    
    
    func getHeroes(by endpoint: APIEndpoint, page: Int, pageSize: Int) async throws -> Heroes {
          return try await heroFetcher.fetch(endpoint, page: page, pageSize: pageSize)
    }
    
    func getImage(by endpoint: APIEndpoint) async throws -> UIImage {
        return try await imageFetcher.fetchImage(from: endpoint)
    }
}
