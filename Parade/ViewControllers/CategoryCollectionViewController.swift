//
//  ShoeCollectionViewController.swift
//  Parade
//
//  Created by Antoine Sauray on 29/11/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class CategoryCollectionViewController : UICollectionViewController {
    
    var categories = [ProductCategory]()
    var selectedCategory: ProductCategory?
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
    fileprivate let itemsPerRow: CGFloat = 2
        
    override func viewDidLoad() {
        categories.append(ProductCategory(segue: "shoeSegue", image: UIImage(named: "sample")!))
        categories.append(ProductCategory(segue: "demoSegue", image: UIImage(named: "parade")!))
        categories.append(ProductVideo(segue: "playVideoSegue", image: UIImage(named: "sample")!, videoName: "small", videoType: "mp4"))
        categories.append(ProductVideo(segue: "playVideoSegue", image: UIImage(named: "sample")!, videoName: "bunny", videoType: "mp4"))
        categories.append(ProductVideo(segue: "playVideoSegue", image: UIImage(named: "sample")!, videoName: "ElephantSeals", videoType: "mov"))
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
        selectedCategory = categories[indexPath.row]
        if(selectedCategory!.segue != "playVideoSegue") {
            performSegue(withIdentifier: selectedCategory!.segue, sender: self)

        } else {
            playVideo(productVideo: (selectedCategory as? ProductVideo))
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCategories", for: indexPath)
        headerView.backgroundColor = UIColor.blue;
        return headerView
    }

    private func playVideo(productVideo: ProductVideo?) {

        
        guard let pv = productVideo else {
            fatalError("Product Video not set")
        }
        
        let movieURL = Bundle.main.url(forResource: pv.videoName, withExtension: pv.videoType)!
        //let asset = AVURLAsset(url: movieURL, options: nil)
        let player = AVPlayer(url: movieURL)
        //let player = AVPlayer(playerItem: asset)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
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
