//
//  APIEndpoint.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 18.11.2023.
//

import Foundation

typealias Headers = [String: String]

enum APIEndpoint {
    
    // MARK: - Cases
    
    case heroes
    
    case image(String)
    
    // MARK: - Properties
    
    var request: URLRequest {
        var request = URLRequest(url: url)
        
        request.addHeaders(headers)
        request.httpMethod = httpMethod.rawValue
        
        return request
    }
    
    private var url: URL {
        return  URL(string: "\(Environment.apiBaseURL)" + "\(path)")!
    }
    
    private var path: String {
        switch self {
        case .heroes:
            return "/api/heroStats"
        case .image(let path):
            return path
        }
    }
    
    private var headers: Headers {
        [
            "Content-Type": "application.json"
        ]
    }
    
    private var httpMethod: HTTPMethod {
        switch self {
        case .heroes, .image:
            return .get
        }
    }
    
}

fileprivate extension URLRequest {
    mutating func addHeaders(_ headers: Headers) {
        headers.forEach { header, value in
            addValue(value, forHTTPHeaderField: header)
        }
    }
}
