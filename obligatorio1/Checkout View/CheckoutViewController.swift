//
//  CheckoutViewController.swift
//  obligatorio1
//
//  Created by Manu on 21/4/19.
//  Copyright © 2019 Manuel Barral. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {

    // OUTLET
    @IBOutlet weak var cartCollectionView: UICollectionView!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var finalPriceLabel: UILabel!
    
    var checkoutItems: [String:CheckoutItem] = [:]
    private var finalPrice: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cartCollectionView.dataSource = self
        cartCollectionView.delegate = self
        
        // Checkout button style
        checkoutButton.layer.cornerRadius = checkoutButton.frame.size.height/2
    }
    

}

extension CheckoutViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO
        return UICollectionViewCell()
    }
    
}

extension CheckoutViewController: UICollectionViewDelegate {
    
}
