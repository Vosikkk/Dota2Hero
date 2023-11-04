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
    let baseHealth, baseHealthRegen, baseMana, baseManaRegen: Double
    let baseArmor, baseMr, baseAttackMin, baseAttackMax: Double
    let baseStr, baseAgi, baseInt, strGain: Double
    let agiGain, intGain, attackRange, projectileSpeed: Double
    let attackRate, baseAttackTime, attackPoint, moveSpeed: Double
    let legs, dayVision, nightVision, heroID: Int

    
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
        case baseHealth = "base_health"
        case baseHealthRegen = "base_health_regen"
        case baseMana = "base_mana"
        case baseManaRegen = "base_mana_regen"
        case baseArmor = "base_armor"
        case baseMr = "base_mr"
        case baseAttackMin = "base_attack_min"
        case baseAttackMax = "base_attack_max"
        case baseStr = "base_str"
        case baseAgi = "base_agi"
        case baseInt = "base_int"
        case strGain = "str_gain"
        case agiGain = "agi_gain"
        case intGain = "int_gain"
        case attackRange = "attack_range"
        case projectileSpeed = "projectile_speed"
        case attackRate = "attack_rate"
        case baseAttackTime = "base_attack_time"
        case attackPoint = "attack_point"
        case moveSpeed = "move_speed"
        case legs
        case dayVision = "day_vision"
        case nightVision = "night_vision"
        case heroID = "hero_id"
       
    }
}

typealias Heroes = [Dota2HeroModel]
