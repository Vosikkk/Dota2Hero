//
//  APICaller.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 02.11.2023.
//

import Foundation


protocol APIManager {
    func fetch(page: Int, pageSize: Int, completion: @escaping (Result<Heroes, Error>) -> Void)
    var url: URL { get }
}

enum APIError: Error {
    case bad
}

final class Dota2HeroFetcher: APIManager {
    
    var url: URL {
        return URL(string:"https://api.opendota.com/api/heroStats")!
    }
    
    func fetch(page: Int, pageSize: Int, completion: @escaping (Result<Heroes, Error>) -> Void) {
        
        let request = URLRequest(url: url)
        
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
