//
//  DemoViewController.swift
//  Parade
//
//  Created by Antoine Sauray on 30/11/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit
import AudioToolbox
import AVFoundation
import SwiftyJSON
import Alamofire

class DemoViewController : ViewController {
    
    
    @IBOutlet weak var container: UIView!
    var motionManager: CMMotionManager!
    var vibration : Bool = false
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var fallImage: UIImageView!
    
    let queue = DispatchQueue(label: "animationQueue", qos: .background)
    var circle : CircleView?
    
    override func viewDidLoad() {
        
        let userDefaults = UserDefaults.standard
        let id = userDefaults.string(forKey: "id")
        let key = userDefaults.string(forKey: "key")
        
        if id == nil || key == nil {
            showInputDialog()
        }
        
        DispatchQueue.global(qos: .background).async {
            var keepGoing = true
            while keepGoing {
                if self.vibration {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    self.toggleTorch(on: true)
                } else {
                    self.toggleTorch(on: false)
                }
                DispatchQueue.main.async {
                    if self.viewIfLoaded?.window == nil {
                        keepGoing = false
                        self.toggleTorch(on: false)
                    }
                }
                if keepGoing {
                    sleep(1)
                }
                
            }
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.orientationChanged),
            name: .UIDeviceOrientationDidChange,
            object: nil)

        
        blur()
        animate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func animate() {
        //circles.append(CircleView(frame: CGRect(x: 0, y: 0, width: 40, height: 40)))
        //circles.append(CircleView(frame: CGRect(x: 0, y: 0, width: 30, height: 30)))
        circle = CircleView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.circle?.center = view.center
        self.view?.addSubview(circle!)
        var size = self.view.frame.width * 0.9
        if self.view.frame.height < size {
            size = self.view.frame.height * 0.9
        }
        queue.async {
            while true {
                DispatchQueue.main.async {
                    self.circle?.resizeCircleWithPulseAinmation(size, duration: 1.0)
                }
                sleep(1)
            }
        }
    }
    
    func blur() {
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        // 2
        let blurView = CustomIntensityVisualEffectView(effect: darkBlur, intensity: CGFloat(0.5))
        blurView.frame = view.bounds
        blurView.tag = 101
        if let oldView = fallImage.viewWithTag(101) {
            oldView.removeFromSuperview()
        }
        // 3
        fallImage.addSubview(blurView)
    }
    @objc func orientationChanged(notification: NSNotification) {
        
        if UIDevice.current.orientation == UIDeviceOrientation.faceDown {
            print("face down")
            vibration = true
            // trigger the fall event
            let userDefaults = UserDefaults.standard
            let id = userDefaults.string(forKey: "id")
            let key = userDefaults.string(forKey: "key")
            if id != nil && key != nil {
                let endpoint = Bundle.main.infoDictionary!["FAKE_FALL_ENDPOINT"] as! String
                Alamofire.request(endpoint, method: .post, parameters: ["id": id!, "key": key!], encoding: JSONEncoding.default, headers: HTTPHeaders()).response { response in
                    let code = response.response?.statusCode
                    if code == 200 {
                        // success
                        print("success sending fall alert")
                    } else if code == 401 {
                        // failure
                        print("error sending fall alert: 401")
                        userDefaults.removeObject(forKey: "id")
                        userDefaults.removeObject(forKey: "key")
                        self.showToast(message: "Vos identifiants sont erronés. La chute n'a pas pu être générée")
                    } else {
                        print("error sending fall alert: ", code!)
                        self.showToast(message: "Le serveur est hors ligne ou a rencontré un problème. Réessayez ultérieurement")
                    }
                }
            }
            
        } else {
            print("face up")
            vibration = false
        }
        self.circle?.removeFromSuperview()

        blur()
        animate()
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {return}
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Authentification requise", message: "Afin de déclencher une alerte de test, rentrez vos identifiants", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Valider", style: .default) { (_) in
            
            //getting the input values from user
            let id = alertController.textFields?[0].text
            let key = alertController.textFields?[1].text
            
            //self.labelMessage.text = "Name: " + name! + "Email: " + email!
            let userDefaults = UserDefaults.standard
            userDefaults.set(id, forKey: "id")
            userDefaults.set(key, forKey: "key")
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
    
    /*
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
 */
}
