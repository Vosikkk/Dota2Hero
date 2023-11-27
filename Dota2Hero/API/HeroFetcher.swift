//
//  Dota2HeroFetcher.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 02.11.2023.
//

import UIKit


protocol APIHeroService {
    func fetch(_ endpoint: APIEndpoint, page: Int, pageSize: Int, completion: @escaping (Result<Heroes, Dota2HeroError>) -> Void)
}

final class HeroFetcher: APIHeroService {
    
    func fetch(_ endpoint: APIEndpoint, page: Int, pageSize: Int, completion: @escaping (Result<Heroes, Dota2HeroError>) -> Void) {
        let request = endpoint.request
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if  error != nil {
                completion(.failure(Dota2HeroError.networkError))
                return
            }
            
            if let data = data {
                do {
                    let startIndex = (page - 1) * pageSize
                    
                    let heroes = try data.decodeJson(for: Heroes.self)
                    
                    let endIndex = min(startIndex + pageSize, heroes.count)
                    let paginatedHeroes = Array(heroes[startIndex..<endIndex])
                    completion(.success(paginatedHeroes))
                    
                } catch let decodingError as DecodingError {
                    completion(.failure(Dota2HeroError.decodingError(decodingError.localizedDescription)))
                    
                } catch {
                    completion(.failure(Dota2HeroError.unknown))
                }
            }
        }
        dataTask.resume()
    }
}
