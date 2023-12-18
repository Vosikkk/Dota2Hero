//
//  TestHelpers.swift
//  Dota2HeroTests
//
//  Created by Саша Восколович on 18.12.2023.
//

import UIKit

func tap(_ button: UIButton) {
    button.sendActions(for: .touchUpInside)
}

//func tapB(_ button: UIBarButtonItem) {
//    _ = button.target?.perform(button.action, with: nil)
//}
