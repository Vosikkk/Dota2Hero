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
            .foregroundColor: UIColor.red
        ])
        attributedString.append(attackTypeString)
        if !roles.isEmpty {
            let rolesString = roles.map { $0.uppercased() }.joined(separator: ", ")
            let rolesAttributedString = NSAttributedString(string: rolesString, attributes: [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.red
            ])
            attributedString.append(rolesAttributedString)
        }
        return attributedString
    }
}


protocol NavigationBarDota2Logo {
    func configureNavigationBarWithLogo()
}

extension NavigationBarDota2Logo where Self: BaseViewController {
    
    func configureNavigationBarWithLogo() {
        
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 36))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "dota2_logo")
        
        let middleView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 36))
        middleView.addSubview(logoImageView)
        navigationItem.titleView = middleView
    }
}

extension CAGradientLayer {
    
    static func gradientLayer(in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = colors()
        layer.frame = frame
        return layer
    }
    
    private static func colors() -> [CGColor] {
        let beginColor: UIColor = UIColor(red: 26/255, green: 43/255, blue: 62/255, alpha: 1.0)
        let endColor: UIColor = UIColor(red: 20/255, green: 30/255, blue: 48/255, alpha: 1.0)
        
        return [beginColor.cgColor, endColor.cgColor]
    }
    
}

extension Data {
    
    func decodeJson<T: Decodable>(for type: T.Type) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: self)
        } catch {
            throw error
        }
    }
}

func Init<T>(_ object: T, block: (T) throws -> ()) rethrows -> T {
    try block(object)
    return object
}



