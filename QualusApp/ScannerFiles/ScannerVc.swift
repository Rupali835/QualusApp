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
    var valForFilledChecklist : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        self.U_id = lcDict["user_id"] as! String
        
        prepareBarcodeHandler()
        prepareViewTapHandler()
        
        initUi()
        //view.bringSubview(toFront: cameraButton)
        supportedMetadataObjectTypes = [.qr, .pdf417]
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        LocationDaraArr = LocationData.cLocationData.fetchOfflineLocation()!
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation: CLLocation = locations[locations.count - 1]
        
        self.Latitude = String(format: "%.6f", lastLocation.coordinate.latitude)
        
        let ent = FetchLocation.self
        
        
        self.Longitude = String(format: "%.6f", lastLocation.coordinate.longitude)
        
    }
    
   
    private func initUi()
    {
        toast = JYToast()
    }
   
    deinit {
        print("deinit")
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
        self.showvc = bShowVC
    }
    
    // Be careful with retain cycle
    lazy var barcodeDidCaptured: (_ codeObject: AVMetadataMachineReadableCodeObject) -> Void = { [unowned self] codeObject in
        let string = codeObject.stringValue!
        print(string)
        
        if self.valForFilledChecklist == 0
        {
            let c_filledChecklist = self.storyboard?.instantiateViewController(withIdentifier: "ChecklistQuestionsVc") as! ChecklistQuestionsVc
            c_filledChecklist.SecQrStr = string
            c_filledChecklist.setSecQr(secQrStr: string)
            self.navigationController?.pushViewController(c_filledChecklist, animated: true)
        }else{
           
            
            UserDefaults.standard.set(string, forKey: "QRCode")
            
            self.showvc = true
            for (index, _) in self.LocationDaraArr.enumerated()
            {
                let locationEnt = self.LocationDaraArr[index] as! FetchLocation
                
                if self.PId == locationEnt.p_id!
                {
                    if locationEnt.l_barcode == string
                    {
                        if self.showvc == true
                        {
                            if (locationEnt.l_latitude == "NF") || (locationEnt.l_longitude == "NF")
                            {
                                self.setLocation(QR: string)
                            }else
                            {
                                self.toast.isShow("Location Found")
                                let checklistVc = self.storyboard?.instantiateViewController(withIdentifier: "CheckListByLocationVc") as! CheckListByLocationVc
                                
                                self.showvc = false
                                checklistVc.setQrString(cQr: string, ProjId: self.PId, Showvc: self.showvc)
                                self.navigationController?.pushViewController(checklistVc, animated: true)
                                
                            }
                            
                        }else{
                            
                            self.toast.isShow("Location Found")
                            
                            let cMaverickTikt = self.storyboard?.instantiateViewController(withIdentifier: "GenarateMaverickTicketVc") as! GenarateMaverickTicketVc
                            cMaverickTikt.setQrString(cQr: string)
                            cMaverickTikt.showVc = true
                            self.navigationController?.pushViewController(cMaverickTikt, animated: true)
                        }
                    }
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
        
        print(Param)
        Alamofire.request(url, method: .post, parameters: Param).responseJSON { (resp) in
            print(resp)
            
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
