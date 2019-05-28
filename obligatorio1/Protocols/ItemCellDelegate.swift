//
//  ItemCellProtocol.swift
//  obligatorio1
//
//  Created by Manu on 28/5/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import Foundation

protocol ItemCellDelegate: class {
    
    /// Function performed when the user taps on the add button of the tableView cells
    ///
    /// - Parameter cell: cell where the button was tapped (contains product and quantity)
    func onAddButtonClick(cell: ItemTableViewCell)
    
    /// Function performed when the user taps on the plus button of the tableView cells
    ///
    /// - Parameter cell: cell where the button was tapped (contains product and quantity)
    func onPlusButtonClick(cell: ItemTableViewCell)
    
    /// Function performed when the user taps on the minus button of the tableView cells
    ///
    /// - Parameter cell: cell where the button was tapped (contains product and quantity)
    func onMinusButtonClick(cell: ItemTableViewCell)
}
