//
//  UITableViewExtensions.swift
//  T38
//
//  Created by elmo on 5/27/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import Foundation
import UIKit


public extension UITableView {
    
    /**
     This method returns the indexPath of the cell that contains the specified view
     
     - Parameter view: The view to find.
     
     - Returns: The indexPath of the cell containing the view, or nil if it can't be found
     
     */
    //This is used in the RunwayChoicesTableViewController to get the indexPath for the button pressed in the runway cell
    func indexPathForView(_ view: UIView) -> IndexPath? {
        let center = view.center
        let viewCenter = self.convert(center, from: view.superview)
        let indexPath = self.indexPathForRow(at: viewCenter)
        return indexPath
    }
}
