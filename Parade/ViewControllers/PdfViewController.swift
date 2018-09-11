//
//  PdfViewController.swift
//  Parade
//
//  Created by Antoine Sauray on 13/12/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import UIKit
import WebKit
import MessageUI

class PdfViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var actionNavButton: UIBarButtonItem!
    @IBOutlet weak var cancelNavButton: UIBarButtonItem!
    var productPdf: String!
    var webView: WKWebView?
    

    @objc func actionButtonTapped(sender: UIBarButtonItem) {
        print("send email")
        sendEmail()
    }
    
    @objc func cancelButtonTapped(sender: UIBarButtonItem) {
        print("cancelButtonTapped")
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        actionNavButton.action =  #selector(actionButtonTapped(sender:))
        actionNavButton.target =  self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.orientationChanged),
            name: .UIDeviceOrientationDidChange,
            object: nil)
        //Bundle.main.url(forResource: pv.videoName, withExtension: pv.videoType)!
        if let pdfURL = Bundle.main.url(forResource: productPdf, withExtension: "pdf")  {
            do {
                print("do")
                let data = try Data(contentsOf: pdfURL)
                print("data")
                webView = WKWebView(frame: CGRect(x: 0,y: 0,width:view.frame.size.width, height:view.frame.size.height))
                print("webview")
                webView?.load(data, mimeType: "application/pdf", characterEncodingName:"", baseURL: pdfURL.deletingLastPathComponent())
                view.addSubview(webView!)
            }
            catch {
                // catch errors here
                print("error with pdf")
            }
            
        } else {
            print("pdf not found")
        }
    }
    
    @objc func orientationChanged(notification: NSNotification) {
        print("orientation changed")
        if let wv = webView {
            wv.frame = CGRect(x: 0,y: 0,width:view.frame.size.width, height:view.frame.size.height)
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            if let pdfURL = Bundle.main.url(forResource: productPdf, withExtension: "pdf")  {
                do {
                    print("do")
                    let data = try Data(contentsOf: pdfURL)
                    let composeVC = MFMailComposeViewController()
                    composeVC.mailComposeDelegate = self
                    // Configure the fields of the interface.
                    composeVC.setSubject("Evone and Izome smart shoes")
                    composeVC.setMessageBody("Find out more about our smart shoes in the attached document", isHTML: false)
                    composeVC.addAttachmentData(data, mimeType: "application/pdf", fileName: "PDF Izome")
                    // Present the view controller modally.
                    self.present(composeVC, animated: true, completion: nil)
                }
                catch {
                    
                }
            }
        } else {
            self.showToast(message: "The mail functionnality is unavailable")
        }
        
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension UIViewController {
    
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
    } }
