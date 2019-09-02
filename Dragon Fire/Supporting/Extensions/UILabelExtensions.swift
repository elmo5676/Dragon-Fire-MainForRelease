//
//  UILabelExtensions.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 8/8/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import Foundation
import UIKit


extension UILabel {
    func setFont(name: Font, size: CGFloat, color: UIColor) {
        let descriptor = UIFontDescriptor(name: name.rawValue, size: size)
        self.font = UIFont(descriptor: descriptor, size: size)
        self.textColor = color
    }
    
    func indicatorLabelIsOn(_ on: Bool) {
        if on == true {
            self.backgroundColor = #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)
        } else {
            self.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.1909630299, alpha: 1)
        }
            self.layer.cornerRadius = self.frame.width/4
            self.layer.borderColor = #colorLiteral(red: 0.2901960784, green: 0.3333333333, blue: 0.3921568627, alpha: 1)
            self.layer.borderWidth = 1
    }
    
    func indicatorLabelIsOnRound(_ on: Bool) {
        if on == true {
            self.backgroundColor = #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)
        } else {
            self.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.1909630299, alpha: 1)
        }
        self.layer.cornerRadius = self.frame.width/2
        self.layer.borderColor = #colorLiteral(red: 0.2901960784, green: 0.3333333333, blue: 0.3921568627, alpha: 1)
        self.layer.borderWidth = 1
    }
    
    enum Font: String {
        case Avenir = "Avenir"
        case Times = "Times"
        case systemFont = "systemFont"
    }
    
    
    
    
}
