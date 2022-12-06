//
//  ZanimljivostiViewController.swift
//  Kviz_znanja
//
//  Created by anacvejic on 10/30/22.
//  Copyright © 2022 anacvejic. All rights reserved.
//

import UIKit
import MBProgressHUD
import Firebase
import FirebaseFirestore


class ZanimljivostiCell: UICollectionViewCell{
    
    @IBOutlet weak var imgViewPicture: UIImageView!
    @IBOutlet weak var lblNaziv: UILabel!
}

class ZanimljivostiViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  
    @IBOutlet weak var collectionViewCustom: UICollectionView!
    
     var oblasti: Pitanja!
     var id: String = ""
     var db: Firestore!
     let settings = FirestoreSettings()
     var UUIDValue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

      oblasti = Pitanja()
           
      db = Firestore.firestore()
      settings.isPersistenceEnabled = false
      db.settings = settings
        
     if Reachability.isConnectedToNetwork(){
            UUIDValue = UIDevice.current.identifierForVendor!.uuidString
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 140, height: 140)
            collectionViewCustom.collectionViewLayout = layout
            oblasti.allQuestion {
            self.collectionViewCustom.reloadData()
            }
        }else{
            alert()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork(){
            oblasti.allQuestion {
            self.collectionViewCustom.reloadData()
            }
        }else{
            alert()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return oblasti.oblasti.count
   }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "zanimljivosti", for: indexPath) as! ZanimljivostiCell
           let zanim = oblasti.oblasti[indexPath.row]
                 
                 let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                 hud.bezelView.color = UIColor.systemTeal
                 hud.contentColor = UIColor.white
                 hud.bezelView.style = .solidColor
                 let url = URL(string: "\(zanim.slika)")
                 DispatchQueue.global().async {
                     if let data = try? Data(contentsOf: url!){
                                   DispatchQueue.main.async {
                                     cell.imgViewPicture.image = UIImage(data: data)
                                     cell.lblNaziv.text = "\(zanim.naziv)"
                                     hud.hide(animated: true)
                                   }
                               }
                           }

                 return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if Reachability.isConnectedToNetwork(){
        let zanim = oblasti.oblasti[indexPath.row]
        id = zanim.documentID!
    
        self.performSegue(withIdentifier:"pitanje", sender: self)
        }else{
            alert()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
          return CGSize(width: 180, height: 160)
      }
    
    func alert(){
       let action = UIAlertController(title: "No internet connection", message: "Niste konektovani na internet", preferredStyle: .alert)
       let akcijaOK = UIAlertAction(title: "OK", style: .destructive) { (_) in
          exit(0)
        }
       action.addAction(akcijaOK)
       self.present(action, animated: true)
      }
    
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
        
    }
         override func prepare(for segue: UIStoryboardSegue, sender: Any?){
         if segue.identifier == "pitanje"{
         let prenos = segue.destination as! ZanimljivostiPitanjaViewController
            prenos.naziv = id
         print("KLIKNUO SI NA: \(id)")
         }
     }
}
