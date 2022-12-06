//
//  PitanjaViewController.swift
//  Kviz_znanja
//
//  Created by anacvejic on 10/23/22.
//  Copyright © 2022 anacvejic. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import AVFoundation
import MBProgressHUD

class QuestionCell: UITableViewCell{
    @IBOutlet weak var question: UILabel!
}


class PitanjaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var lblGuestion: UILabel!
    @IBOutlet weak var btnScore: UIButton!
    
    @IBOutlet weak var imgViewQuestion: UIImageView!
    var db: Firestore!
    let settings = FirestoreSettings()
    var pitanja = [KvizPitanja]()
    var currenQuestion: KvizPitanja?
    var naziv = ""
    var nazivOblasti = ""
    var audioPlayer: AVAudioPlayer?
    var UUIDValue: String?
    var korisnik: User!
    var score = 0
    var netacni_odgovor = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        settings.isPersistenceEnabled = false
        db.settings = settings
        korisnik = User()
        
        if Reachability.isConnectedToNetwork(){
        UUIDValue = UIDevice.current.identifierForVendor!.uuidString
        redData(naziv: naziv, uidMobile: UUIDValue!)
        print("DOBIJEN NAZIV U PITANJIMA: \(naziv)")
        let gif = UIImage.gifImageWithName("YOPR")
        imgViewQuestion.image = gif
        }else{
            alert()
        }
    }
    
    func configureUI(question: KvizPitanja){
            lblGuestion.text = question.pitanje
            currenQuestion = question
            table.reloadData()
    }
    
    @IBAction func btnClickBack(_ sender: Any) {
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  currenQuestion?.ponudjeni_odgovori.count ?? 0
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionCell
        cell.question.text = currenQuestion?.ponudjeni_odgovori[indexPath.row]
        cell.question.layer.borderWidth = 2
        cell.question.layer.cornerRadius = 10
        cell.question.layer.borderColor = UIColor.systemBlue.cgColor
        cell.contentView.backgroundColor = UIColor.clear
        
        return cell
    }
    
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: UITableViewCell = table.cellForRow(at: indexPath)!
        if Reachability.isConnectedToNetwork(){
        guard let question = currenQuestion else {
            return
        }
        
        let answer = question.ponudjeni_odgovori[indexPath.row]
        let tacanOdgovor = question.tacan_odgovor
        if answer == tacanOdgovor{
            audioCorrectAnswer(odgovor: "tacan")
            score += question.poeni
            korisnik.updateDataUser(oblast: naziv, idOblasti: question.documentID!, uidMobile: UUIDValue!)
            korisnik.updateScore(uidMobile: UUIDValue!)
            btnScore.setTitle("\(score)", for: .normal)
            
            if let index = pitanja.firstIndex(where: {$0.pitanje == question.pitanje}){
                print("INDEX: \(index)")
                if index < (pitanja.count - 1){
                    let nextQuestion = pitanja[index + 1]
                    print("\(nextQuestion)")
                    currenQuestion = nil
                    configureUI(question: nextQuestion)
              }else{
                    
                    self.performSegue(withIdentifier: "endKviz", sender: self)
                }
                
            }
            
        }else{
            netacni_odgovor += 1
            cell.contentView.backgroundColor = UIColor.red
            audioCorrectAnswer(odgovor: "netacan")
            if netacni_odgovor == 3{
                let action = UIAlertController(title: "U ovoj seriji pitanja dali ste tri puta netacan odgovor", message: "", preferredStyle: .alert)
                let akcijaOK = UIAlertAction(title: "OK", style: .destructive) { (_) in
                    
                    _ = self.navigationController?.popViewController(animated: true)
                }
                action.addAction(akcijaOK)
                self.present(action, animated: true)
            }
            print("NETACNO")
        }
        }else{
            alert()
        }
        
    }
    
    func audioCorrectAnswer(odgovor: String){
         
         let pathSound = Bundle.main.path(forResource: odgovor, ofType: "wav")!
         let url = URL(fileURLWithPath: pathSound)
         audioPlayer = try? AVAudioPlayer(contentsOf: url)
         audioPlayer?.play()
     }
    
    func read(naziv: String){
    db.collection("pitanja").document(naziv).collection(naziv).addSnapshotListener{ (snapShot, error) in
             
    if error != nil{
        print(error!.localizedDescription)
    }else{
         if let snapShot = snapShot, !snapShot.isEmpty{
         print("IMA PODATAKA")
                     
            self.pitanja = (snapShot.documents.map{ document in
                     
                KvizPitanja(documentID: (document.documentID) ,pitanje: (document.get("pitanje") as? String)!, poeni: (document.get("poeni") as? Int)!, ponudjeni_odgovori: (document.get("ponudjeni-odgovori") as? [String])!, tacan_odgovor: (document.get("tacan-odgovor") as? String)!, zanimljivosti: (document.get("zanimljivosti")as? String)!, slika: (document.get("slika")as? String)!)
                     
        })
            self.configureUI(question: self.pitanja.first!)
      }
   }
  }
 }
    
 
    
     func redData(naziv: String, uidMobile: String){
          
         let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
         hud.bezelView.color = UIColor.blue
         hud.contentColor = UIColor.white
         hud.bezelView.style = .solidColor
          let korisnik = db.collection("user").whereField("userID", isEqualTo: uidMobile)
                korisnik.getDocuments { (snap, error) in
                    
                 for kor in snap!.documents{
                    print("ID DOKUMENTA KORISNIKA: \(kor.documentID)")
                    let oblast = kor.data()[naziv] as! [String]
                    print("Oblast: \(oblast)")
                    if oblast.count == 0 || oblast.isEmpty{
                        self.read(naziv: naziv)
                        hud.hide(animated: true)
                        print("NEMATE NIJEDAN DACAN ODGOVOR!")
                    }else{
                     let odgovori =  self.db.collection("pitanja").document(naziv).collection(naziv)
                        odgovori.getDocuments { (doc, error) in
                            for document in doc!.documents{
                                if !oblast.contains(document.documentID){
                                    print("ID NEODGOVORENOG PITANJA: \(document.documentID)")
                                    let novaPitanja =  KvizPitanja(documentID: (document.documentID) ,pitanje: (document.get("pitanje") as? String)!, poeni: (document.get("poeni") as? Int)!, ponudjeni_odgovori: (document.get("ponudjeni-odgovori") as? [String])!, tacan_odgovor: (document.get("tacan-odgovor") as? String)!, zanimljivosti: (document.get("zanimljivosti")as? String)!, slika: (document.get("slika")as? String)!)
                                        self.pitanja.append(novaPitanja)
                        }
                    }
                            print("UKUPNO PITANJA ZA ODGOVOR: \(self.pitanja.count)")
                            self.configureUI(question: self.pitanja.first!)
                            print("UKUPNO POENA: \(oblast.count * 5)")
                            self.score = oblast.count * 5
                            self.btnScore.setTitle("\(self.score)", for: .normal)
                            hud.hide(animated: true)
                            
                        }
           }
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
         if segue.identifier == "endKviz"{
         let prenos = segue.destination as! EndQvizViewController
         prenos.rezultat = "\(score)"
         prenos.nazivOblasti = nazivOblasti
         prenos.oblast = naziv
    }
}

}
