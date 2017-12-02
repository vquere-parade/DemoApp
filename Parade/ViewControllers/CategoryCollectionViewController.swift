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

class CategoryCollectionViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categories = [ProductCategory]()
    var selectedCategory: ProductCategory?
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
    //fileprivate let itemsPerRow: CGFloat = 2

    
    override func viewDidLoad() {
        categories.append(ProductCategory(segue: "shoeSegue", image: UIImage(named: "sample")!))
        categories.append(ProductCategory(segue: "demoSegue", image: UIImage(named: "ic_explore_48pt")!))
        categories.append(ProductVideo(segue: "playVideoSegue", image: UIImage(named: "sample")!, videoName: "small", videoType: "mp4"))
        categories.append(ProductVideo(segue: "playVideoSegue", image: UIImage(named: "sample")!, videoName: "bunny", videoType: "mp4"))
        categories.append(ProductVideo(segue: "playVideoSegue", image: UIImage(named: "sample")!, videoName: "ElephantSeals", videoType: "mov"))
        categories.append(ProductVideo(segue: "playVideoSegue", image: UIImage(named: "sample")!, videoName: "ElephantSeals", videoType: "mov"))
        categories.append(ProductVideo(segue: "playVideoSegue", image: UIImage(named: "sample")!, videoName: "ElephantSeals", videoType: "mov"))
    }
    
    func collectionView(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView( _ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView( _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionCell", for: indexPath) as? CategoryCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of CategoryCollectionViewCell.")
        }
        cell.categoryImageView.image = categories[indexPath.row].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
        if(selectedCategory!.segue != "playVideoSegue") {
            performSegue(withIdentifier: selectedCategory!.segue, sender: self)

        } else {
            playVideo(productVideo: (selectedCategory as? ProductVideo))
        }
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "categoryHeader", for: indexPath) as! UICollectionReusableView
    }
    

    /*
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        collectionViewLayout.invalidateLayout()
    }
 */
}

extension CategoryCollectionViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.orientation.isLandscape {
            let itemsPerRow : CGFloat = 3
            let availableWidth = view.bounds.width - (sectionInsets.left * (itemsPerRow + 1))
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem, height: widthPerItem)
        } else {
            let itemsPerRow : CGFloat = 2
            let availableWidth = view.bounds.width - (sectionInsets.left * (itemsPerRow + 1))
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem, height: widthPerItem)
        }
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

