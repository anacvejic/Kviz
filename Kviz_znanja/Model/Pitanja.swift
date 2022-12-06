//
//  Pitanja.swift
//  Kviz_znanja
//
//  Created by anacvejic on 10/21/22.
//  Copyright © 2022 anacvejic. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol Identifiable{
    
    var documentID: String? { get set}
}
open class Pitanja: Identifiable{
    
    var documentID: String?
    var naziv: String
    var slika: String
    var db: Firestore = Firestore.firestore()

    var oblasti = [Pitanja]()
    
    init(){
        self.naziv = ""
        self.slika = ""
        self.documentID = ""
    }
    
    init(naziv: String, slika: String, id: String){
        
        self.naziv = naziv
        self.slika = slika
        self.documentID = id
    }
    
    
    func allQuestion(completed: @escaping()->()){
         let question = db.collection("pitanja")
        question.getDocuments { (query, error) in
             guard error == nil else{
                 print("GRESKA")
                 return
             }
            self.oblasti = []
             for qu in query!.documents{
                 let fetchData = Pitanja(naziv: qu.data()["naziv"] as! String, slika: qu.data()["slika"] as! String, id: qu.documentID)
                self.oblasti.append(fetchData)
             }
            completed()
         }
     }
}
