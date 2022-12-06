//
//  ViewController.swift
//  Kviz_znanja
//
//  Created by anacvejic on 10/21/22.
//  Copyright © 2022 anacvejic. All rights reserved.
//

import UIKit
import FirebaseFirestore
import ImageIO
import Network


class ViewController: UIViewController {

    @IBOutlet weak var btnWelcome: UIButton!
    @IBOutlet weak var imgViewAnimation: UIImageView!
    @IBOutlet weak var lblErrorInternetConnection: UILabel!
    
   
    var korisnik = User()
    var db: Firestore!
    let settings = FirestoreSettings()
    //Ideja je da ne postoji korisnik dok ga ne proverimo
    var UUIDValue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        db = Firestore.firestore()
        settings.isPersistenceEnabled = false
        db.settings = settings
        UUIDValue = UIDevice.current.identifierForVendor!.uuidString
        setControll()

       
    }
    
    func setControll(){
        
        let gif = UIImage.gifImageWithName("sovica_jedan")
        imgViewAnimation.image = gif
        
        if Reachability.isConnectedToNetwork(){
            
            korisnik.proveraKorisnika(uidMobile: UUIDValue!)
            self.btnWelcome.layer.cornerRadius = 10
            self.btnWelcome.layer.borderWidth = 2
            self.btnWelcome.layer.borderColor = UIColor.systemTeal.cgColor
            btnWelcome.setTitle("Dobrodošli", for: .normal)
            lblErrorInternetConnection.isHidden = true
        }else{
            lblErrorInternetConnection.text = "Nemate Internet konekciju"
            btnWelcome.isHidden = true
        }
        print("UUIDVALUE: \(UUIDValue ?? "")")
    }
    
    @IBAction func btnWelcomeTapped(_ sender: Any) {

    }
    
    @IBAction override func performSegue(withIdentifier identifier: String, sender: Any?) {
    
        
    }
    
    @IBAction  func unwind(for unwindSegue: UIStoryboardSegue) {
        
    }
    
 
}












