//
//  ScanAfterChecklistVc.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 3/22/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import AVScanner
import AVFoundation
import SafariServices
import ALCameraViewController
import CoreLocation
import Alamofire
import SVProgressHUD

class ScanAfterChecklistVc: AVScannerViewController {

    var locationManager: CLLocationManager = CLLocationManager()
    var LocationDaraArr = [AnyObject]()
    
    var FirstQr = String()
    var SecondQr = String()
    var checklist_Arr = [String: Any]()
    var checklist_AnswerArr = [[String : Any]]()
    var AnswerImages = [AnyObject]()
    var projectId = String()
    var m_ticketStatus = String()
    var m_ticktetdata = [[String: Any]]()
    var Random_images = [AnsImage]()
    var second_lat = String()
    var second_long = String()
    var currentLocation: CLLocation!
    var ChecklistImages = [ImgeFromCam]()
    var cSubmitChecklist = SubmitChecklistData()
    var V_pass = String()
    var V_avg = String()
    var V_fail = String()
    var Percent = String()
    var Branch_id = String()
    var LocId = String()
    var Classification_id = String()
    var FilledChecklistArr = [[String: Any]]()
    var toast = JYToast()
    var date = Date()
    var StartTime = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        supportedMetadataObjectTypes = [.qr, .pdf417]
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
       
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        cSubmitChecklist.user_role = (lcDict["role"] as! String)
        cSubmitChecklist.com_id = (lcDict["com_id"] as! String)
        cSubmitChecklist.user_id = (lcDict["user_id"] as! String)
        
