//
//  UIViewControllerExtensions.swift
//  T38
//
//  Created by elmo on 5/27/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func passToShareSheet(fileName: String, ext: String, stringToWriteToFile: String){
        let fileName = "\(fileName).\(ext)"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        do {
            try stringToWriteToFile.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            let vc = UIActivityViewController(activityItems: [path as Any], applicationActivities: [])
            vc.popoverPresentationController?.sourceView = self.view
            print("Success")
            present(vc, animated: true, completion: nil)
            print(stringToWriteToFile)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func passToShareSheetWithfileNamePopupWith(placeHolder: String, ext: String, stingToWrite: String) {
        //Alert for naming the file:
        var fileNameTextField: UITextField?
        func fileNameTextField_(textField: UITextField!) {
            fileNameTextField = textField
            fileNameTextField?.placeholder = placeHolder
        }
        func okHandler(alert: UIAlertAction!) {
            var overlayFileName = placeHolder
            if fileNameTextField?.text == "" || fileNameTextField?.text == nil {
                overlayFileName = placeHolder
            } else {
                overlayFileName = (fileNameTextField?.text)!
            }
            self.passToShareSheet(fileName: overlayFileName, ext: ext, stringToWriteToFile: stingToWrite)
        }
        func alertControllerName() {
            let alertController = UIAlertController(title: "Overlay Name",
                                                    message: "Enter a name for the file to be exported to ForeFlight",
                                                    preferredStyle: .alert)
            alertController.addTextField(configurationHandler: fileNameTextField_)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: okHandler)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
        alertControllerName()
    }
    
    
    
    
    
    
}
