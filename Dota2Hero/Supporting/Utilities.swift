//
//  Utilities.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 03.11.2023.
//

import Foundation
import UIKit



protocol MakeSpecialLabel {
    func createLabel(with attackType: String, and roles: [String]) -> NSMutableAttributedString
}

extension MakeSpecialLabel where Self: UITableViewCell {
   
    func createLabel(with attackType: String, and roles: [String]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        let attackTypeString = NSMutableAttributedString(string: "\(attackType.uppercased()) - ", attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .bold),
            .foregroundColor: UIColor.black
        ])
        attributedString.append(attackTypeString)
        if !roles.isEmpty {
            let rolesString = roles.map { $0.uppercased() }.joined(separator: ", ")
            let rolesAttributedString = NSAttributedString(string: rolesString, attributes: [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.lightGray
            ])
            attributedString.append(rolesAttributedString)
        }
        return attributedString
    }
}