        prepareBarcodeHandler()
        prepareViewTapHandler()
        
       
    }
     
    private func prepareBarcodeHandler () {
        barcodeHandler = barcodeDidCaptured
    }
    
    private func prepareViewTapHandler() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapHandler))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func viewTapHandler(_ gesture: UITapGestureRecognizer)
    {
        guard !isSessionRunning else { return }
        startRunningSession()
    }
    
    lazy var barcodeDidCaptured: (_ codeObject: AVMetadataMachineReadableCodeObject) -> Void = { [unowned self] codeObject in
        let string = codeObject.stringValue!
        print(string)
        self.SecondQr = String(string.prefix(10))
        print(self.SecondQr)
        
        if self.FirstQr == self.SecondQr
        {
            self.sendChecklist()
        }else
        {
            self.toast.isShow("Location not match. Please try again")
        }
        
     }
    
    func setChecklistData(ChecklistArr : [String: Any], Checklist_Answer: [[String : Any]], Ans_images: [AnyObject], M_ticket_status: String, M_ticket_data: [[String: Any]], Random_image: [AnsImage], firstQr: String, Pid: String, classification_id: String, AllchecklistImages : [ImgeFromCam], start_time: String)
    {
        self.checklist_Arr = ChecklistArr
        self.checklist_AnswerArr = Checklist_Answer
        self.AnswerImages = Ans_images
        self.m_ticketStatus = M_ticket_status
        self.m_ticktetdata = M_ticket_data
        self.Random_images = Random_image
        self.FirstQr = firstQr
        self.projectId = Pid
        self.Classification_id = classification_id
        self.ChecklistImages = AllchecklistImages
        self.StartTime = start_time
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject:  object, options: []) else
        {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    
    func GetCurrentDate_Time() -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
    
    func sendChecklist()
    {
        let EndTime = GetCurrentDate_Time()
        
        var lcQueId : String = ""
        var lcQueImg : String = ""
        var Score : String!
        var OutOfLoc : String!
        LocationDaraArr = LocationData.cLocationData.fetchOfflineLocation()!
        
        let imgCount = self.ChecklistImages.count
        cSubmitChecklist.totalImages = String(imgCount)
        
        var lcMarkObtained: Float = 0.0
        var lcmaxmarks: Float = 0.0
        var lcFinalMarks: Float = 0.0
        var lcFinalmaxmarks: Float = 0.0
        
            self.V_pass = (self.checklist_Arr["c_pass_per"] as? String)!
            self.V_avg = (self.checklist_Arr["c_avg_per"] as? String)!
            self.V_fail = (self.checklist_Arr["c_fail_per"] as? String)!
            print(self.V_pass)
            print(V_avg)
            print(V_fail)
        
        
       for lcAnsChecklist in self.checklist_AnswerArr
        {
            let lcmarks_obtained = lcAnsChecklist["marks_obtained"] as! String
            lcMarkObtained = Float(lcmarks_obtained)!
            lcFinalMarks = lcFinalMarks + lcMarkObtained
            let lcmax_marks = lcAnsChecklist["max_marks"] as! String
            lcmaxmarks = Float(lcmax_marks)!
            lcFinalmaxmarks = lcFinalmaxmarks + lcmaxmarks
        }
        
        print("UpperNum", lcFinalMarks)
        print("LowerNum", lcFinalmaxmarks)
        
        let perCent = 100 * (lcFinalMarks / lcFinalmaxmarks)
        
        self.Percent = String(perCent)
        
        print(self.Percent)
        
        for(index, _) in LocationDaraArr.enumerated()
        {
            let LocEntity = LocationDaraArr[index] as! FetchLocation
            if (self.FirstQr == self.SecondQr) && (self.SecondQr == LocEntity.l_barcode)
            {
                Branch_id = LocEntity.branch_id!
                LocId = LocEntity.l_id!
                
                let lat = (LocEntity.l_latitude! as NSString).doubleValue
                let long = (LocEntity.l_longitude! as NSString).doubleValue
                
                let coordinate0 = CLLocation(latitude: lat, longitude:long)
                
                let coordinate1 = CLLocation(latitude: Double(self.second_lat)!, longitude: Double(self.second_long)!)
                
                
                let distanceInMeters = coordinate0.distance(from: coordinate1)
                
                if(distanceInMeters <= 500)
                {
                    OutOfLoc = "0"
                    
                    if(self.Percent<V_fail){
                       //failed
                        Score = "0"
                    }else if(self.Percent<V_avg){
                        //average
                        Score = "1"
                    }else if(self.Percent <= V_pass || self.Percent > V_pass){
                        //passed
                        Score = "2"
                    }else {
                        Score = "0"
                    }
                }
                else
                {
                    OutOfLoc = "1"
                    Score = "0"
                }
             }
         }
        
        if self.Random_images.isEmpty == false
        {
            for (_, lCImage) in self.Random_images.enumerated()
            {
                lcQueId = lCImage.q_id!
                lcQueImg = lCImage.se_img_url!
            }
        }else
        {
            lcQueId = ""
            lcQueImg = ""
        }
        
        let Filled_Checklist : [String: Any] =
            [
                "b_id" : self.Branch_id,
                "cl_id" : self.Classification_id,
                "end_time" : EndTime,
                "l_id" : self.LocId,
                "l_lat" : self.second_lat,
                "l_long" : self.second_long,
                "out_of_loc" : OutOfLoc,
                "p_id" : self.projectId,
                "percentage" : self.Percent,
                "rand_q_id" :   lcQueId,
                "rand_q_photo" : lcQueImg,
                "score" : Score,
                "start_time" : self.StartTime
            ]
        self.FilledChecklistArr.append(Filled_Checklist)
        sendData()
        
    }
    
    func sendData()
    {
        cSubmitChecklist.m_ticket_status = m_ticketStatus
        cSubmitChecklist.m_ticket_data = json(from: m_ticktetdata.self)
        cSubmitChecklist.totalImages = String(self.ChecklistImages.count)
        cSubmitChecklist.checklist_answer = json(from: self.checklist_AnswerArr)
        cSubmitChecklist.filled_checklist = json(from: self.FilledChecklistArr)
        
        if self.AnswerImages.count != 0
        {
            cSubmitChecklist.answer_image = json(from: self.AnswerImages)
        }else
        {
           cSubmitChecklist.answer_image = ""
        }
       
      
        
        let uploadUrl = "http://kanishkagroups.com/Qualus/index.php/AndroidV2/Checklist/upload_filled_checklist"
        
        let Param : [String: Any] =
            [ "totalImages" : cSubmitChecklist.totalImages!,
              "filled_checklist" : cSubmitChecklist.filled_checklist!,
              "checklist_answer" : cSubmitChecklist.checklist_answer!,
              "answer_image" : cSubmitChecklist.answer_image!,
              "m_ticket_status" : cSubmitChecklist.m_ticket_status!,
              "m_ticket_data" : cSubmitChecklist.m_ticket_data!,
              "user_id" : cSubmitChecklist.user_id!,
              "user_role" : cSubmitChecklist.user_role!,
              "com_id" : cSubmitChecklist.com_id!,
              ]
        print("Param", Param)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                if self.ChecklistImages.isEmpty
                {
                    print("no Image for upload")
                    self.cSubmitChecklist.Images = "NF"
                }else{
                    
                    for (index, lCImage) in self.ChecklistImages.enumerated()
                    {
                        let image = lCImage.CamImag
                        print(index)
                        let data = UIImageJPEGRepresentation(image!,0.0)
                        multipartFormData.append(data!, withName: "images" + String(format:"%d",index), fileName: lCImage.ImagName, mimeType: "image/jpeg")
                    }
                    
                }
                SVProgressHUD.show()
                
                for (key, val) in Param {
                    multipartFormData.append((val as AnyObject).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue).rawValue)!, withName: key)
                }
        },
            
            usingThreshold : SessionManager.multipartFormDataEncodingMemoryThreshold,
            to : uploadUrl,
            method: .post)
        { (result) in
            
            switch result
            {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { resp in
                    
                    switch resp.result
                    {
                    case .success(_):
                        
                        
                        if let JSON = resp.result.value as? [String: Any] {
                            print("Response : ",JSON)
                            
                            OperationQueue.main.addOperation {
                                SVProgressHUD.dismiss()
                            }
                            
                            
                            let msg = JSON["msg"] as! String
                            if msg == "SUCCESS"
                            {
                               
                                for controller in self.navigationController!.viewControllers as Array {
                                   
                                    if self.cSubmitChecklist.user_role == "2"
                                    {
                                        if controller.isKind(of: SuperVisorProjectListVc.self) {
                                            _ =  self.navigationController!.popToViewController(controller, animated: true)
                                            break
                                        }
                                    }
                                    else
                                    {
                                      
                                        if controller.isKind(of: ProjectInfoVc.self) {
                                            _ =  self.navigationController!.popToViewController(controller, animated: true)
                                            break
                                        }
                                    }
                                }
                                self.toast.isShow("Checkist submitted successfully")
                                
                                
                                
                            }else
                            {
                                self.toast.isShow("Something went wrong")
                                
                            }
                            
                        }
                        
                        break
                        
                    case .failure(_):
                        OperationQueue.main.addOperation {
                            SVProgressHUD.dismiss()
                        }
                        self.toast.isShow("Something went wrong. Please check network connection")
                        
                        break
                    }
                    
                }
                
            case .failure(let encodingError):
                OperationQueue.main.addOperation {
                    SVProgressHUD.dismiss()
                }
                print(encodingError)
            }
            
        }
        
    }
    
    
    
}
extension ScanAfterChecklistVc : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
            currentLocation = locationManager.location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.first != nil {
         
            let lastLocation: CLLocation = locations[locations.count - 1]
            
            self.second_lat = String(format: "%.6f", lastLocation.coordinate.latitude)
            
            self.second_long = String(format: "%.6f", lastLocation.coordinate.longitude)
            
    
        }
        
    }
    
}
