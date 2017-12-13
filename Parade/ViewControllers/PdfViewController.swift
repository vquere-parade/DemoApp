//
//  PdfViewController.swift
//  Parade
//
//  Created by Antoine Sauray on 13/12/2017.
//  Copyright © 2017 Parade Protection. All rights reserved.
//

import UIKit

class PdfViewController: UIViewController {
    
    var productPdf: ProductPdf?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        //Bundle.main.url(forResource: pv.videoName, withExtension: pv.videoType)!
        print(productPdf?.pdfName)
        if let pdfURL = Bundle.main.url(forResource: productPdf?.pdfName, withExtension: "pdf")  {
            do {
                print("do")
                let data = try Data(contentsOf: pdfURL)
                print("data")
                let webView = UIWebView(frame: CGRect(x:20,y:20,width:view.frame.size.width-40, height:view.frame.size.height-40))
                print("webview")
                webView.load(data, mimeType: "application/pdf", textEncodingName:"", baseURL: pdfURL.deletingLastPathComponent())
                view.addSubview(webView)
                
            }
            catch {
                // catch errors here
                print("error with pdf")
            }
            
        } else {
            print("pdf not found")
        }
    }
}
