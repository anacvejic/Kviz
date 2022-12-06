//
//  OAplikacijiViewController.swift
//  Kviz_znanja
//
//  Created by Grupa 1 on 2.11.22..
//  Copyright © 2022 anacvejic. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD


class OAplikacijiViewController: UIViewController {

    @IBOutlet weak var wkWebInfo: WKWebView!
    
    @IBOutlet var mainView: UIView!
    var text: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if Reachability.isConnectedToNetwork(){
            setControl()
        }else{
            alert()
        }
    }
    
    func setControl(){
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.bezelView.color = UIColor.blue
        hud.contentColor = UIColor.white
        hud.bezelView.style = .solidColor
        self.text = "U vremenu kada su kutura, kulturno nasleđe, istorija suočeni sa velikim izazovima i opstankom, važno je znati elementarne činjenice kako bi ih sačuvali od zaborava. Kada odgovorite na pitanje iz neke oblati, možete pročitati zanimljivosti o istim."
            self.wkWebInfo.loadHTMLString("<html><head><meta name=\"viewport\" content=\"initial-scale=1.0 minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"/><style>body {-webkit-text-size-adjust: none; font-size:18px;background-color:#000099;color:white;font-weight:bold;}</style></head><body>\(text)", baseURL: nil)
                self.mainView.layer.contents = #imageLiteral(resourceName: "raspeceHristovo").cgImage
            self.wkWebInfo.backgroundColor = UIColor.gray
        hud.hide(animated: true)
    }
    
      func alert(){
           let action = UIAlertController(title: "No internet connection", message: "Niste konektovani na internet", preferredStyle: .alert)
           let akcijaOK = UIAlertAction(title: "OK", style: .destructive) { (_) in
              exit(0)
            }
           action.addAction(akcijaOK)
           self.present(action, animated: true)
        }
}
