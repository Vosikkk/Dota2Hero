//
//  Dota2HeroModel.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 02.11.2023.
//

import Foundation

struct Hero: Codable {
    let ID: Int
    let name_loc: String
    let complexity: Int
    let imageURL: URL
    let primary_attr: Int
    let attribute_imgURL: URL
}
