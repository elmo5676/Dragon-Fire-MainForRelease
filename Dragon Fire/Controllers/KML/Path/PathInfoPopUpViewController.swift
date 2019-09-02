//
//  PathInfoPopUpViewController.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 9/19/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit

class PathInfoPopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func dismissButton(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
