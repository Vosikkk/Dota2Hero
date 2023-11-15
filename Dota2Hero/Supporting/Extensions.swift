//
//  Extension.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 05.11.2023.
//

import UIKit

extension UIWindow {
    
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}

extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}

extension CGSize{
    func rectCentered(at: CGPoint) -> CGRect {
        let dx = self.width/2
        let dy = self.height/2
        let origin = CGPoint(x: at.x - dx, y: at.y - dy )
        return CGRect(origin: origin, size: self)
    }
    
    func scaleBy(_ factor: CGFloat) -> CGSize {
        return CGSize(width: self.width * factor, height: self.height * factor)
    }
}

extension CGRect{
    var center: CGPoint {
        return CGPoint( x: self.size.width / 2.0,y: self.size.height / 2.0)
    }
}

extension Double {
    var degrees: Double {
        return self * (.pi) / 180.0
    }
    
    var radians: Double {
        return self * 180.0 / (.pi)
    }
}

protocol MakeSpecialLabel {
    func createLabel(with attackType: String, and roles: [String]) -> NSMutableAttributedString
}

extension MakeSpecialLabel where Self: UITableViewCell {
   
    func createLabel(with attackType: String, and roles: [String]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        let attackTypeString = NSMutableAttributedString(string: "\(attackType.uppercased()) - ", attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .bold),
            .foregroundColor: UIColor.tintColorForAttackTypeLabel
        ])
        attributedString.append(attackTypeString)
        if !roles.isEmpty {
            let rolesString = roles.map { $0.uppercased() }.joined(separator: ", ")
            let rolesAttributedString = NSAttributedString(string: rolesString, attributes: [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.tintColorForRolesLabel
            ])
            attributedString.append(rolesAttributedString)
        }
        return attributedString
    }
}

func Init<T>(_ object: T, block: (T) throws -> ()) rethrows -> T {
    try block(object)
    return object
}
