//
//  WebViewController.swift
//  BoutTime
//
//  Created by Murray Fenstermaker on 10/11/17.
//  Copyright © 2017 Nostalgiabox. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let unwrappedUrlString = urlString {
            let urlRequest = URLRequest(url: URL(string: unwrappedUrlString)!)
            webView.load(urlRequest)
            
            print(webView.isLoading)
      //      webView.loadRequest(urlRequest)
        }
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


