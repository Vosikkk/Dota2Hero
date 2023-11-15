//
//  Dota2HeroModel.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 02.11.2023.
//

import Foundation

typealias Heroes = [Dota2HeroModel]


struct Dota2HeroModel: Codable {
   
    let id: Int
    let name, localizedName, primaryAttr, attackType: String
    let roles: [String]
    let img: String
    let baseMana, baseHealth: Double
    let baseManaRegen, baseHealthRegen: Double
    
    let baseAttackMin, baseAttackMax, attackRange, attackSpeed: Double
    let moveSpeed: Double
   
    let baseStr, baseAgi, baseInt: Double
    let agiGain, intGain, strGain: Double
   
    
    let heroID: Int
    
    var isLiked: Bool = false
    
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
        case baseMana = "base_mana"
        case baseManaRegen = "base_mana_regen"
        case baseHealth = "base_health"
        case baseHealthRegen = "base_health_regen"
        case baseAttackMin = "base_attack_min"
        case baseAttackMax = "base_attack_max"
        case attackRange = "attack_range"
        case moveSpeed = "move_speed"
        case attackSpeed = "base_attack_time"
    }
}

extension Heroes {
    
    func indexOfHero(withID id: Int) -> Self.Index {
        guard let index = firstIndex(where: { $0.heroID == id }) else { fatalError() }
        return index
    }
}

