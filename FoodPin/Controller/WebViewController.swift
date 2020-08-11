//
//  WebViewController.swift
//  FoodPin
//
//  Created by Lin Yi Sen on 2020/7/13.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    
    // targetURL變數是用來儲存由AboutTableViewController所傳遞的目標URL
    var targetURL = ""
    
    
    
    
    
    
    
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never   // 停用大標題
        
        if let url = URL(string: targetURL) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        // 導覽列設定黑色
        navigationController?.navigationBar.tintColor = .white
        
    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
