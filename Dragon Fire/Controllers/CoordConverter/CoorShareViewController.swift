//
//  CoorShareViewController.swift
//  Dragon Fire
//
//  Created by Matthew Elmore on 12/2/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit

class CoorShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        for button in buttonOutlets {
            button.standardButtonFormatting(cornerRadius: true)
        }
        

    }
    
    var coordsToShare: String = ""
    
    @IBOutlet var buttonOutlets: [UIButton]!
    @IBAction func shareToForeFlight(_ sender: UIButton) {
        sender.showPressed()
        var urlString = URLComponents(string: "foreflightmobile://maps/search?")!
        urlString.query = "q=\(String(describing: coordsToShare))"
        let url = urlString.url!
        UIApplication.shared.open(url , options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        presentingViewController?.dismiss(animated: true, completion: nil)
        coordsToShare = ""
    }
    
    
    @IBAction func copyToClipBoard(_ sender: UIButton) {
        sender.showPressed()
        UIPasteboard.general.string = coordsToShare
        print(coordsToShare)
        presentingViewController?.dismiss(animated: true, completion: nil)
        coordsToShare = ""

    }
    
    
    
    
    
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
