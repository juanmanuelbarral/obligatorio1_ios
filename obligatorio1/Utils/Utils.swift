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
    
    private var container: UIView = UIView()
    private var loadingView: UIView = UIView()
    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    init() {}
    
    /// Function to get the indexPath of the buttons in a cell of a tableView
    ///
    /// - Parameters:
    ///   - element: element selected
    ///   - tableView: tableView where the element is
    /// - Returns: the IndexPath of said element in the tableView
    func getIndexPath(of element: Any, tableView: UITableView) -> IndexPath?
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
    func updateNavigationTitle(element: UIViewController, title: String, prefersLargeTitles: Bool) {
        // Large title
        element.title = title
        if #available(iOS 11.0, *) {
            element.navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        }
        element.navigationController?.navigationBar.backgroundColor = UIColor(red: 249, green: 249, blue: 249, alpha: 1)
    }
    
    
    /// Show customized activity indicator,actually add activity indicator to passing view
    ///
    /// - Parameter uiView: add activity indicator to this view
    func showActivityIndicatory(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3) //black
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(red: 68, green: 68, blue: 68, alpha: 0.7) //gray
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        activityIndicator.style =
            UIActivityIndicatorView.Style.gray
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    
    /// Hide activity indicator
    /// Actually remove activity indicator from its super view
    ///
    /// - Parameter uiView: remove activity indicator from this view
    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
}
