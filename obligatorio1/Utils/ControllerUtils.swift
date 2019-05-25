//
//  ControllerUtils.swift
//  obligatorio1
//
//  Created by Manu on 25/5/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation
import UIKit

class ControllerUtils {
    
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
}
