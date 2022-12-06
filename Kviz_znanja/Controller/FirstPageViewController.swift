//
//  FirstPageViewController.swift
//  Kviz_znanja
//
//  Created by anacvejic on 10/22/22.
//  Copyright © 2022 anacvejic. All rights reserved.
//

import UIKit
import FirebaseFirestore

class FirstPageViewController: UIViewController {
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnOAplikaciji: UIButton!
    @IBOutlet weak var btnKviz: UIButton!
    @IBOutlet weak var btnKUltutnaDesavanja: UIButton!
    @IBOutlet weak var btnZanimljivosti: UIButton!
    @IBOutlet weak var btnOstvareniPoeni: UIButton!
    
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainView.layer.contents = #imageLiteral(resourceName: "radonacelnica").cgImage
        setUpControll()
    }
    
    
    func setUpControll(){
        
        self.btnOAplikaciji.layer.cornerRadius = 15
        self.btnOAplikaciji.layer.borderWidth = 3
        self.btnOAplikaciji.layer.borderColor = UIColor.white.cgColor
        self.btnOAplikaciji.layer.masksToBounds = true
        self.btnKviz.layer.borderWidth = 3
        self.btnKviz.layer.cornerRadius = 15
        self.btnKviz.layer.borderColor = UIColor.white.cgColor
        self.btnKUltutnaDesavanja.layer.borderWidth = 3
        self.btnKUltutnaDesavanja.layer.cornerRadius = 15
        self.btnKUltutnaDesavanja.layer.borderColor = UIColor.white.cgColor
        self.btnZanimljivosti.layer.borderWidth = 1
        self.btnZanimljivosti.layer.cornerRadius = 15
        self.btnZanimljivosti.layer.borderColor = UIColor.white.cgColor
        self.btnOstvareniPoeni.layer.borderWidth = 1
        self.btnOstvareniPoeni.layer.cornerRadius = 15
        self.btnOstvareniPoeni.layer.borderColor = UIColor.white.cgColor

    }
    
    
    
    @IBAction func OAplikacijiTapped(_ sender: Any) {
    }
    
    
    @IBAction func btnKvizTapped(_ sender: Any) {
    }
    
    
    @IBAction func btnKulturnaDesavanjaTapped(_ sender: Any) {
    }
    
    
    @IBAction func btnYanimljivostiTapped(_ sender: Any) {
    }
    
    @IBAction func btnOstvareniPoeniClicked(_ sender: Any) {
    }
    
      @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
          
      }
    
    @IBAction func performSegue(withIdentifier identifier: String) {
        
    }
    
  

}


