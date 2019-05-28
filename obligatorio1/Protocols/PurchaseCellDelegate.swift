//
//  PurchaseCellDelegate.swift
//  obligatorio1
//
//  Created by Manu on 28/5/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation

protocol PurchaseCellDelegate: class {
    
    /// Function performed when the user taps on the see detail button of the tableView cells
    ///
    /// - Parameter cell: cell where the button belongs
    func onDetailClick(cell: PurchaseTableViewCell)
}
