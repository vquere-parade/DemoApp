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
    
    var callToActionCategories = [ProductCategory]()
    var evoneCategories = [ProductCategory]()
    var izomeCategories = [ProductCategory]()
    
    var categories = [[ProductCategory]]()
    
    var selectedCategory: ProductCategory?
    //fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    //fileprivate let itemsPerRow: CGFloat = 2
    
    var selectedProduct: ProductCategory?

    
    override func viewDidLoad() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            //flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
            flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        }
        print("CategoryCollectionViewController")
        callToActionCategories.append(ProductText(title: "Discover Evone", text: "blablabla", segue: "shoeSegue", cellIdentifier: "fullSizeTextCell", size: 1))
        callToActionCategories.append(ProductCategory(title: "", jsonFile: nil, segue: "demoSegue", cellIdentifier: "fullSizeImageCell", image: "7-Falldemo", size: 1))

        
        evoneCategories.append(ProductPdf(title: "", segue: "pdfSegue", cellIdentifier: "halfSizeImageCell", image: "1-presentation", pdfName: "EVONE_ CES_LAS_VEGAS_JANVIER_2018", size: 2))
        evoneCategories.append(ProductVideo(title: "", segue: "playVideoSegue", cellIdentifier: "halfSizeImageCell", image: "2-video", videoName: "evone_senior_en", videoType: "mp4", size: 2))

        evoneCategories.append(ProductCategory(title: "", jsonFile: "evone", segue: "shoeSegue", cellIdentifier: "fullSizeImageCell", image: "3-evone", size: 1))
        evoneCategories.append(ProductCategory(title: "", jsonFile: "evan", segue: "shoeSegue", cellIdentifier: "fullSizeImageCell", image: "4-evan", size: 2))
        
        izomeCategories.append(ProductVideo(title: "", segue: "playVideoSegue", cellIdentifier: "fullSizeImageCell", image: "5-videoizome", videoName: "evone_tech", videoType: "mp4", size : 2))
        izomeCategories.append(ProductCategory(title: "", jsonFile: "izome", segue: "shoeSegue", cellIdentifier: "fullSizeImageCell", image: "6-packshotizome", size: 2))
        izomeCategories.append(ProductPdf(title: "Press Release", segue: "pdfSegue", cellIdentifier: "fullSizeImageCell", image: "2-video", pdfName: "PRESS_RELEASE-E-vone", size: 2))
        
        categories.append(callToActionCategories)
        categories.append(evoneCategories)
        categories.append(izomeCategories)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView( _ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        print("section: "+String(section))
        return categories[section].count
    }
    
    func collectionView( _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.categories[indexPath.section][indexPath.row]
        selectedProduct = item
        guard let cellIdentifier = selectedProduct?.cellIdentifier else {
            fatalError("the cell identifier could not be set")
        }
        if cellIdentifier == "fullSizeImageCell" {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? FullsizeImageCell else {
                fatalError("The dequeued cell is not an instance of CategoryCollectionViewCell.")
            }
            cell.layer.cornerRadius = 1;
            DispatchQueue.global(qos: .background).async {
                var image: UIImage?
                var text: String?
                image = UIImage(named: item.image!)
                text = item.title
                
                DispatchQueue.main.async {
                    cell.image.image = image
                    cell.label.text = text
                }
            }
            print("got image set")
            return cell
        } else if cellIdentifier == "halfSizeImageCell" {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? HalfsizeImageCell else {
                fatalError("The dequeued cell is not an instance of CategoryCollectionViewCell.")
            }
            cell.layer.cornerRadius = 1;
            DispatchQueue.global(qos: .background).async {
                var image: UIImage?
                var text: String?
                image = UIImage(named: item.image!)
                text = item.title
                
                DispatchQueue.main.async {
                    cell.image.image = image
                    cell.label.text = text
                }
            }
            print("got image set")
            return cell
        } else if cellIdentifier == "fullSizeTextCell" {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? FullsizeTextCell else {
                fatalError("The dequeued cell is not an instance of CategoryCollectionViewCell.")
            }
            cell.layer.cornerRadius = 3;
            cell.title.text = selectedProduct?.title
            return cell
        } else {
            fatalError("The cell identifier refers to no known identifiers")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.section][indexPath.row]
        if(selectedCategory!.segue != "playVideoSegue") {
            performSegue(withIdentifier: selectedCategory!.segue, sender: self)

        } else {
            playVideo(productVideo: (selectedCategory as? ProductVideo))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pdfSegue" {
            if let nc = segue.destination as? UINavigationController, let toViewController = nc.visibleViewController as? PdfViewController {
                toViewController.productPdf = selectedCategory as? ProductPdf
            }
        } else if segue.identifier == "shoeSegue" {
            if let toViewController = segue.destination as? ShoeTableViewController {
                toViewController.jsonFile = selectedCategory?.jsonFile
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
        let player = AVPlayer(url: movieURL)
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
            header?.headerImage.image = nil
        } else if indexPath.section == 1 {
            header?.headerImage.image = UIImage(named: "e-vone_logo")
        } else if indexPath.section == 2 {
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

