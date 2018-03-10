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
import Alamofire

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
        callToActionCategories.append(ProductText(title: "Découvrez Evone", text: "Evone est une chaussure connectée qui détecte votre chute. Elle a été crée pour garantir la sécurité des personnes âgées.", segue: "shoeSegue", cellIdentifier: "fullSizeTextCell", size: 1))
        
        callToActionCategories.append(ProductCategory(title: "", jsonFile: nil, segue: "demoSegue", cellIdentifier: "fullSizeImageCell", image: "7-Falldemo", size: 1))
        
        callToActionCategories.append(ProductText(title: "Nos technologies", text: "", segue: "", cellIdentifier: "fullSizeTextCell", size: 1))
       
        callToActionCategories.append(ProductPdf(title: "", segue: "pdfSegue", cellIdentifier: "halfSizeImageCell", image: "1-presentation", pdfName: "EVONE_ CES_LAS_VEGAS_JANVIER_2018", size: 2))
       
        callToActionCategories.append(ProductVideo(title: "", segue: "playVideoSegue", cellIdentifier: "halfSizeImageCell", image: "2-video", videoName: "evone_senior_en", videoType: "mp4", size: 2))
        
        callToActionCategories.append(ProductText(title: "Nos Modèles", text: "Homme et Femme, vous pourrez trouver chaussure à votre pied", segue: "", cellIdentifier: "fullSizeTextCell", size: 1))
        
        callToActionCategories.append(ProductCategory(title: "", jsonFile: "evone", segue: "shoeSegue", cellIdentifier: "halfSizeImageCell", image: "3-evone", size: 1))
        callToActionCategories.append(ProductCategory(title: "", jsonFile: "evan", segue: "shoeSegue", cellIdentifier: "halfSizeImageCell", image: "4-evan", size: 2))
        
        callToActionCategories.append(ProductText(title: "Gamme Izome", text: "La technologie de détection de chute intégrée aux chaussures de travail", segue: "", cellIdentifier: "fullSizeTextCell", size: 1))
        callToActionCategories.append(ProductVideo(title: "", segue: "playVideoSegue", cellIdentifier: "halfSizeImageCell", image: "5-videoizome", videoName: "evone_tech", videoType: "mp4", size : 2))
        callToActionCategories.append(ProductCategory(title: "", jsonFile: "izome", segue: "shoeSegue", cellIdentifier: "halfSizeImageCell", image: "6-packshotizome", size: 2))
        callToActionCategories.append(ProductPdf(title: "Press Release", segue: "pdfSegue", cellIdentifier: "fullSizeImageCell", image: "2-video", pdfName: "PRESS_RELEASE-E-vone", size: 2))
        
        categories.append(callToActionCategories)
        //categories.append(evoneCategories)
        //categories.append(izomeCategories)
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
            var image: UIImage?
            var text: String?
            image = UIImage(named: item.image!)
            text = item.title
            cell.image.image = image
            cell.label.text = text
            /*
            DispatchQueue.global(qos: .background).async {
                
                
                DispatchQueue.main.async {
                    
                }
            }
 */
            return cell
        } else if cellIdentifier == "halfSizeImageCell" {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? HalfsizeImageCell else {
                fatalError("The dequeued cell is not an instance of CategoryCollectionViewCell.")
            }
            cell.layer.cornerRadius = 1;
            var image: UIImage?
            var text: String?
            image = UIImage(named: item.image!)
            text = item.title
            cell.image.image = image
            cell.label.text = text
            /*
            DispatchQueue.global(qos: .background).async {
                
                
                DispatchQueue.main.async {
                    
                }
            }
             */
            return cell
        } else if cellIdentifier == "fullSizeTextCell" {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? FullsizeTextCell else {
                fatalError("The dequeued cell is not an instance of CategoryCollectionViewCell.")
            }
            cell.layer.cornerRadius = 3;
            cell.title.text = selectedProduct?.title
            cell.body.text = (selectedProduct as! ProductText).text
            return cell
        } else {
            fatalError("The cell identifier refers to no known identifiers")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.section][indexPath.row]
        if(selectedCategory!.segue != nil && selectedCategory!.segue != "playVideoSegue") {
            if(selectedCategory!.segue == "demoSegue") {
                let userDefaults = UserDefaults.standard
                let caretakerEmail = userDefaults.string(forKey: "caretaker_email")
                let caretakerPassword = userDefaults.string(forKey: "caretaker_password")
                
                if let email = caretakerEmail, let password = caretakerPassword {
                    signInAndPerformSegue(email: email, password: password)
                } else {
                    displayActionsDialog()
                }
            } else {
                performSegue(withIdentifier: selectedCategory!.segue!, sender: self)
            }
        } else if (selectedCategory!.segue == "playVideoSegue"){
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
        //super.viewWillTransition(to: size, with: coordinator)
        //collectionView.collectionViewLayout.invalidateLayout()
        /*
        coordinator.animate(alongsideTransition: { (_) in
            NotificationCenter.default.post(name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        }, completion: nil)
         */
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
        super.viewWillTransition(to: size, with: coordinator)
        //collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    func displaySignInDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Connection à un compte Caretaker", message: "Entrez vos identifiants", preferredStyle: .alert)
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Valider", style: .default) { (_) in
            
            //getting the input values from user
            if let email = alertController.textFields?[0].text, let password = alertController.textFields?[1].text {
                self.signInAndPerformSegue(email: email, password: password)
            }
           
        }
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Nom d'utilisateur"
        }
        alertController.addTextField { (textField) in
            textField.isSecureTextEntry = true
            textField.placeholder = "Mot de passe"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayActionsDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Un compte Caretaker est requis", message: "Afin de tester la détection de chute, un compte Caretaker est requis", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Se connecter", style: .default, handler: { (action) -> Void in
            print("Se connecter")
            self.displaySignInDialog()
        })
        let action2 = UIAlertAction(title: "S'inscrire", style: .default, handler: { (action) -> Void in
            print("S'inscrire")
            self.performSegue(withIdentifier: "signupSegue", sender: self)
        })
        // Cancel button
        let cancel = UIAlertAction(title: "Annuler", style: .destructive, handler: { (action) -> Void in })
        // Add action buttons and present the Alert
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func signInAndPerformSegue(email: String, password: String) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        let parameters: Parameters = ["email": email, "password": password, "audience": "customer"]
        Alamofire.request("https://authentication-dot-parade-194715.appspot.com/authenticate/caretaker", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            UIViewController.removeSpinner(spinner: sv)
            if(response.response?.statusCode == 200) {
                //self.labelMessage.text = "Name: " + name! + "Email: " + email!
                let userDefaults = UserDefaults.standard
                userDefaults.set(email, forKey: "caretaker_email")
                userDefaults.set(password, forKey: "caretaker_password")
                self.performSegue(withIdentifier: "demoSegue", sender: self)
            } else {
                let alert = UIAlertController(title: "Echec de la connection", message: "Vos identifiants sont incorrects", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) -> Void in })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
