//
//  SignupViewController.swift
//  Parade
//
//  Created by Antoine Sauray on 10/03/2018.
//  Copyright © 2018 Parade Protection. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SignupViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var validateButton: UIButton!
    override func viewDidLoad() {
        validateButton.addTarget(self, action: #selector(createAccount(_:)), for: .touchUpInside)
    }
    
    @objc func createAccount(_ button: UIButton) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        if let email = emailTextField.text, let firstname = firstnameTextField.text, let lastname = nameTextField.text, let address = addressTextField.text, let phone = phoneTextField.text, let password = passwordTextField.text {
            
            if(isValidEmailAddress(emailAddressString: email)) {
                if !email.isEmpty && !firstname.isEmpty && !lastname.isEmpty && !address.isEmpty && !phone.isEmpty && !password.isEmpty {
                    let parameters: Parameters =
                        [
                            "email": email,
                            "password": password,
                            "first_name": firstname,
                            "last_name": lastname,
                            "home_address": address,
                            "phone_numbers": [phone],
                            "devices": [UIDevice.current.identifierForVendor!.uuidString],
                            "firebase_tokens": [:]
                    ]
                    Alamofire.request("https://customer-dot-parade-194715.appspot.com/caretakers", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                        UIViewController.removeSpinner(spinner: sv)
                        if(response.response?.statusCode == 201) {
                            let userDefaults = UserDefaults.standard
                            userDefaults.set(email, forKey: "caretaker_email")
                            userDefaults.set(password, forKey: "caretaker_password")
                            self.performSegue(withIdentifier: "demoSegue", sender: self)
                        } else {
                            let alert = UIAlertController(title: "Erreur", message: "Une erreur s'est produite et l'inscription n'a pas pu être finalisée. Réessayez ulterieurement", preferredStyle: UIAlertControllerStyle.alert)
                            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) -> Void in })
                            alert.addAction(ok)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    let alert = UIAlertController(title: "Erreur", message: "L'addresse email entrée n'est pas correcte", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) -> Void in })
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                UIViewController.removeSpinner(spinner: sv)
                let alert = UIAlertController(title: "Champs manquants", message: "Veuillez remplir tous les champs requis", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) -> Void in })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            UIViewController.removeSpinner(spinner: sv)
            let alert = UIAlertController(title: "Champs manquants", message: "Veuillez remplir tous les champs requis", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) -> Void in })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            if results.count == 0 {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
}



extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
