//
//  User.swift
//  Kviz_znanja
//
//  Created by anacvejic on 10/24/22.
//  Copyright © 2022 anacvejic. All rights reserved.
//

import Foundation
import FirebaseFirestore
import MBProgressHUD

open class User{
    
    var userID: String
    var arheoloska_nalazista: [String]
    var arhitektura: [String]
    var istorija: [String]
    var knjizevnost: [String]
    var muzika: [String]
    var pozoriste_film: [String]
    var srpske_svetinje: [String]
    var znamenite_licnosti_srbije: [String]
    var ukupno_poena: Int
    
    var db: Firestore = Firestore.firestore()
    var docID: String!
    var documentID: String = ""
    var poeni: Int = 0
    var poeniKorisnik = [String]()

    init(userID: String, arheoloska_nalazista: [String], arhitektura: [String], istorija: [String],knjizevnost: [String], muzika: [String], pozoriste_film: [String], srpske_svetinje: [String],  znamenite_licnosti_srbije: [String], ukupno_poena: Int){
        
        self.userID = userID
        self.arheoloska_nalazista = arheoloska_nalazista
        self.arhitektura = arhitektura
        self.istorija = istorija
        self.knjizevnost = knjizevnost
        self.muzika = muzika
        self.pozoriste_film = pozoriste_film
        self.srpske_svetinje = srpske_svetinje
        self.znamenite_licnosti_srbije = znamenite_licnosti_srbije
        self.ukupno_poena = ukupno_poena
       }
    
    init(){
        self.ukupno_poena = 5
        self.userID = ""
        self.arheoloska_nalazista = []
        self.arhitektura = []
        self.istorija = []
        self.knjizevnost = []
        self.muzika = []
        self.pozoriste_film = []
        self.srpske_svetinje = []
        self.znamenite_licnosti_srbije = []
    }
    
      func createNewUser(uidMobile: String){
         
             db.collection("user").addDocument(data: [
                 "arheoloska-nalazista": [],
                 "arhitektura": [],
                 "istorija": [],
                 "knjizevnost": [],
                 "muzika": [],
                 "pozoriste-film": [],
                 "srpske-svetinje": [],
                 "ukupno-poena": 0,
                 "userID": uidMobile,
                 "znamenite-licnosti-srbije": []
             ]){
                 err in
                 if let err = err{
                     print("Greska prilikom dodavanja dokumenta: \(err)")
                 }else{
                     print("Dokument je dodat")
                 }
             }
     }
    
     public func proveraKorisnika(uidMobile: String){
         
         let korisnik = db.collection("user").whereField("userID", isEqualTo: uidMobile)
         korisnik.getDocuments { (snap, error) in
             
             if error != nil{
                 print("GRESKA: \(error!)")
             }else{
                 if let doc = snap?.documents, !doc.isEmpty{
                     print("KORISNIK POSTOJI U BAZI")
                     print("BROJ MOBILNOG: \(uidMobile)")
                 }else{
                    self.createNewUser(uidMobile: uidMobile)
                     print("KORISNIK JE KREIRAN")
                 }
             }
         }
     }
    
    
        func findCountOfAnswer(uidMobile: String, naziv: String, completion: @escaping((Int?, Int?)->())){
            var rez: Int = 0
            var brojac = 0
            var poeni = 0
            let korisnik = db.collection("user").whereField("userID", isEqualTo: uidMobile)
                  korisnik.getDocuments { (snap, error) in
                      guard error == nil else{
                          print("GRESKA")
                          return
                      }
                   for kor in snap!.documents{
                      print("ID DOKUMENTA KORISNIKA: \(kor.documentID)")
                      let oblast = kor.data()[naziv] as! [String]
                    print("UKUPNO ODGOVORA IZ OBLASTI: \(oblast.count)")
                    poeni = oblast.count * 5
                       let odgovori =  self.db.collection("pitanja").document(naziv).collection(naziv)
                          odgovori.getDocuments { (doc, error) in
                              for document in doc!.documents{
                                  if !oblast.contains(document.documentID){
                                  brojac += 1
                          }
                      }
                    rez = brojac
                    print("UKUPNO PITANJA ZA ODGOVOR: \(brojac)")
                    print("PRAMETAR REY KOJI SALJE U CLICK FOR ROW AT: \(rez)")
                    completion(rez, poeni)
                }
                    
          }
                    
        }
                
    }
    
