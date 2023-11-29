//
//  Dota2HeroFetcher.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 02.11.2023.
//

import UIKit

// Protocol defining the contract for a service that fetches Dota 2 heroes from an API

protocol APIHeroService {
    
    // Asynchronous method to fetch a paginated list of heroes from a given API endpoint
    
    func fetch(_ endpoint: APIEndpoint, page: Int, pageSize: Int) async throws -> Heroes
}


// Class implementing the APIHeroService protocol

final class HeroFetcher: APIHeroService {
    
    
    func fetch(_ endpoint: APIEndpoint, page: Int, pageSize: Int) async throws -> Heroes {
        
        let request = endpoint.request
        
        do {
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // Calculate the range of heroes to extract based on pagination parameters
            let startIndex = (page - 1) * pageSize
            let heroes = try data.decodeJson(for: Heroes.self)
            
            let endIndex = min(startIndex + pageSize, heroes.count)
            let paginatedHeroes = Array(heroes[startIndex..<endIndex])
            
            return paginatedHeroes
            
        } catch let decodingError as DecodingError {
            throw Dota2HeroError.decodingError(decodingError.localizedDescription)
            
        } catch is URLError {
            throw Dota2HeroError.networkError
            
        } catch {
            throw Dota2HeroError.unknown
        }
    }
}
