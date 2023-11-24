//
//  Environment.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 18.11.2023.
//

import Foundation

enum Environment {
    
    static var apiBaseURL: URL {
        URL(string:"https://api.opendota.com")!
    }
}