    func findDocumentID(uidMobile: String, completion: @escaping((String?)->())){
    var rez: String = ""
     db.collection("user").whereField("userID", isEqualTo: uidMobile).addSnapshotListener { (qury, error) in
            
            guard error == nil else{
                print("GRESKA")
                return completion(nil)
            }
            for document in qury!.documents{
                
                let id = document.documentID
                rez = id
        }
             completion(rez)
               print("REZULTAT ID DOKUMENTA KORISNIKA TELEFONA: \(rez)")
        
        }
       
    }
    
    func updateDataUser(oblast: String, idOblasti: String, uidMobile: String){
        findDocumentID(uidMobile: uidMobile) { (doc) in
            self.docID = doc
            let newData = self.db.collection("user").document(self.docID!)
              newData.updateData([
              oblast : FieldValue.arrayUnion([idOblasti])
           ])
        }
    }
    
    func updateScore(uidMobile: String){
        let id = db.collection("user").whereField("userID", isEqualTo: uidMobile)
        print("DOBIJENI PODACI: \(id)")
        id.getDocuments { (query, error) in
            guard error == nil else{
                print("GRESKA")
                return
            }
            for doc in query!.documents{
                let idDoc = doc.documentID
                let poeni = doc.data()["ukupno-poena"] as! Int
                self.documentID = idDoc
                self.poeni = poeni
            }
            self.poeni += 5
            let updateResult = self.db.collection("user").document(self.documentID)
            updateResult.updateData(["ukupno-poena" : self.poeni])
        }
        
    }
    
    
    func readData(uidMobile: String, view: UIView, table: UITableView){
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.bezelView.color = UIColor.blue
        hud.contentColor = UIColor.white
        hud.bezelView.style = .solidColor
        
        let korisnik = db.collection("user").whereField("userID", isEqualTo: uidMobile)
        korisnik.getDocuments { (query, error) in
            guard error == nil else{
                print("GRESKA")
                return
            }
            self.poeniKorisnik = []
            
            for doc in query!.documents{
                let ukupnoPoena = doc.get("ukupno-poena") as? Int
                let arheologija = doc.get("arheoloska-nalazista") as? [String]
                let arhitektura = doc.get("arhitektura") as? [String]
                let istorija = doc.get("istorija") as? [String]
                let knjizevnost = doc.get("knjizevnost") as? [String]
                let muzika = doc.get("muzika") as? [String]
                let pozoriste = doc.get("pozoriste-film") as? [String]
                let manastiri = doc.get("srpske-svetinje") as? [String]
                let licnosti = doc.get("znamenite-licnosti-srbije") as? [String]
                self.poeniKorisnik.append("Ukupno poena: \(ukupnoPoena ?? 0)")
                self.poeniKorisnik.append("Oblast arheologija: \(arheologija!.count*5)")
                self.poeniKorisnik.append("Oblast arhitektura: \(arhitektura!.count*5)")
                self.poeniKorisnik.append("Oblast istorija: \(istorija!.count*5)")
                self.poeniKorisnik.append("Oblast književnost: \(knjizevnost!.count*5)")
                self.poeniKorisnik.append("Oblast muzika: \(muzika!.count*5)")
                self.poeniKorisnik.append("Oblast pozorište: \(pozoriste!.count*5)")
                self.poeniKorisnik.append("Oblast manastiri: \(manastiri!.count*5)")
                self.poeniKorisnik.append("Oblast znamenite ličnosti Srbije: \(licnosti!.count*5)")
            }
            DispatchQueue.main.async {
                hud.hide(animated: true)
                table.reloadData()
            }
        }
    }
}
    

