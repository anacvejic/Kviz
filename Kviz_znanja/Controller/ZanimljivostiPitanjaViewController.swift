//
//  ZanimljivostiPitanjaViewController.swift
//  Kviz_znanja
//
//  Created by anacvejic on 10/30/22.
//  Copyright © 2022 anacvejic. All rights reserved.
//

import UIKit
import MBProgressHUD
import Firebase
import FirebaseFirestore

class PitanjaCell: UITableViewCell{
    
    @IBOutlet weak var lblGuestion: UILabel!
}

class ZanimljivostiPitanjaViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate{

    
    @IBOutlet weak var lblObavestenje: UILabel!
    @IBOutlet weak var tableViewCustom: UITableView!
    
    var naziv: String = ""
    var pitanja = [KvizPitanja]()
    var UUIDValue: String?
    var db: Firestore!
    let settings = FirestoreSettings()

    var parmPitanje: String = ""
    var parmZanimljivost: String = ""
    var parmSlika: String = ""
    var parmOdgovor: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("NAZIV: \(naziv)")
        db = Firestore.firestore()
        settings.isPersistenceEnabled = false
        db.settings = settings
        
        UUIDValue = UIDevice.current.identifierForVendor!.uuidString
        
        if Reachability.isConnectedToNetwork(){
        redData(naziv: naziv, uidMobile: UUIDValue!)
        }else{
            alert()
        }
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pitanja.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pitanja") as! PitanjaCell
        let pit = pitanja[indexPath.row]
        cell.lblGuestion.text = pit.pitanje
        cell.lblGuestion.layer.borderWidth = 3
        cell.lblGuestion.layer.cornerRadius = 20
        cell.lblGuestion.layer.borderColor = UIColor.systemTeal.cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Reachability.isConnectedToNetwork(){
        let pit = pitanja[indexPath.row]
        parmSlika = pit.slika
        parmPitanje = pit.pitanje
        parmZanimljivost = pit.zanimljivosti
        parmOdgovor = pit.tacan_odgovor
        
        self.performSegue(withIdentifier: "detalji", sender: self)
        }else{
            alert()
        }
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
             if segue.identifier == "detalji"{
             let prenos = segue.destination as! DetaljiZanimljivostiViewController
             prenos.slika = parmSlika
             prenos.pitanje = parmPitanje
             prenos.zanimljivost = parmZanimljivost
             prenos.odgovor = parmOdgovor
        }
    }
    
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
        
    }
    
    func alert(){
       let action = UIAlertController(title: "No internet connection", message: "Niste konektovani na internet", preferredStyle: .alert)
       let akcijaOK = UIAlertAction(title: "OK", style: .destructive) { (_) in
          exit(0)
        }
       action.addAction(akcijaOK)
       self.present(action, animated: true)
      }
    
       func redData(naziv: String, uidMobile: String){
         let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
         hud.bezelView.color = UIColor.blue
         hud.contentColor = UIColor.white
         hud.bezelView.style = .solidColor
          let korisnik = db.collection("user").whereField("userID", isEqualTo: uidMobile)
                korisnik.getDocuments { (snap, error) in
                    
                 for kor in (snap?.documents)!{

                    let oblast = kor.data()[naziv] as! [String]

                    print("Oblast: \(oblast)")
                    if oblast.count == 0 || oblast.isEmpty{
                        self.lblObavestenje.text = "Nemate nijedan tacan odgovor da biste procitali zanimljivosti"
                        self.tableViewCustom.isHidden = true
                        hud.hide(animated: true)
                        print("NEMATE NIJEDAN DACAN ODGOVOR!")
                    }else{
                     let odgovori =  self.db.collection("pitanja").document(naziv).collection(naziv)
                        odgovori.getDocuments { (doc, error) in
                            for document in doc!.documents{
                                if oblast.contains(document.documentID){
                                    print("ID NEODGOVORENOG PITANJA: \(document.documentID)")
                                    let novaPitanja =  KvizPitanja(documentID: (document.documentID) ,pitanje: (document.get("pitanje") as? String)!, poeni: (document.get("poeni") as? Int)!, ponudjeni_odgovori: (document.get("ponudjeni-odgovori") as? [String])!, tacan_odgovor: (document.get("tacan-odgovor") as? String)!, zanimljivosti: (document.get("zanimljivosti")as? String)!, slika: (document.get("slika")as? String)!)
                                        self.pitanja.append(novaPitanja)
                                }
                           }
                            self.lblObavestenje.isHidden = true
                            self.tableViewCustom.reloadData()
                            print("UKUPNO ZANIMLJIVOSTI: \(self.pitanja.count)")
                            hud.hide(animated: true)
                        }
                        
                    }
                }
             }
        }
    
}
