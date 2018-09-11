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
        MenuItem(title: NSLocalizedString("Elevator Pitch", comment: "Elevator Pitch menu item"), type: .Pitch),
        MenuItem(title: NSLocalizedString("Shoe Demo", comment: "Shoe Demo menu item"), type: .Demo),
        MenuItem(title: NSLocalizedString("Presentation", comment: "Presentation menu item"), type: .PDF(file: "EVONE_ CES_LAS_VEGAS_JANVIER_2018")),
        MenuItem(title: NSLocalizedString("Video", comment: "Video menu item"), type: .Video(file: "evone_senior_en", type: "mp4")),
        MenuItem(title: NSLocalizedString("Collection Women", comment: "Collection Women menu item"), type: .Collection(file: "evone")),
        MenuItem(title: NSLocalizedString("Collection Men", comment: "Collection Men menu item"), type: .Collection(file: "evan")),
        MenuItem(title: NSLocalizedString("Technology Deck", comment: "Technology Deck menu item"), type: .PDF(file: "")),
        MenuItem(title: NSLocalizedString("Press Release", comment: "Press Release menu item"), type: .PDF(file: "PRESS_RELEASE-E-vone")),
        MenuItem(title: NSLocalizedString("Website Link", comment: "Website Link menu item"), type: .Link(url: "http://e-vone.com/")),
        MenuItem(title: NSLocalizedString("Update Data", comment: "Update Data menu item"), type: .Update),
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
    
    private func playVideo(withURL url: URL) {
        let player = AVPlayer(url: url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        
        present(playerController, animated: true) {
            player.play()
        }
    }
}
