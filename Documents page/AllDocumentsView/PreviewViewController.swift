//
//  PreviewViewController.swift
//  Documents page
//
//  Created by Arjunan on 31/08/23.
//

import UIKit
import WebKit
class PreviewViewController: UIViewController {

    @IBOutlet weak var backAction: UIButton!
    @IBOutlet weak var myWebView: UIWebView!
    var fileUrl: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
//        let url = fileUrl
//        let requestObj = URLRequest(url: url!)
//        myWebView.loadRequest(requestObj)
        if let pdfURL = URL(string: fileUrl ?? "") {
            let request = URLRequest(url: pdfURL)
     
            self.myWebView.loadRequest(request)
        }

    }


    @IBAction func backAction(_ sender: UIButton) {
       self.navigationController!.popViewController(animated: true)
    }
    
}
