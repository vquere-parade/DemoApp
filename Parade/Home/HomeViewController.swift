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
    
    private var updateTask: UpdateContentTask?
    
    private var updateItemIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = (Bundle.main.infoDictionary?[kCFBundleNameKey as String] as! String)
        
        collectionView.collectionViewLayout = ColumnFlowLayout(
            cellsPerRow: 2,
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        deselectItems()
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
    
    deinit {
        updateTask?.cancel()
    }
    
    fileprivate func deselectItems() {
        // deselect menu items after a segue
        for indexPath in collectionView.indexPathsForSelectedItems ?? [] {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
    }
    private func updateContent(){
        guard updateTask == nil else {
            return
        }
        
        updateTask = UpdateContentTask()
        updateTask!.delegate = self
        
        updateTask!.execute()
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
        
        let hideActivityIndicator = updateTask == nil || updateItemIndexPath != indexPath
        cell.activityIndicator.isHidden = hideActivityIndicator
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {       
        let itemType = menuItems[indexPath.row].type
        
        switch itemType {
        case .Pitch:
            performSegue(withIdentifier: "PitchDemoSegue", sender: self)
        case .Demo:
            performSegue(withIdentifier: "ShoeDemoSegue", sender: self)
        case .PDF:
            performSegue(withIdentifier: "PDFSegue", sender: self)
        case let .Video(file, type):
            let url = URL.urlFromCacheOrBundle(forResource: file, withExtension: type)!
            
            playVideo(withURL: url)
        case .Collection:
            performSegue(withIdentifier: "CollectionSegue", sender: self)
        case let .Link(url):
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        case .Update:
            deselectItems()
            
            updateContent()
            
            updateItemIndexPath = indexPath
            
            collectionView.reloadItems(at: [updateItemIndexPath!])
            break
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

extension HomeViewController : UpdateContentTaskDelegate {
    func didSuccessUpdatingContent() {
        taskFinished(withSuccess: true)
    }
    
    func didFailUpdatingContent(error: Error) {
        taskFinished(withSuccess: false)
    }
    
    func taskFinished(withSuccess success: Bool) {
        updateTask = nil
        
        collectionView.reloadItems(at: [updateItemIndexPath!])
        
        if success {
            showToast(message: NSLocalizedString("Content updated", comment: "Toast message when the content has been updated"))
        } else {
            showToast(message: NSLocalizedString("Fail to update content", comment: "Toast message when the content couldn't be updated"))
        }
    }
}
