//
//  BannerCollectionViewCell.swift
//  obligatorio1
//
//  Created by Manu on 21/4/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    
    // OUTLETS
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var bannerTextLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    /// Function that configures the cell with its needed information
    ///
    /// - Parameter banner: banner object to be reflected on the cell
    func configCell(banner: BannerItem) {
        bannerImageView.image = UIImage(named: banner.image)
        bannerImageView.layer.cornerRadius = 5
        nameLabel.text = banner.name
    }
    
}
