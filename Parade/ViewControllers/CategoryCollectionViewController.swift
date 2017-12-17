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
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    //fileprivate let itemsPerRow: CGFloat = 2
    
    var selectedProduct: ProductCategory?

    
    override func viewDidLoad() {
        print("CategoryCollectionViewController")
        evoneCategories.append(ProductCategory(title: "EVone Products", info: "Evone", segue: "shoeSegue", cellIdentifier: "imageCategoryCell", image: "1"))
        evoneCategories.append(ProductCategory(title: "Fall demo", info: "",  segue: "demoSegue", cellIdentifier: "imageCategoryCell", image: "fall"))
        evoneCategories.append(ProductVideo(title: "Video", info: "", segue: "playVideoSegue", cellIdentifier: "imageCategoryCell", image: "cloud", videoName: "evone_new", videoType: "mp4"))
        evoneCategories.append(ProductCategory(title: "EVan Products", info: "Evan", segue: "shoeSegue", cellIdentifier: "imageCategoryCell", image: "9"))
        
        izomeCategories.append(ProductPdf(title: "Communiqué de presse", info: "This is a PDF", segue: "pdfSegue", cellIdentifier: "imageCategoryCell", image: "4", pdfName: "ANALYSE-DATAVIZ-AZZOUG-SAURAY"))
        izomeCategories.append(ProductCategory(title: "Izome Products", info: "Izome", segue: "shoeSegue", cellIdentifier: "imageCategoryCell", image: "DSC_9396"))
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
        
        if indexPath.section == 0 {
            selectedProduct = self.evoneCategories[indexPath.row]
        } else if indexPath.section == 1 {
            selectedProduct = self.izomeCategories[indexPath.row]
        } else {
            fatalError("Cell identifier not found")
        }
        guard let cellIdentifier = selectedProduct?.cellIdentifier else {
            fatalError("the cell identifier could not be set")
        }
        
        if cellIdentifier == "imageCategoryCell" {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ImageCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of CategoryCollectionViewCell.")
            }
            cell.layer.cornerRadius = 7;
            cell.layer.masksToBounds = true;
            //cell.viewBG.layer.borderWidth = 1
            //cell.viewBG.layer.borderColor = UIColor.gray.cgColor
            
            DispatchQueue.global(qos: .background).async {
                var image: UIImage?
                var text: String?
                if indexPath.section == 0 {
                    image = UIImage(named: self.evoneCategories[indexPath.row].image)
                    text = self.evoneCategories[indexPath.row].title
                    
                } else if indexPath.section == 1 {
                    image = UIImage(named: self.izomeCategories[indexPath.row].image)
                    text = self.izomeCategories[indexPath.row].title
                }
                
                DispatchQueue.main.async {
                    cell.categoryImageView.image = image
                    //cell.categoryImageView.image = cell.categoryImageView.image?.withRenderingMode(.alwaysTemplate)
                    //cell.categoryImageView.tintColor = UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 0.8)
                    let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.dark)
                    // 2
                    let blurView = CustomIntensityVisualEffectView(effect: darkBlur, intensity: CGFloat(0.3))
                    blurView.frame = cell.categoryImageView.bounds
                    blurView.tag = 100
                    // 3
                    if let oldView = cell.categoryImageView.viewWithTag(100) {
                        oldView.removeFromSuperview()
                    }
                    cell.categoryImageView.addSubview(blurView)
                    cell.categoryLabel.text = text
                }
            }
            return cell
        } else if cellIdentifier == "textCategoryCell" {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? TextCollectionViewCell else {
                fatalError("The dequeued cell is not an instance of CategoryCollectionViewCell.")
            }
            cell.layer.cornerRadius = 7;
            cell.layer.masksToBounds = true;
            cell.viewBG.layer.borderWidth = 1
            cell.viewBG.layer.borderColor = UIColor.gray.cgColor
            
            cell.titleLabel.text = selectedProduct?.title
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pdfSegue" {
            if let toViewController = segue.destination as? PdfViewController {
                toViewController.productPdf = selectedProduct as? ProductPdf
            }
        } else if segue.identifier == "shoeSegue" {
            if let toViewController = segue.destination as? ShoeTableViewController {
                toViewController.shoeCategory = selectedCategory?.info
            }
        }
    }

    private func playVideo(productVideo: ProductVideo?) {
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
        guard let pv = productVideo else {
            fatalError("Product Video not set")
        }
        print(pv.videoName)
        print(pv.videoType)
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
        //collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "categoryHeader", for: indexPath) as? HeaderReusableView
        if indexPath.section == 0 {
            header?.headerImage.image = UIImage(named: "e-vone_logo")
            
        } else if indexPath.section == 1 {
            header?.headerImage.image = UIImage(named: "izome_logo")
        }
        if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            header?.layoutMargins.left = 10
            header?.layoutMargins.right = 100
            header?.layoutMargins.top = 10
            header?.layoutMargins.bottom = 100
        } else {
            header?.layoutMargins.left = 30
            header?.layoutMargins.right = 100
            header?.layoutMargins.top = 30
            header?.layoutMargins.bottom = 100
        }
        return header!
    }
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

