//
//  KvizPitanja.swift
//  Kviz_znanja
//
//  Created by anacvejic on 10/24/22.
//  Copyright © 2022 anacvejic. All rights reserved.
//

import Foundation
import FirebaseFirestore

open class KvizPitanja: Identifiable{
    
    var documentID: String?
    var pitanje: String
    var poeni: Int
    var ponudjeni_odgovori: [String]
    var tacan_odgovor: String
    var zanimljivosti: String
    var slika: String
    var db: Firestore = Firestore.firestore()
    
    init(documentID: String, pitanje: String, poeni: Int, ponudjeni_odgovori: [String], tacan_odgovor: String, zanimljivosti: String, slika: String){
        
        self.documentID = documentID
        self.pitanje = pitanje
        self.poeni = poeni
        self.ponudjeni_odgovori = ponudjeni_odgovori
        self.tacan_odgovor = tacan_odgovor
        self.zanimljivosti = zanimljivosti
        self.slika = slika
        
    }
}
