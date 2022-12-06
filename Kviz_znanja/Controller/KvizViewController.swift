//
//  KvizViewController.swift
//  Kviz_znanja
//
//  Created by anacvejic on 10/21/22.
//  Copyright © 2022 anacvejic. All rights reserved.
//

import UIKit
import MBProgressHUD
import Firebase
import FirebaseFirestore


class KvizPhotoCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var lblNaziv: UILabel!
}

class KvizViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
   
   @IBOutlet weak var collectionViewPhoto: UICollectionView!
    
    var id: String = ""
    var nazivOblasti = ""
    var brojTacnih = 0
    var db: Firestore!
    let settings = FirestoreSettings()
    var UUIDValue: String?
    var brojPoenaZaOblast = 0
    var oblasti: Pitanja!
    var korisnik = User()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        settings.isPersistenceEnabled = false
        db.settings = settings

        oblasti = Pitanja()
        UUIDValue = UIDevice.current.identifierForVendor!.uuidString
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        collectionViewPhoto.delegate = self
        collectionViewPhoto.dataSource = self
        collectionViewPhoto.collectionViewLayout = layout
        
        if Reachability.isConnectedToNetwork(){
        oblasti.allQuestion(completed: {
        self.collectionViewPhoto.reloadData()
        })
        }else{
            alert()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork(){
        oblasti.allQuestion(completed: {
            self.collectionViewPhoto.reloadData()
        })
        }else{
            alert()
        }
    }
    
    
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return oblasti.oblasti.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photocell", for: indexPath) as! KvizPhotoCollectionViewCell
            let oblast = oblasti.oblasti[indexPath.row]
            
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.bezelView.color = UIColor.systemTeal
            hud.contentColor = UIColor.white
            hud.bezelView.style = .solidColor
            let url = URL(string: "\(oblast.slika)")
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url!){
                              DispatchQueue.main.async {
                                cell.imageViewPhoto.image = UIImage(data: data)
                                cell.lblNaziv.text = "\(oblast.naziv)"
                                hud.hide(animated: true)
                              }
                          }
                      }

            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if Reachability.isConnectedToNetwork(){
        let oblast = oblasti.oblasti[indexPath.row]
        print("NAZIV JE: \(oblast.documentID!)")
        
        korisnik.findCountOfAnswer(uidMobile: UUIDValue!, naziv: oblast.documentID!) { brojOdgovora, brojPoena in
            self.brojTacnih = brojOdgovora!
            self.brojPoenaZaOblast = brojPoena!
            if self.brojTacnih == 0{
                self.nazivOblasti = oblast.naziv
                self.performSegue(withIdentifier:"endKviz", sender: self)

            }else{
                self.id = oblast.documentID!
                self.nazivOblasti = oblast.naziv

                self.performSegue(withIdentifier:"kviz", sender: self)
            }
     }
        }else{
            alert()
        }
}
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
           return CGSize(width: 180, height: 140)
       }
    

      override func prepare(for segue: UIStoryboardSegue, sender: Any?){
          if segue.identifier == "kviz"{
          let prenos = segue.destination as! PitanjaViewController
          prenos.naziv = id
          prenos.nazivOblasti = nazivOblasti
          print("KLIKNUO SI NA: \(id)")
          }else if segue.identifier == "endKviz"{
                let prenos = segue.destination as! EndQvizViewController
                  prenos.brojPoenaZaOblast = brojPoenaZaOblast
                  prenos.nazivOblasti = nazivOblasti
                  print("KLIKNUO SI NA: \(id)")
        }
        
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
}






