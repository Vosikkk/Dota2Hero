//
//  FaveButton.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 07.11.2023.
//

import Foundation
import UIKit

class FaveButton: UIButton {
    
    private struct Constants {
        static let duration = 1.0
        static let expandDuration = 0.1298
        static let collapseDuration = 0.1089
        static let faveIconShowDelay = Constants.expandDuration + Constants.collapseDuration / 2.0
        static let dotRadiusFactors = (first: 0.0633, second: 0.04)
    }
    
    var normalColor: UIColor = UIColor(red: 137/255, green: 156/255, blue: 167/255, alpha: 1)
    var selectedColor: UIColor = UIColor(red: 226/255, green: 38/255,  blue: 77/255,  alpha: 1)
    var dotFirstColor: UIColor = UIColor(red: 152/255, green: 219/255, blue: 236/255, alpha: 1)
    var dotSecondColor: UIColor = UIColor(red: 247/255, green: 188/255, blue: 48/255,  alpha: 1)
    var circleFromColor: UIColor = UIColor(red: 221/255, green: 70/255,  blue: 136/255, alpha: 1)
    var circleToColor: UIColor = UIColor(red: 205/255, green: 143/255, blue: 246/255, alpha: 1)
    
    private(set) var sparkGroupCount: Int = 7
    
    
    private var faveIconImage: UIImage?
    private var faveIcon: FaveIcon!
    
}
