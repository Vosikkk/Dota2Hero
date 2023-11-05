//
//  Dota2HeroModel.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 02.11.2023.
//

import Foundation

struct Dota2HeroModel: Codable {
   
    let id: Int
    let name, localizedName, primaryAttr, attackType: String
    let roles: [String]
    let img: String
   
   
    let baseStr, baseAgi, baseInt, strGain: Double
    let agiGain, intGain: Double
   
    let heroID: Int
    
    var imageURL: URL? {
            let baseURLString = "https://api.opendota.com"
            let fullURLString = baseURLString + img
            return URL(string: fullURLString)
        }
    
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case localizedName = "localized_name"
        case primaryAttr = "primary_attr"
        case attackType = "attack_type"
        case roles, img
        case baseStr = "base_str"
        case baseAgi = "base_agi"
        case baseInt = "base_int"
        case strGain = "str_gain"
        case agiGain = "agi_gain"
        case intGain = "int_gain"
        case heroID = "hero_id"
       
    }
}

typealias Heroes = [Dota2HeroModel]
