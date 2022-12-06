//
//  FIRFirestoreService.swift
//  Kviz_znanja
//
//  Created by anacvejic on 10/21/22.
//  Copyright © 2022 anacvejic. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class FIRFirestoreService{
    
    private init(){}
    static let shared = FIRFirestoreService()
    
    
    
    func configure(){
        
        FirebaseApp.configure()
    }
    
    private func reference(to collectionReference: FIRCollectionReference)->CollectionReference{
        
        return Firestore.firestore().collection(collectionReference.rawValue)
    }

}
