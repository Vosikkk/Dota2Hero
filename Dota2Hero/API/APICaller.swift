//
//  APICaller.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 02.11.2023.
//

import Foundation


protocol APIManager {
    func fetch(_ endpoint: APIEndpoint, page: Int, pageSize: Int, completion: @escaping (Result<Heroes, Error>) -> Void)
}

final class Dota2HeroFetcher: APIManager {
    
    
    func fetch(_ endpoint: APIEndpoint, page: Int, pageSize: Int, completion: @escaping (Result<Heroes, Error>) -> Void) {
        let request = endpoint.request
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                do {
                    let startIndex = (page - 1) * pageSize
                    let heroes = try JSONDecoder().decode(Heroes.self, from: data)
                    
                    let endIndex = min(startIndex + pageSize, heroes.count)
                    let paginatedHeroes = Array(heroes[startIndex..<endIndex])
                    completion(.success(paginatedHeroes))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
}
