//
//  KulturnaDesavanja.swift
//  Kviz_znanja
//
//  Created by anacvejic on 10/27/22.
//  Copyright © 2022 anacvejic. All rights reserved.
//

import Foundation
import FirebaseFirestore

open class KulturnaDesavanja: Identifiable{
    
    var documentID: String?
    var link: String
    var naziv: String
    var slika: String
    
    var db: Firestore = Firestore.firestore()
    var desavanja = [KulturnaDesavanja]()
    
    init(){
        self.documentID = ""
        self.link = ""
        self.naziv = ""
        self.slika = ""
    }
    
    init(documentID: String, link: String, naziv: String, slika: String) {
        self.documentID = documentID
        self.link = link
        self.naziv = naziv
        self.slika = slika
    }
    
    func readData(naziv: String, tableViewCustom: UITableView){
     self.desavanja.removeAll()
       let data = db.collection("kulturna_desavanja").document("kulturna_desavanja").collection(naziv)
        data.getDocuments { (querySnap, error) in
            
            for rez in querySnap!.documents{

                let data = KulturnaDesavanja(documentID: (rez.documentID), link: ((rez.get("link") as? String)!), naziv: ((rez.get("naziv") as? String)!), slika: ((rez.get("slika") as? String)!))
                self.desavanja.append(data)
            }
            tableViewCustom.reloadData()
            print("UKUPNO IMA PODATAKA: \(self.desavanja.count)")
        }
    }
    
}
