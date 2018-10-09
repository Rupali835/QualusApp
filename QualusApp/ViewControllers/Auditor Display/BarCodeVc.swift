//
//  BarCodeVc.swift
//  QualusApp
//
//  Created by user on 28/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class BarCodeVc: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var numberCollview: UICollectionView!
    @IBOutlet weak var lblOne: UILabel!
    @IBOutlet weak var lblTwo: UILabel!
    @IBOutlet weak var lblFour: UILabel!
    @IBOutlet weak var lblThree: UILabel!
    @IBOutlet weak var lblFive: UILabel!
    @IBOutlet weak var lblZero: UILabel!
    @IBOutlet weak var lblNine: UILabel!
    @IBOutlet weak var lblEight: UILabel!
    @IBOutlet weak var lblSeven: UILabel!
    @IBOutlet weak var lblSix: UILabel!
    
    var numberArr : [Any] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "backspace-arrow.png","0","right.png"]
    var pId : String = ""
    var toast = JYToast()
    var barcodeStr = String()
    var LocationDaraArr = [AnyObject]()
    var MapLocationDataArr = [AnyObject]()
    var showvc = Bool()
    var locationManager: CLLocationManager = CLLocationManager()
    var Latitude : String = ""
    var Longitude : String = ""
    var L_id : String = ""
    var U_id : String = ""
    var secondBarCode : String = ""
    var setSecondBarcode : Int!
    
    override func viewDidLoad()
    {   super.viewDidLoad()
        
          let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        self.U_id = lcDict["user_id"] as! String
        numberCollview.delegate = self
        numberCollview.dataSource = self
        setupNavigationBar()
        self.setLblColor(cLbl: lblOne)
        self.setLblColor(cLbl: lblTwo)
        self.setLblColor(cLbl: lblThree)
        self.setLblColor(cLbl: lblFour)
        self.setLblColor(cLbl: lblFive)
        self.setLblColor(cLbl: lblSix)
        self.setLblColor(cLbl: lblSeven)
        self.setLblColor(cLbl: lblEight)
        self.setLblColor(cLbl: lblNine)
        self.setLblColor(cLbl: lblZero)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self 
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        LocationDaraArr = LocationData.cLocationData.fetchOfflineLocation()!
        MapLocationDataArr = MapLocation.cMapLocationData.fetchOfflineMapLocation()!
        
     }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation: CLLocation = locations[locations.count - 1]
        
        let ent = FetchLocation.self
        
        self.Latitude = String(format: "%.6f", lastLocation.coordinate.latitude)
        self.Longitude = String(format: "%.6f", lastLocation.coordinate.longitude)
       
        UserDefaults.standard.set(self.Latitude, forKey: "lat")
        UserDefaults.standard.set(self.Longitude, forKey: "long")
        
    }

    
    func setupNavigationBar()
    {
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 375, height: 74))
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "Barcode");
        let BackItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: nil, action: #selector(closedView));
        navItem.leftBarButtonItem = BackItem;
        navBar.setItems([navItem], animated: false);
    }
    
    @objc func closedView()
    {
        self.dismiss(animated: true, completion: nil)
        //navigationController?.popViewController(animated: true)
    }
    
    
    func setLblColor(cLbl : UILabel)
    {
        cLbl.layer.borderColor = UIColor(red:0.25, green:0.32, blue:0.71, alpha:1.0).cgColor
        cLbl.layer.borderWidth = 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return numberArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = numberCollview.dequeueReusableCell(withReuseIdentifier: "barcodeNumberCell", for: indexPath) as! barcodeNumberCell
        self.designView(cView: cell.backView)
        let lcNum: String = numberArr[indexPath.item] as! String
        
        if ((indexPath.row == 9) || (indexPath.row == 11))
        {
            cell.btnNumber.setTitle("", for: .normal)
            cell.btnNumber.setImage(UIImage(named: lcNum), for: .normal)
        }else
        {
          cell.btnNumber.setTitle(lcNum, for: .normal)
        }
        
        cell.btnNumber.tag = indexPath.row
        return cell
    }

   func SubmitBarcode()
    {
        if (barcodeStr.characters.count == 10)
            {
//                if self.MapLocationDataArr.isEmpty == false
//                {
                      for (index, _) in LocationDaraArr.enumerated()
                    {
                        let locationEnt = LocationDaraArr[index] as! FetchLocation
                        
                        if pId == locationEnt.p_id!
                        {
                            if locationEnt.l_barcode == self.barcodeStr
                            {
                                if showvc == true
                                {
                           
                                    if (locationEnt.l_latitude == "NF") || (locationEnt.l_longitude == "NF")
                                    {
                                        self.setLocation()
                                    }else{
                                        
                                        let checklistVc = storyboard?.instantiateViewController(withIdentifier: "CheckListByLocationVc") as! CheckListByLocationVc
                                        
                                        checklistVc.setQrString(cQr: barcodeStr, ProjId: self.pId, Showvc: showvc)
                                        self.navigationController?.pushViewController(checklistVc, animated: true)
                                    }
                                    //break
                                }else{
                                    
    //                                self.toast.isShow("Location Found")
                                    
                                    let cMaverickTikt = storyboard?.instantiateViewController(withIdentifier: "GenarateMaverickTicketVc") as! GenarateMaverickTicketVc
                                    cMaverickTikt.setQrString(cQr: barcodeStr)
                                    cMaverickTikt.showVc = false
                                    self.navigationController?.pushViewController(cMaverickTikt, animated: true)
                                    
                                }
                            }else
                            {
                                self.toast.isShow("No such location found")
                            }
                        }
                        else
                        {
                            //self.toast.isShow("Location Found")
                        }
                        
                    }
 //           }
               
                
            }else{
                
                self.toast.isShow("Enter all digits")
            }

    }
    
    func designView(cView: UIView)
    {
        cView.layer.borderColor = UIColor(red:0.25, green:0.32, blue:0.71, alpha:1.0).cgColor
         cView.layer.borderWidth = 1.0
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
       let txtNum = numberArr[indexPath.item]
       
        if indexPath.row == 11
        {
            self.SubmitBarcode()
            return
        }
        
        if indexPath.row == 9
        {
            self.backSpace()
            return
        }
        
        if lblOne.text == ""
        {
            lblOne.text = txtNum as? String
            barcodeStr += lblOne.text!

        }else if lblTwo.text == ""
        {
            lblTwo.text = txtNum as? String
             barcodeStr += lblTwo.text!
            
        }else if lblThree.text == ""
        {
            lblThree.text = txtNum as? String
             barcodeStr += lblThree.text!
            
        }else if lblFour.text == ""
        {
            lblFour.text = txtNum as? String
             barcodeStr += lblFour.text!
            
        }else if lblFive.text == ""
        {
            lblFive.text = txtNum as? String
             barcodeStr += lblFive.text!
            
        }else if lblSix.text == ""
        {
            lblSix.text = txtNum as? String
             barcodeStr += lblSix.text!
            
        }else if lblSeven.text == ""
        {
            lblSeven.text = txtNum as? String
             barcodeStr += lblSeven.text!
            
        }else if lblEight.text == ""
        {
            lblEight.text = txtNum as? String
             barcodeStr += lblEight.text!
            
        }else if lblNine.text == ""
        {
            lblNine.text = txtNum as? String
             barcodeStr += lblNine.text!
            
        }else if lblZero.text == ""
        {
            lblZero.text = txtNum as? String
             barcodeStr += lblZero.text!
        }
        
        if setSecondBarcode == 0
        {
            self.secondBarCode = barcodeStr
            
            if self.secondBarCode.count == 10
            {
                let LAT = UserDefaults.standard.value(forKey: "lat")
                let LONG = UserDefaults.standard.value(forKey: "long")
                
                let secstr = UserDefaults.standard.string(forKey: "barcodeStr")
                if self.secondBarCode == secstr!
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChecklistQueForBarcodeVC") as! ChecklistQueForBarcodeVC
                    vc.sendToserver(secStr: self.secondBarCode, lat: LAT as! String, long: LONG as! String)
                    
                     self.view.removeFromSuperview()
                }
            }
            
         
        }
        
        print(barcodeStr)
        if barcodeStr.count == 10
        {
            UserDefaults.standard.setValue(barcodeStr, forKeyPath: "barcodeStr")
        }
     
    }
    
    func setLocation()
    {
        for (index, _) in LocationDaraArr.enumerated()
        {
            let locationEnt = LocationDaraArr[index] as! FetchLocation
            
            if locationEnt.l_barcode == self.barcodeStr
            {
                self.L_id = locationEnt.l_id!
                
            }
            
        }
 
        let url = "http://kanishkagroups.com/Qualus/index.php/AndroidV2/Location/update_location_lat_long"
        let Param : [String : Any] = ["l_id" : self.L_id,
                                            "u_id" : self.U_id,
                                            "lat" : self.Latitude,
                                            "long" : self.Longitude]
        
      
        Alamofire.request(url, method: .post, parameters: Param).responseJSON { (resp) in
         
            
        }
    
    }
    
   func backSpace()
   {
 
    let result = String(barcodeStr.dropLast())
  
    
    barcodeStr = result
    
        if lblZero.text != ""
        {
            lblZero.text = ""
            
        }else if lblNine.text != ""
        {
            lblNine.text = ""
            
        }else if lblEight.text != ""
        {
            lblEight.text = ""
            
        }else if lblSeven.text != ""
        {
            lblSeven.text = ""
            
        }else if lblSix.text != ""
        {
            lblSix.text = ""
            
        }else if lblFive.text != ""
        {
            lblFive.text = ""
            
        }else if lblFour.text != ""
        {
            lblFour.text = ""
            
        }else if lblThree.text != ""
        {
            lblThree.text = ""
            
        }else if lblTwo.text != ""
        {
            lblTwo.text = ""
            
        }else if lblOne.text != ""
        {
            lblOne.text = ""
         }
    
}
    
    
}
