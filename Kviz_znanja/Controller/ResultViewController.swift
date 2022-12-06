//
//  ResultViewController.swift
//  Kviz_znanja
//
//  Created by Grupa 1 on 2.11.22..
//  Copyright © 2022 anacvejic. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MBProgressHUD

class ResultCell: UITableViewCell{
    @IBOutlet weak var lblResult: UILabel!
}

class ResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
  
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var imgViewBaloni: UIImageView!
    
    var UUIDValue: String?
    var db: Firestore!
    let settings = FirestoreSettings()
    
    var korisnik: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        settings.isPersistenceEnabled = false
        db.settings = settings

        
        UUIDValue = UIDevice.current.identifierForVendor!.uuidString
        let baloni = UIImage.gifImageWithName("baloni")
        imgViewBaloni.image = baloni
        korisnik = User()
        
        if Reachability.isConnectedToNetwork(){
            korisnik.readData(uidMobile: UUIDValue!, view: view, table: table)
        }else{
            alert()
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return korisnik.poeniKorisnik.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "result", for: indexPath) as! ResultCell
        cell.lblResult.text = korisnik.poeniKorisnik[indexPath.row]
        
        cell.lblResult.layer.borderWidth = 2
        cell.lblResult.layer.cornerRadius = 10
        cell.lblResult.layer.borderColor = UIColor.systemBlue.cgColor
        return cell
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
