//
//  DetaljiZanimljivostiViewController.swift
//  Kviz_znanja
//
//  Created by anacvejic on 10/30/22.
//  Copyright © 2022 anacvejic. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class DetaljiZanimljivostiViewController: UIViewController {

    
    @IBOutlet weak var imgViewPicture: UIImageView!
    @IBOutlet weak var lblPitanje: UILabel!
    @IBOutlet weak var zanimljivosti: WKWebView!
    @IBOutlet weak var lblOdgovor: UILabel!
    
    
    var pitanje: String = ""
    var zanimljivost: String = ""
    var slika: String = ""
    var odgovor: String = ""
    
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
                   hud.bezelView.color = UIColor.systemTeal
                   hud.contentColor = UIColor.blue
                   hud.bezelView.style = .blur
                   let url = URL(string: slika)
                   DispatchQueue.global().async {
                       if let data = try? Data(contentsOf: url!){
                           DispatchQueue.main.async {
                                self.imgViewPicture.image = UIImage(data: data)
                                self.lblPitanje.text = self.pitanje
                                self.lblOdgovor.text = "Odgovor: " + self.odgovor
                                self.zanimljivosti.loadHTMLString("<html><head><meta name=\"viewport\" content=\"initial-scale=1.0 minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"/><style>body {-webkit-text-size-adjust: none;font-size:23px;color:black;}</style></head><body>\(self.zanimljivost)", baseURL: nil)
                                
                                hud.hide(animated: true)
                            
                         }
                      }
                    }
        
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
