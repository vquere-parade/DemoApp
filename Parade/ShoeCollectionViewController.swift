//
//  ShoeCollectionViewController.swift
//  Parade
//
//  Created by Antoine Sauray on 29/11/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import Foundation
import UIKit

class ShoeCollectionViewController : UICollectionViewController {
    var shoes = [Shoe]()
    
    override func viewDidLoad() {
        shoes.append(Shoe())
        shoes.append(Shoe())
        shoes.append(Shoe())
        shoes.append(Shoe())
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return shoes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return shoes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shoeCollection",
                                                      for: indexPath)
        return cell
    }
}
