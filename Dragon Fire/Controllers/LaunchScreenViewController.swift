//
//  LaunchScreenViewController.swift
//  Dragon Fire
//
//  Created by elmo on 6/18/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        iconImageOutlet.layer.cornerRadius = iconImageOutlet.frame.width/10
        iconImageOutlet.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        iconImageOutlet.layer.borderWidth = 3

    }

    @IBOutlet weak var iconImageOutlet: UIImageView!
    
}
