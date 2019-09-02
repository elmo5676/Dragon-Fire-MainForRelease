//
//  Extensions.swift
//  Dragon Fire
//
//  Created by elmo on 6/15/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import Foundation
import UIKit
import CoreData





public extension NSManagedObject {
    
    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
    
}


extension UIButton {
    func wiggle() {
        let wiggleAnim = CABasicAnimation(keyPath: "position")
        wiggleAnim.duration = 0.05
        wiggleAnim.repeatCount = 5
        wiggleAnim.autoreverses = true
        wiggleAnim.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        wiggleAnim.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(wiggleAnim, forKey: "position")
    }
    func dim() {
        UIView.animate(withDuration: 0.17, animations: {self.alpha = 0.65}) {
            (finished) in UIView.animate(withDuration: 0.15, animations: {
                self.alpha = 1.0})
        }
    }
    func colorize() {
        let randomNumberArray = generateRandomNumbers(quantity: 3)
        let randomColor = UIColor(red: randomNumberArray[0]/255, green:     randomNumberArray[1]/255, blue: randomNumberArray[2]/255, alpha: 1.0)
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = randomColor
        }
    }
    
    
    func showPressed() {
        let bgc = self.layer.backgroundColor
        UIView.animate(withDuration: 0.05) {
            self.backgroundColor = #colorLiteral(red: 0.6157805324, green: 0.6158866882, blue: 0.6157665849, alpha: 1)
        }
        UIView.animate(withDuration: 0.35) {
            self.layer.backgroundColor = bgc
        }
    }
    func showPressedDark() {
        let bgc = self.layer.backgroundColor
        UIView.animate(withDuration: 0.05) {
            self.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        }
        UIView.animate(withDuration: 0.35) {
            self.layer.backgroundColor = bgc
        }
    }
    
    func standardButtonFormatting(cornerRadius: Bool) {
        self.backgroundColor = #colorLiteral(red: 0.2771260142, green: 0.3437626958, blue: 0.4359292388, alpha: 1)
        self.layer.borderColor = #colorLiteral(red: 0.04876295477, green: 0.06029307097, blue: 0.07680539042, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 2
        if cornerRadius == true {
            self.layer.cornerRadius = (self.frame.width)/10
        }
        
    }
    func standardRoundButtonFormatting(cornerRadius: Bool) {
        self.backgroundColor = #colorLiteral(red: 0.2771260142, green: 0.3437626958, blue: 0.4359292388, alpha: 1)
        self.layer.borderColor = #colorLiteral(red: 0.04876295477, green: 0.06029307097, blue: 0.07680539042, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 2
        if cornerRadius == true {
            self.layer.cornerRadius = (self.frame.width)/2
        }
        
    }
    
    func generateRandomNumbers(quantity: Int) -> [CGFloat] {
        var randomNumberArray = [CGFloat]()
        for _ in 1...quantity {
            let randomNumber = CGFloat(arc4random_uniform(255))
            randomNumberArray.append(randomNumber)
        }
        return randomNumberArray
    }
    
}
