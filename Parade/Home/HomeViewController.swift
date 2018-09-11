//
//  ShoeCollectionViewController.swift
//  Parade
//
//  Created by Antoine Sauray on 29/11/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let menuItems = [
        MenuItem(
            title: NSLocalizedString("Elevator Pitch", comment: "Elevator Pitch menu item"),
            image: UIImage(named: "pitch")!,
            imageHighlight: UIImage(named: "pitch_highlight")!,
            type: .Pitch
        ),
        MenuItem(
            title: NSLocalizedString("Shoe Demo", comment: "Shoe Demo menu item"),
            image: UIImage(named: "demo")!,
            imageHighlight: UIImage(named: "demo_highlight")!,
            type: .Demo
        ),
        MenuItem(
            title: NSLocalizedString("Presentation", comment: "Presentation menu item"),
            image: UIImage(named: "presentation")!,
            imageHighlight: UIImage(named: "presentation_highlight")!,
            type: .PDF(file: "EVONE_ CES_LAS_VEGAS_JANVIER_2018")
        ),
        MenuItem(
            title: NSLocalizedString("Video", comment: "Video menu item"),
            image: UIImage(named: "video")!,
            imageHighlight: UIImage(named: "video_highlight")!,
            type: .Video(file: "evone_senior_en", type: "mp4")
        ),
        MenuItem(
            title: NSLocalizedString("Collection Women", comment: "Collection Women menu item"),
            image: UIImage(named: "collection_women")!,
            imageHighlight: UIImage(named: "collection_women_highlight")!,
            type: .Collection(file: "evone")
        ),
        MenuItem(
            title: NSLocalizedString("Collection Men", comment: "Collection Men menu item"),
            image: UIImage(named: "collection_men")!,
            imageHighlight: UIImage(named: "collection_men_highlight")!,
            type: .Collection(file: "evan")
        ),
        MenuItem(
            title: NSLocalizedString("Technology Deck", comment: "Technology Deck menu item"),
            image: UIImage(named: "technology")!,
            imageHighlight: UIImage(named: "technology_highlight")!,
            type: .PDF(file: "")
        ),
        MenuItem(
            title: NSLocalizedString("Press Release", comment: "Press Release menu item"),
            image: UIImage(named: "press")!,
            imageHighlight: UIImage(named: "press_highlight")!,
            type: .PDF(file: "PRESS_RELEASE-E-vone")
        ),
        MenuItem(
            title: NSLocalizedString("Website Link", comment: "Website Link menu item"),
            image: UIImage(named: "website")!,
            imageHighlight: UIImage(named: "website_highlight")!,
            type: .Link(url: "http://e-vone.com/")
        ),
        MenuItem(
            title: NSLocalizedString("Update Data", comment: "Update Data menu item"),
            image: UIImage(named: "update")!,
            imageHighlight: UIImage(named: "update_highlight")!,
            type: .Update
        ),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = ColumnFlowLayout(
            cellsPerRow: 2,
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // deselect menu items after a segue
        for indexPath in collectionView.indexPathsForSelectedItems ?? [] {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedItemIndex = collectionView.indexPathsForSelectedItems![0].row
        let item = menuItems[selectedItemIndex]
        
        switch segue.identifier {
        case "PDFSegue":
            guard case let .PDF(file) = item.type else {
                preconditionFailure("Item type should be .PDF.")
            }
            
            let viewController = segue.destination as! PdfViewController
            viewController.productPdf = file
            viewController.title = item.title
        case "CollectionSegue":
            guard case let .Collection(file) = item.type else {
                preconditionFailure("Item type should be .Collection.")
            }
            
            let viewController = segue.destination as! ShoeTableViewController
            viewController.jsonFile = file
            viewController.title = item.title
        default:
            break
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView( _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = menuItems[indexPath.row]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        cell.backgroundImage.image = item.image
        cell.backgroundImage.highlightedImage = item.imageHighlight
        cell.backgroundImage.isHighlighted = false
        
        cell.title.text = item.title
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {       
        let itemType = menuItems[indexPath.row].type
        
        switch itemType {
        case .Pitch:
            performSegue(withIdentifier: "DemoSegue", sender: self)
        case .Demo:
            performSegue(withIdentifier: "DemoSegue", sender: self)
        case .PDF:
            performSegue(withIdentifier: "PDFSegue", sender: self)
        case let .Video(file, type):
            let url = Bundle.main.url(forResource: file, withExtension: type)!
            
            playVideo(withURL: url)
        case .Collection:
            performSegue(withIdentifier: "CollectionSegue", sender: self)
        case let .Link(url):
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        case .Update:
            performSegue(withIdentifier: "DemoSegue", sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HomeCell
        cell.backgroundImage.isHighlighted = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HomeCell
        cell.backgroundImage.isHighlighted = false
    }
    
    private func playVideo(withURL url: URL) {
        let player = AVPlayer(url: url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        
        present(playerController, animated: true) {
            player.play()
        }
    }
}
