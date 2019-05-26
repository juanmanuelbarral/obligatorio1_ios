//
//  Utils.swift
//  obligatorio1
//
//  Created by Manu on 25/5/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    /// Function to get the indexPath of the buttons in a cell of a tableView
    ///
    /// - Parameters:
    ///   - element: element selected
    ///   - tableView: tableView where the element is
    /// - Returns: the IndexPath of said element in the tableView
    static func getIndexPath(of element: Any, tableView: UITableView) -> IndexPath?
    {
        if let view =  element as? UIView
        {
            // Converting to table view coordinate system
            let pos = view.convert(CGPoint.zero, to: tableView)
            // Getting the index path according to the converted position
            return tableView.indexPathForRow(at: pos)
        }
        return nil
    }
    
    /// Function that updates the title in the navigation top bar
    /// Large title = true for the checkout screen
    static func updateNavigationTitle(element: UIViewController, title: String, prefersLargeTitles: Bool) {
        // Large title
        element.title = title
        if #available(iOS 11.0, *) {
            element.navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        }
        element.navigationController?.navigationBar.backgroundColor = UIColor(red: 249, green: 249, blue: 249, alpha: 1)
    }
    
    static func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
