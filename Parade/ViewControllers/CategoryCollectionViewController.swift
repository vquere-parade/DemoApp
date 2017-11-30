//
//  ShoeCollectionViewController.swift
//  Parade
//
//  Created by Antoine Sauray on 29/11/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import Foundation
import UIKit

class CategoryCollectionViewController : UICollectionViewController {
    
    var categories = [ProductCategory]()
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate let itemsPerRow: CGFloat = 2
        
    override func viewDidLoad() {
        categories.append(ProductCategory(segue: "shoeSegue", image: UIImage(named: "sample")!))
        categories.append(ProductCategory(segue: "demoSegue", image: UIImage(named: "parade")!))
        categories.append(ProductCategory(segue: "demoSegue", image: UIImage(named: "sample")!))
        categories.append(ProductCategory(segue: "demoSegue", image: UIImage(named: "parade")!))
        categories.append(ProductCategory(segue: "demoSegue", image: UIImage(named: "sample")!))
        categories.append(ProductCategory(segue: "demoSegue", image: UIImage(named: "parade")!))

    }
    
    func collectionView(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionCell", for: indexPath) as? CategoryCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of CategoryCollectionViewCell.")
        }
        cell.categoryImageView.image = categories[indexPath.row].image
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.item]
        performSegue(withIdentifier: category.segue, sender: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCategories", for: indexPath)
        headerView.backgroundColor = UIColor.blue;
        return headerView
    }

}

extension CategoryCollectionViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
