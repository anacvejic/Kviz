//
//  KulturnaDesavanjaViewController.swift
//  Kviz_znanja
//
//  Created by anacvejic on 10/27/22.
//  Copyright © 2022 anacvejic. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import MBProgressHUD

class KulturaCell: UITableViewCell{
   
    @IBOutlet weak var imgSlika: UIImageView!
    @IBOutlet weak var lblNaziv: UILabel!
}

class KulturnaDesavanjaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableViewCustom: UITableView!
    @IBOutlet weak var slider: UISegmentedControl!
    
    var db: Firestore!
    let settings = FirestoreSettings()
    var kulturnaDesavanja: KulturnaDesavanja!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        settings.isPersistenceEnabled = false
        db.settings = settings
        
        kulturnaDesavanja = KulturnaDesavanja()

        if Reachability.isConnectedToNetwork(){
        kulturnaDesavanja.readData(naziv: "manastiri", tableViewCustom: tableViewCustom)
        setSlider()
        }else{
            alert()
        }
    }
    
    
    func setSlider(){
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
        slider.setTitleTextAttributes(titleTextAttributes, for:.normal)
        slider.selectedSegmentTintColor = UIColor.blue
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.white]
        slider.setTitleTextAttributes(titleTextAttributes1, for:.selected)
        slider.layer.borderWidth = 2
        slider.layer.borderColor = UIColor.blue.cgColor
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kulturnaDesavanja.desavanja.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let cell = tableView.dequeueReusableCell(withIdentifier: "kultura", for: indexPath) as! KulturaCell
        let pod = kulturnaDesavanja.desavanja[indexPath.row]

        let url = URL(string: "\(pod.slika)")
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.bezelView.color = UIColor.blue
        hud.contentColor = UIColor.white
        hud.bezelView.style = .solidColor
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!){
                
                    DispatchQueue.main.async {
                      
                    cell.imgSlika.image = UIImage(data: data)
                    print("NAZIV: \(pod.slika)")
                    cell.lblNaziv.text = pod.naziv
                    print("NAZIV: \(pod.naziv)")
                    hud.hide(animated: true)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Reachability.isConnectedToNetwork(){
        if let url = URL(string: kulturnaDesavanja.desavanja[indexPath.row].link){
        
           UIApplication.shared.open(url)
            
        }
        }else{
            alert()
        }
    }
    
    
    @IBAction func segmentDataClicled(_ sender: Any) {
        
        switch slider.selectedSegmentIndex {
        case 0:
            kulturnaDesavanja.readData(naziv: "manastiri", tableViewCustom: tableViewCustom)
        case 1:
            kulturnaDesavanja.readData(naziv: "istorijska_mesta", tableViewCustom: tableViewCustom)
        case 2:
            kulturnaDesavanja.readData(naziv: "izlozbe_koncerti", tableViewCustom: tableViewCustom)
        default:
            break
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
}
