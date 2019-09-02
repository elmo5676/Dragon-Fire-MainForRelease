//
//  PreFlightViewController.swift
//  Dragon Fire
//
//  Created by elmo on 6/15/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import KML

class KMLViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "bullsEyeKML")
        self.currentDetailViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentDetailViewController!)
        self.addSubview(subView: self.currentDetailViewController!.view, toView: self.detailContainerView)
        

        versionLabel.text = "Version: \(buildNumber)"
        icon.layer.cornerRadius = (icon.frame.width)/10
        icon.layer.borderWidth = 1
        icon.layer.borderColor = #colorLiteral(red: 0.8462253213, green: 0.8463678956, blue: 0.8462066054, alpha: 1)
        setSelectedButtonUIView(view: bullsEyeView)
    }
    
    
    @IBOutlet weak var scrapButton: UIButton!
    @IBAction func scrapButton(_ sender: UIButton) {
        menuWidthConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
    
    @IBOutlet weak var menuWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailContainerView: UIView!
    weak var currentDetailViewController: UIViewController?
    
    @IBOutlet weak var bullsEyeKMLButtonButtonOutlet: UIButton!
    @IBAction func bullsEyeKMLButton(_ sender: UIButton) {
        changeChildViewTo("bullsEyeKML")
        setSelectedButtonUIView(view: bullsEyeView)
    }
    @IBOutlet weak var divertKMLButtonOutlet: UIButton!
    @IBAction func divertKMLButton(_ sender: UIButton) {
        changeChildViewTo("divertKML")
        setSelectedButtonUIView(view: divertView)
    }
    @IBOutlet weak var pathKMLButtonOutlet: UIButton!
    @IBAction func pathKMLButton(_ sender: UIButton) {
        changeChildViewTo("pathKmlAnnotations")
        setSelectedButtonUIView(view: pathView)
//        pathKmlAnnotations
    }
    @IBOutlet weak var ringKMLButtonOutlet: UIButton!
    @IBAction func ringKMLButton(_ sender: UIButton) {
        changeChildViewTo("ringKML")
        setSelectedButtonUIView(view: ringView)
    }
    @IBOutlet weak var placeMarkKMLButtonOutlet: UIButton!
    @IBAction func placeMarkKMLButton(_ sender: UIButton) {
        changeChildViewTo("placeMarkKML")
        setSelectedButtonUIView(view: placeMarkView)
    }
    @IBOutlet weak var importedKMLButtonOutlet: UIButton!
    @IBAction func importedKMLButton(_ sender: UIButton) {
        changeChildViewTo("underConstruction")
        setSelectedButtonUIView(view: importedView)
    }
    @IBOutlet weak var baseLineKMLButtonOutlet: UIButton!
    @IBAction func baseLineKMLButtonButton(_ sender: UIButton!) {
        changeChildViewTo("baseLineKML")
        setSelectedButtonUIView(view: baselineView)
    }
    
    
    // MARK: - Outlets
    @IBOutlet var buttonViewCollection: [UIView]!
    @IBOutlet weak var bullsEyeView: UIView!
    @IBOutlet weak var divertView: UIView!
    @IBOutlet weak var pathView: UIView!
    @IBOutlet weak var ringView: UIView!
    @IBOutlet weak var placeMarkView: UIView!
    @IBOutlet weak var importedView: UIView!
    @IBOutlet weak var baselineView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var versionLabel: UILabel!
    
    // MARK: - Variables
    let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

    func changeChildViewTo(_ identifier: String) {
        //For currentDetailView
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: identifier)
        newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(oldViewController: self.currentDetailViewController!, toViewController: newViewController!)
        self.currentDetailViewController = newViewController
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(subView: newViewController.view, toView: self.detailContainerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.0, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
        },
                       completion: { finished in
                        oldViewController.view.removeFromSuperview()
                        oldViewController.removeFromParentViewController()
                        newViewController.didMove(toParentViewController: self)
        })
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func setSelectedButtonUIView(view: UIView) {
        for v in buttonViewCollection {
            v.layer.backgroundColor = #colorLiteral(red: 0.2090960145, green: 0.2608240247, blue: 0.3308929205, alpha: 1)
        }
        view.layer.backgroundColor = #colorLiteral(red: 0.1542099416, green: 0.1922906637, blue: 0.243974179, alpha: 1)
    }
}






















