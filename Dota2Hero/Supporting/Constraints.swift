//
//  Constraints.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 07.11.2023.
//

import UIKit


precedencegroup ConstraintPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
}


// infix operator ->>- ;  associativity left precedence 160

infix operator ->>- : ConstraintPrecedence

struct Constraint {
    
    var identifier: String?
    
    var attribute: NSLayoutConstraint.Attribute = .centerX
    var secondAttribute: NSLayoutConstraint.Attribute = .notAnAttribute
    
    var constant: CGFloat = 0
    var multiplier: CGFloat = 1
    
    var relation: NSLayoutConstraint.Relation = .equal
}


func ->>- <T: UIView> (lhs: (T,T), apply: (inout Constraint) -> ()) -> NSLayoutConstraint {
    var const = Constraint()
    apply(&const)
    
    const.secondAttribute = .notAnAttribute == const.secondAttribute ? const.attribute : const.secondAttribute
    
    let constraint = NSLayoutConstraint(
        item: lhs.0,
        attribute: const.attribute,
        relatedBy: const.relation,
        toItem: lhs.1,
        attribute: const.secondAttribute,
        multiplier: const.multiplier,
        constant: const.constant)
    
    constraint.identifier = const.identifier
    
    NSLayoutConstraint.activate([constraint])
    return constraint
}

func ->>- <T: UIView> (lhs: T, apply: (inout Constraint) -> ()) -> NSLayoutConstraint {
    var const = Constraint()
    apply(&const)
    
    let constraint = NSLayoutConstraint(
        item: lhs,
        attribute: const.attribute,
        relatedBy: const.relation,
        toItem: nil,
        attribute: const.attribute,
        multiplier: const.multiplier,
        constant: const.constant)
    
    constraint.identifier = const.identifier
    
    NSLayoutConstraint.activate([constraint])
    return constraint
}


func ->>- <T:UIView> (lhs: (T,T), attributes: [NSLayoutConstraint.Attribute]) {
    for attribute in attributes {
        lhs ->>- { (i: inout Constraint) in
            i.attribute = attribute
        }
    }
}

func ->>- <T:UIView> (lhs: T, attributes: [NSLayoutConstraint.Attribute]) {
    for attribute in attributes{
        lhs ->>- { (i: inout Constraint) in
            i.attribute = attribute
        }
    }
}
