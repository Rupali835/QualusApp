//
//  ScannerVc.swift
//  QualusApp
//
//  Created by user on 26/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import AVScanner
import AVFoundation
import SafariServices
import ALCameraViewController
import CoreLocation
import Alamofire

class ScannerVc: AVScannerViewController, CLLocationManagerDelegate
{
    var cChecklist : CheckListByLocationVc!
    private var toast : JYToast!
    var showvc: Bool!
    var PId : String = ""
    var Latitude : String = ""
    var Longitude : String = ""
    var L_id : String = ""
    var U_id : String = ""
    var locationManager: CLLocationManager = CLLocationManager()
    var LocationDaraArr = [AnyObject]()
    var valForFilledChecklist = Int(1)
    var firstQR : String = ""
    var SecondQR : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        self.U_id = lcDict["user_id"] as! String
        self.valForFilledChecklist = 1
        prepareBarcodeHandler()
        prepareViewTapHandler()
        
        initUi()
        //view.bringSubview(toFront: cameraButton)
        supportedMetadataObjectTypes = [.qr, .pdf417]
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        UserDefaults.standard.set(1, forKey: "ForFilledChecklist")
        LocationDaraArr = LocationData.cLocationData.fetchOfflineLocation()!
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation: CLLocation = locations[locations.count - 1]
        
        self.Latitude = String(format: "%.6f", lastLocation.coordinate.latitude)
        
        let ent = FetchLocation.self
        
        
        self.Longitude = String(format: "%.6f", lastLocation.coordinate.longitude)
        
      UserDefaults.standard.set(self.Latitude, forKey: "lat")
      UserDefaults.standard.set(self.Longitude, forKey: "long")
      
      }
    
   
    private func initUi()
    {
        toast = JYToast()
    }
   
   
    
    // MARK: - Prepare viewDidLoad
    
    private func prepareBarcodeHandler () {
        barcodeHandler = barcodeDidCaptured
    }
    
    private func prepareViewTapHandler() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapHandler))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func GetData(pid: String, bShowVC: Bool)
    {
        self.PId = pid
        self.showvc = bShowVC     // from ProjectInfoVc
    }
    
    
    
    // Be careful with retain cycle
    lazy var barcodeDidCaptured: (_ codeObject: AVMetadataMachineReadableCodeObject) -> Void = { [unowned self] codeObject in
        let string = codeObject.stringValue!
        print(string)
        
        let str = "SampleText"
        let QrStr = String(string.prefix(10))
        print(QrStr)// result = "Sampl"
        print("Vaue= \(self.valForFilledChecklist)")
        
        let lcValForFilledChecklist = UserDefaults.standard.value(forKey: "ForFilledChecklist") as? Int
        
        if lcValForFilledChecklist == 0
        {
            if self.firstQR != ""
            {
                let LAT = UserDefaults.standard.value(forKey: "lat")
                let LONG = UserDefaults.standard.value(forKey: "long")
                
                print(self.firstQR)
                if self.firstQR == QrStr
                {
                    print("get")
                   
                    let cQvc = self.storyboard?.instantiateViewController(withIdentifier: "ChecklistQuestionsVc") as! ChecklistQuestionsVc
                    cQvc.sendDataToServer(checklocation : true, lat: LAT as! String, long: LONG as! String, secqr: QrStr, pId: self.PId)
                
                    self.navigationController?.pushViewController(cQvc, animated: true)
                }else
                {
                    self.toast.isShow("Location not match")
                }
            }
        }else{

        
            UserDefaults.standard.set(QrStr, forKey: "QRCode")
            let data = UserDefaults.standard.value(forKey: "QRCode")
            self.firstQR = data as! String
            print(self.firstQR)
            
            for (index, _) in self.LocationDaraArr.enumerated()
            {
                let locationEnt = self.LocationDaraArr[index] as! FetchLocation
                
                if self.PId == locationEnt.p_id!
                {
                    if locationEnt.l_barcode == QrStr
                    {
                        if self.showvc == true
                        {
                            if (locationEnt.l_latitude == "NF") || (locationEnt.l_longitude == "NF")
                            {
                                self.setLocation(QR: QrStr)
                            }else
                            {
                                self.toast.isShow("Location Found")
                                let checklistVc = self.storyboard?.instantiateViewController(withIdentifier: "CheckListByLocationVc") as! CheckListByLocationVc
                                
                                self.showvc = false
                                checklistVc.setQrString(cQr: QrStr, ProjId: self.PId, Showvc: self.showvc)
                                self.navigationController?.pushViewController(checklistVc, animated: true)
                            }
                            
                        }else{
                            
                            self.toast.isShow("Location Found")
                            
                            let cMaverickTikt = self.storyboard?.instantiateViewController(withIdentifier: "GenarateMaverickTicketVc") as! GenarateMaverickTicketVc
                            cMaverickTikt.setQrString(cQr: QrStr)
                            cMaverickTikt.showVc = true
                            self.navigationController?.pushViewController(cMaverickTikt, animated: true)
                        }
                    }
                }else{
                    let alert = UIAlertController(title: "Qualus", message: "Location not match. Please Rescan.", preferredStyle: .alert)
                    
                  alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true)
                }
            }
        }
       
    }
    
    
    
    func setLocation(QR : String)
    {
        for (index, _) in LocationDaraArr.enumerated()
        {
            let locationEnt = LocationDaraArr[index] as! FetchLocation
            
            if locationEnt.l_barcode == QR
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

    @objc func viewTapHandler(_ gesture: UITapGestureRecognizer)
    {
        guard !isSessionRunning else { return }
        startRunningSession()
    }
}

fileprivate extension ScannerVc {
    @available(iOS 9.0, *)
    func openSafariViewController(with url: URL) {
        let safariView = SFSafariViewController(url: url)
        safariView.modalPresentationStyle = .popover
        present(safariView, animated: true, completion: nil)
    }

  
}
