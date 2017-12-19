//
//  PdfViewController.swift
//  Parade
//
//  Created by Antoine Sauray on 13/12/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import UIKit
import WebKit

class PdfViewController: UIViewController {
    
    var productPdf: ProductPdf?
    var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.orientationChanged),
            name: .UIDeviceOrientationDidChange,
            object: nil)
        //Bundle.main.url(forResource: pv.videoName, withExtension: pv.videoType)!
        if let pdfURL = Bundle.main.url(forResource: productPdf?.pdfName, withExtension: "pdf")  {
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
    
}
