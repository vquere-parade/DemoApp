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
    
    var evoneCategories = [ProductCategory]()
    var izomeCategories = [ProductCategory]()
    var selectedCategory: ProductCategory?
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
    //fileprivate let itemsPerRow: CGFloat = 2

    
    override func viewDidLoad() {
        print("CategoryCollectionViewController")
        evoneCategories.append(ProductCategory(title: "", subTitle: "", segue: "shoeSegue", cellIdentifier: "imageCategoryCell", image: "1"))
        evoneCategories.append(ProductCategory(title: "Demo", subTitle: "Fall detection system blablablablablabla",  segue: "demoSegue", cellIdentifier: "textCategoryCell", image: "2"))
        evoneCategories.append(ProductVideo(title: "", subTitle: "", segue: "playVideoSegue", cellIdentifier: "imageCategoryCell", image: "3", videoName: "evone", videoType: "mp4"))
        
        izomeCategories.append(ProductCategory(title: "", subTitle: "", segue: "shoeSegue", cellIdentifier: "imageCategoryCell", image: "4"))
        izomeCategories.append(ProductCategory(title: "", subTitle: "", segue: "demoSegue", cellIdentifier: "imageCategoryCell", image: "5"))
        izomeCategories.append(ProductCategory(title: "", subTitle: "", segue: "demoSegue", cellIdentifier: "imageCategoryCell", image: "6"))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView( _ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        print("section: "+String(section))
        if section == 0 {
            return evoneCategories.count
        } else if section == 1 {
            return izomeCategories.count
        } else {
            return 0
        }
    }
    
    func collectionView( _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var productCategory : ProductCategory? =  nil
        if indexPath.section == 0 {
            productCategory = self.evoneCategories[indexPath.row]
        } else if indexPath.section == 1 {
            productCategory = self.izomeCategories[indexPath.row]
        } else {
            fatalError("Cell identifier not found")
        }
        guard let cellIdentifier = productCategory?.cellIdentifier else {
            fatalError("the cell identifier could not be set")
        }
        
        if cellIdentifier == "imageCategoryCell" {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ImageCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of CategoryCollectionViewCell.")
            }
            cell.viewBG.layer.borderWidth = 1
            cell.viewBG.layer.borderColor = UIColor.gray.cgColor
            
            DispatchQueue.global(qos: .background).async {
                if indexPath.section == 0 {
                    let image = UIImage(named: self.evoneCategories[indexPath.row].image)
                    DispatchQueue.main.async {
                            cell.categoryImageView.image = image
                    }
                } else if indexPath.section == 1 {
                    let image = UIImage(named: self.izomeCategories[indexPath.row].image)
                    DispatchQueue.main.async {cell.categoryImageView.image = image}
                }
            }
            return cell
        } else if cellIdentifier == "textCategoryCell" {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TextCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of CategoryCollectionViewCell.")
            }
            cell.viewBG.layer.borderWidth = 1
            cell.viewBG.layer.borderColor = UIColor.gray.cgColor
            
            cell.titleLabel.text = productCategory?.title
            cell.subtitleLabel.text = productCategory?.subTitle
            return cell
        } else {
            fatalError("The cell identifier refers to no known identifiers")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedCategory = evoneCategories[indexPath.row]
        } else if indexPath.section == 1 {
            selectedCategory = izomeCategories[indexPath.row]
        }
        
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
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "categoryHeader", for: indexPath)
        if indexPath.section == 0 {
            
        } else if indexPath.section == 1 {
            
        }
        return header
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

