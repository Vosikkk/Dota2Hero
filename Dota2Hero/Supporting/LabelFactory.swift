//
//  LabelFactory.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 09.11.2023.
//

import UIKit



protocol LabelFactoryProtocol {
    func createMainLabel() -> UILabel
    func createSupoortLabel(text: String, backgroundColor: UIColor) -> UILabel
    
}

final class LabelFactory: LabelFactoryProtocol {
    
    func createSupoortLabel(text: String, backgroundColor: UIColor ) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .tintColorForNameLabel
        label.backgroundColor = backgroundColor
        label.layer.cornerRadius = 5.0
        label.layer.masksToBounds = true
        return label
    }
    
    
    func createMainLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        return label
    }
}
