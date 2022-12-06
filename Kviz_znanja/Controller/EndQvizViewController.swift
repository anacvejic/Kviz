//
//  EndQvizViewController.swift
//  Kviz_znanja
//
//  Created by anacvejic on 10/23/22.
//  Copyright © 2022 anacvejic. All rights reserved.
//

import UIKit
import AVFoundation

class EndQvizViewController: UIViewController {

    
  
    @IBOutlet weak var imgViewConfeti: UIImageView!
    @IBOutlet weak var imgViewPehar: UIImageView!
    @IBOutlet weak var lblResult: UILabel!
    
    var rezultat: String = ""
    var nazivOblasti: String = ""
    var UUIDValue: String?
    var docID: String = ""
    var oblast = ""
    var brojPoenaZaOblast: Int = 0
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if Reachability.isConnectedToNetwork(){
        setControll()
        UUIDValue = UIDevice.current.identifierForVendor!.uuidString
        }else{
            alert()
        }
    }
    

    func setControll(){
        let confeti = UIImage.gifImageWithName("konfeti")
        imgViewConfeti.image = confeti
        let gif = UIImage.gifImageWithName("winner")
        imgViewPehar.image = gif
        audioCorrectAnswer(odgovor: "kraj")
        if brojPoenaZaOblast == 0{
            lblResult.text = "Ukupno poena za oblast \(nazivOblasti) je: \(rezultat)"
        }else{
              lblResult.text = "Odgovorili ste na sva pitanja iz oblasti \(nazivOblasti) i osvojili \(brojPoenaZaOblast) poena"
        }
    }
    
    func audioCorrectAnswer(odgovor: String){
         
         let pathSound = Bundle.main.path(forResource: odgovor, ofType: "wav")!
         let url = URL(fileURLWithPath: pathSound)
         audioPlayer = try? AVAudioPlayer(contentsOf: url)
         audioPlayer?.play()
     }

    @IBAction func btnBack(_ sender: Any) {
        
        self.performSegue(withIdentifier: "backToKviz", sender: self)
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
