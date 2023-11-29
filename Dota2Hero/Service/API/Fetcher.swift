//
//  Fetcher.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 27.11.2023.
//

import UIKit

// Protocol defining the contract for a service that fetches heroes and images

protocol FetcherService {
    
    // Asynchronous method to fetch a paginated list of heroes from a given API endpoint
    func getHeroes(by endpoint: APIEndpoint, page: Int, pageSize: Int) async throws -> Heroes
    
    // Asynchronous method to fetch an image from a given API endpoint
    func getImage(by endpoint: APIEndpoint) async throws -> UIImage
}

// Class implementing the FetcherService protocol

class Fetcher: FetcherService {
    
    // Instance of a service to fetch Dota 2 heroes
    private let heroFetcher: APIHeroService
    
    // Instance of a service to fetch images
    private let imageFetcher: ImageFetcherService
    
    // Initializer
    
    init(heroFetcher: APIHeroService, imageFetcher: ImageFetcherService) {
        self.heroFetcher = heroFetcher
        self.imageFetcher = imageFetcher
    }
    
    
    func getHeroes(by endpoint: APIEndpoint, page: Int, pageSize: Int) async throws -> Heroes {
        
        // Delegate the hero fetching task to the heroFetcher instance
        
        return try await heroFetcher.fetch(endpoint, page: page, pageSize: pageSize)
    }
    
    func getImage(by endpoint: APIEndpoint) async throws -> UIImage {
        
        // Delegate the image fetching task to the imageFetcher instance
        
        return try await imageFetcher.fetchImage(from: endpoint)
    }
}
