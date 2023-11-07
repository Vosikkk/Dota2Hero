//
//  Easing.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 07.11.2023.
//

import UIKit

typealias Easing = (_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat
typealias ElasticEasing = (_ t: CGFloat, _ b:CGFloat, _ c: CGFloat, _ d: CGFloat, _ a: CGFloat, _ p: CGFloat) -> CGFloat


struct Elastic {
    
    static var EaseIn: Easing = { (_t, b, c, d) -> CGFloat in
         var t = _t
        
        if t == 0 { return b }
        t /= d
        
        if t == 1 { return b + c }
        
        let p = d * 0.3
        let a = c
        let s = p / 4
        
        t -= 1
        
        return -(a * pow(2, 10 * t) * sin((t * d - s) * (2 * (.pi)) / p)) + b;
    }
    
    static var EaseOut: Easing = { (_t, b, c, d) -> CGFloat in
        
        var t = _t
        
        if t == 0 { return b }
        
        t /= d
        if t == 1{ return b + c }
        
        let p = d * 0.3
        let a = c
        let s = p / 4
        
        return (a * pow(2, -10 * t) * sin((t * d - s) * (2 * (.pi)) / p ) + c + b);
    }
    
    static var EaseInOut :Easing = { (_t, b, c, d) -> CGFloat in
            var t = _t
            if t == 0 { return b }
            
            t = t / (d / 2)
            
            if t == 2{ return b + c }
            
            let p = d * (0.3 * 1.5)
            let a = c
            let s = p / 4
            
            if t < 1 {
                t -= 1
                return -0.5 * (a * pow(2, 10 * t) * sin((t * d - s) * (2 * (.pi)) / p )) + b;
            }
            t -= 1
            return a * pow(2, -10 * t) * sin((t * d - s) * (2 * (.pi)) / p ) * 0.5 + c + b;
        }
}
