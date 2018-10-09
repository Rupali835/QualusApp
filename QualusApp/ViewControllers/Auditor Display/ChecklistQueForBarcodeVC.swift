//
//  ChecklistQueForBarcodeVC.swift
//  QualusApp
//
//  Created by user on 13/08/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ChecklistQueForBarcodeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate
{
   
    @IBOutlet weak var tblQueChecklist: UITableView!
    
    @IBOutlet var ViewLastBarcode: UIView!
    
    @IBOutlet weak var btnLastYes_click: UIButton!
    
    var toast = JYToast()
    var QuestionArray = [AnyObject]()
    var ClassificationId : String!
    var Qcell : ChecklistQuetionCell!
    var selectedIndex = Int(-1)
    var checkBtn = Bool(true)
  
    var formValid = Bool(false)
  
    var dictArr             = [Any]()           //para
    var libraryEnabled      : Bool = false
    var croppingEnabled     : Bool = false
    var allowResizing       : Bool = true
    var allowMoving         : Bool = false
    var deletindex          : Int = 0
    var withHUD             : Bool!
    var minimumSize         : CGSize = CGSize(width: 60, height: 60)
    var date =  Date()
    var Latitude : String = ""
    var Longitude : String = ""
    var locationManager: CLLocationManager = CLLocationManager()
    var cSubmitChecklist = SubmitChecklistData()
    var m_cAnswerChecklist = [AnswerChecklist]()
    var m_cAnswerChecklistObj = AnswerChecklist()
    var m_cAnsImage = [AnsImage]()
    var m_cTicketData = [MtickectData]()
    var AnsChecklistArr = [[String: Any]]()
    var LocationDaraArr = [AnyObject]()
    var QrStr : String = ""
    var ProjId : String!
    
    var m_cImageArrFromCam = [ImgeFromCam]()
    var SelectedIndexArr = [ImgeFromCam]()
    
    var bCameraStatus = Bool(false)
 
    var SelectedImgArr   = [UIImage]()
    var UnSelectedImgArr = [UIImage]()
   
    var popUp : KLCPopup!
    //images
    var filePath            : String!
    var imgArr              = [String]()           //images name string
            //para
    var filePathArr         = [Any]()            //imagepath
    var ImageArr            = [UIImage]()   //count of images
    var imageNameArr        = [String]()
    var m_cTicketDataObj = MtickectData()
  
    var TicketDataArr = [[String: Any]]()
    var FilledChecklistArr = [[String: Any]]()
   
    var ClsfitnArr = [AnyObject]()
    var ClsQueArr = [AnyObject]()
   
    var M_Ticket_Status = String()
   
    var AnswerImgArr = [AnyObject]()
    var ImgUrl : URL!
  
    var Branchid : String!
    var Locid : String!
    var CheckListArr = [AnyObject]()
    var Percent: String!
    var V_pass : String!
    var V_avg : String!
    var StartTimr : String!
    var EndTime : String!
    var gettingImg : UIImage!
    var RandomQueId :  String!
    var b_randomQueImg = Bool(false)
    var Random : Int!
   
    var SecQrStr : String = ""
    var QrCodeStrSec : String = ""
     var TicketDict = [String: Any]()
    var cBarcode : BarCodeVc!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        popUp = KLCPopup()
        tblQueChecklist.delegate = self
        tblQueChecklist.dataSource = self
        
        self.bCameraStatus = false
        self.selectedIndex = -1
      
        tblQueChecklist.separatorStyle = .none
        tblQueChecklist.registerCellNib(QueTypeOneBarcodeCell.self)
        tblQueChecklist.registerCellNib(QueTypeTwoBarcodeCell.self)

        self.tblQueChecklist.estimatedRowHeight = 80
        self.tblQueChecklist.rowHeight = UITableViewAutomaticDimension
    
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.tblQueChecklist.addGestureRecognizer(dismissKeyboardGesture)
        
        self.m_cImageArrFromCam.removeAll(keepingCapacity: false)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd, hh:mm:ss"
        let DATE = formatter.string(from: date)
        print(DATE)
        self.StartTimr = DATE
        UserDefaultsVal()
        setLocation()
         LocationDaraArr = LocationData.cLocationData.fetchOfflineLocation()!
     
    }

    func UserDefaultsVal()
    {
        UserDefaults.standard.set(self.QrStr, forKey: "QRCode")
        
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        cSubmitChecklist.user_role = lcDict["role"] as! String
        cSubmitChecklist.com_id = lcDict["com_id"] as! String
        cSubmitChecklist.user_id = lcDict["user_id"] as! String
        
        UserDefaults.standard.set(self.CheckListArr, forKey: "CheckListArr")
        UserDefaults.standard.setValue(self.ProjId, forKey: "ProjId")
        UserDefaults.standard.set(self.ClassificationId, forKey: "ClassificationId")
        
    }
    
    
    func setLocation()
    {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    override func awakeFromNib()
    {
        self.cBarcode = self.storyboard?.instantiateViewController(withIdentifier: "BarCodeVc") as! BarCodeVc
    }
    
    func sendToserver(secStr : String, lat : String, long : String)
    {
        self.Latitude = lat
        self.Longitude = long
        self.SecQrStr = secStr

        
        if (self.Latitude != "") && (self.Longitude != "")
        {
            self.setFilledChecklistBARCODE()
        }else{
            self.toast.isShow("something went wrong")
        }
    }
    
// MARK : TABLEVIEW - METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.QuestionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let lcDict = QuestionArray[indexPath.row]
        print(lcDict)
        let indexNumber = indexPath.row + 1
        print(indexPath.row)

        let Qtype = lcDict["c_q_type"] as! String
        
        if Qtype == "1"
        {
            let cell = tblQueChecklist.dequeueReusableCell(withIdentifier: "QueTypeOneBarcodeCell", for: indexPath) as! QueTypeOneBarcodeCell
            
            let Qstr = lcDict["c_q_question"] as! String
            cell.backView.applyShadowAndRadiustoView()
            cell.lblQuestion.text = "Q." + String(indexNumber) + "  " + Qstr
            
            cell.btnYES.tag = indexPath.row
            cell.btnNO.tag = indexPath.row
            cell.btnNA.tag = indexPath.row
            
            cell.btnYES.addTarget(self, action: #selector(btnYES_OnClick(sender:)), for: .touchUpInside)
            cell.btnNO.addTarget(self, action: #selector(btnNO_OnClick(sender:)), for: .touchUpInside)
            cell.btnNA.addTarget(self, action: #selector(btnNA_OnClick(sender:)), for: .touchUpInside)
            cell.btnSubmit.addTarget(self, action: #selector(btnSubmit_OnClick(sender:)), for: .touchUpInside)
            
            
            return cell
        }else
        {
            let cell = tblQueChecklist.dequeueReusableCell(withIdentifier: "QueTypeTwoBarcodeCell", for: indexPath) as! QueTypeTwoBarcodeCell
        
            let Qstr = lcDict["c_q_question"] as! String
            cell.backView.applyShadowAndRadiustoView()
            cell.lblQuetion.text = "Q." + String(indexNumber) + "  " + Qstr
            
            cell.btnSubmit.tag = indexPath.row
            cell.btnSubmit.addTarget(self, action: #selector(btnSubmit_OnClick(sender:)), for: .touchUpInside)
            
            return cell
        }
        
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    
// MARK : BUTTON - ACTIONS
    
   @IBAction func btnDone_OnClick(_ sender: Any)
    {
        popUp.contentView = ViewLastBarcode
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = false
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
    }
   
// MARK : EXTRA - METHODS
   
    
    @objc func btnYES_OnClick(sender: UIButton)
    {
        self.view.endEditing(true)
        let cell = GetIndexPath(sender: sender as! DLRadioButton)
        cell.btnYES.tag = 1
        m_cAnswerChecklistObj.ans = "1"
    }
    
    @objc func btnNO_OnClick(sender: UIButton)
    {
        self.view.endEditing(true)
        let cell = GetIndexPath(sender: sender as! DLRadioButton)
        cell.btnNO.tag = 2
        m_cAnswerChecklistObj.ans = "2"
    }
    
    @objc func btnNA_OnClick(sender: UIButton)
    {
        self.view.endEditing(true)
        let cell = GetIndexPath(sender: sender as! DLRadioButton)
        cell.btnNA.tag = 3
        m_cAnswerChecklistObj.ans = "0"
    }
    
    @objc func btnSubmit_OnClick(sender: UIButton)
    {
         let QRString = UserDefaults.standard.string(forKey: "QRCode")
        self.QrStr = QRString!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd, hh:mm:ss"
        let DATE = formatter.string(from: date)
        print(DATE)
        
        let lcDict = QuestionArray[sender.tag]
        m_cAnswerChecklistObj.q_type = lcDict["c_q_type"] as! String
        var AnsListDict = [String: Any]()
        let QueMarks = lcDict["c_q_marks"] as! String
        let Qstr = lcDict["c_q_question"] as! String
        m_cAnswerChecklistObj.max_marks = QueMarks
        m_cAnswerChecklistObj.q_id = lcDict["c_q_id"] as! String
        
        if m_cAnswerChecklistObj.q_type == "1"
        {
            let indexpath = IndexPath(row: sender.tag, section: 0)
            let cell = self.tblQueChecklist.cellForRow(at: indexpath) as! QueTypeOneBarcodeCell
            
            
            if ((cell.btnYES.tag == 0) && (cell.btnNO.tag == 0) && (cell.btnNA.tag == 0))
            {
                self.toast.isShow("Please select answer")
                return
            }
            
            if cell.btnNO.tag == 2
            {
                if cell.txtRemark.text == ""
                {
                    self.toast.isShow("Please enter remark")
                    return
                    
                }
                
            }
            
            if cell.btnYES.tag == 1
            {
                m_cAnswerChecklistObj.marks_obtained = QueMarks
            }else if cell.btnNO.tag == 2
            {
                m_cAnswerChecklistObj.marks_obtained = "0"
            }else if cell.btnNA.tag == 3
            {
                m_cAnswerChecklistObj.marks_obtained = "0"
            }
            cSubmitChecklist.m_ticket_status = "0"
            cSubmitChecklist.m_ticket_data = "NF"
           
        UserDefaults.standard.setValue(cSubmitChecklist.m_ticket_status, forKey: "m_ticket_status")
            
        UserDefaults.standard.setValue(cSubmitChecklist.m_ticket_data, forKey: "m_ticket_data")

            
            
            AnsListDict["ans"] = m_cAnswerChecklistObj.ans
            AnsListDict["answered_time"] = DATE
            AnsListDict["input"] = "0"
            AnsListDict["marks_obtained"] = m_cAnswerChecklistObj.marks_obtained
            AnsListDict["max_marks"] = m_cAnswerChecklistObj.max_marks
            AnsListDict["photo_status"] = "0"
            AnsListDict["q_id"] = m_cAnswerChecklistObj.q_id
            AnsListDict["q_type"] = m_cAnswerChecklistObj.q_type
            
            if cell.txtRemark.text != ""
            {
                AnsListDict["remark"] = "\(cell.txtRemark.text!)"
            }else{
                AnsListDict["remark"] = "NF"
            }
            
            self.AnsChecklistArr.append(AnsListDict)
            
            UserDefaults.standard.setValue(self.AnsChecklistArr, forKey: "AnsChecklistArr")
            
            cell.backView.backgroundColor = UIColor(red:1.00, green:0.89, blue:0.77, alpha:1.0)
            cell.backView.isUserInteractionEnabled = false
            
            
        }else{
            let indexpath = IndexPath(row: sender.tag, section: 0)
            
            let cell = self.tblQueChecklist.cellForRow(at: indexpath) as! QueTypeTwoBarcodeCell
            
            if cell.txtAnswer.text == ""
            {
                self.toast.isShow("Please select answer")
                return
            }else if cell.txtRemark.text == ""
            {
                self.toast.isShow("Rematk is mandatory")
                return
                
            }
            
            if m_cAnswerChecklistObj.q_type == "3"
            {
                if cell.txtAnswer.text == ""
                {
                    self.toast.isShow("Please select answer")
                    return
                }
                let InputVal = cell.txtAnswer.text

                if InputVal != ""
                {
                    let minVal = lcDict["c_q_min_value"] as! String
                    let maxVal = lcDict["c_q_max_value"] as! String

                    if minVal...maxVal ~= InputVal! {
                        m_cAnswerChecklistObj.marks_obtained = QueMarks
                        m_cAnswerChecklistObj.ans = "1"
                        cSubmitChecklist.m_ticket_status = "0"
                        self.TicketDataArr = []
                        
        UserDefaults.standard.setValue(cSubmitChecklist.m_ticket_status, forKey: "m_ticket_status")
                        
                    } else {
                        m_cAnswerChecklistObj.marks_obtained = "0"
                        m_cAnswerChecklistObj.ans = "2"
                        cSubmitChecklist.m_ticket_status = "1"
                        
        UserDefaults.standard.setValue(cSubmitChecklist.m_ticket_status, forKey: "m_ticket_status")
                        
//      m_ticket_data is send
                        
           for(index, _) in LocationDaraArr.enumerated()
             {
                  let LocEntity = LocationDaraArr[index] as! FetchLocation
                        
                    if LocEntity.l_barcode == self.QrStr
                    {
                        Branchid = LocEntity.branch_id
                        Locid = LocEntity.l_id
                    }
                }
                    
                        
                TicketDict["action_plan"] = "NF"
                TicketDict["l_barcode"] = QrStr
                TicketDict["l_id"] = Locid!
                TicketDict["mt_photo"] = ""
                TicketDict["mt_remark"] = cell.txtRemark.text!
                TicketDict["mt_subject"] = Qstr
                TicketDict["p_id"] = self.ProjId!
                TicketDict["pb_id"] = Branchid!
                TicketDict["q_id"] = m_cAnswerChecklistObj.q_id!
                self.TicketDataArr.append(TicketDict)
                        
//                 UserDefaults.standard.setValue(self.TicketDataArr, forKeyPath: "TicketDataArr")
                        
        cSubmitChecklist.m_ticket_data = json(from: self.TicketDataArr)
        UserDefaults.standard.setValue(cSubmitChecklist.m_ticket_data, forKey: "m_ticket_data")
                        
                }
            }
            }else{}
            
            AnsListDict["ans"] = "10"
            AnsListDict["answered_time"] = DATE
            AnsListDict["input"] = String(describing: cell.txtAnswer.text!)
            AnsListDict["marks_obtained"] = m_cAnswerChecklistObj.marks_obtained!
            AnsListDict["max_marks"] = m_cAnswerChecklistObj.max_marks!
            AnsListDict["photo_status"] = "0"
            AnsListDict["q_id"] = m_cAnswerChecklistObj.q_id!
            AnsListDict["q_type"] = m_cAnswerChecklistObj.q_type!
           
            if cell.txtRemark.text != ""
            {
                AnsListDict["remark"] = "\(cell.txtRemark.text!)"
            }else{
                AnsListDict["remark"] = "NF"
            }
            
            
            self.AnsChecklistArr.append(AnsListDict)
            
            UserDefaults.standard.setValue(self.AnsChecklistArr, forKey: "AnsChecklistArr")
            
            cell.backView.backgroundColor = UIColor(red:1.00, green:0.89, blue:0.77, alpha:1.0)
            cell.backView.isUserInteractionEnabled = false
          
            }
        }
        
    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }

    func GetIndexPath(sender: DLRadioButton) -> QueTypeOneBarcodeCell
    {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblQueChecklist)
        
        let indexPath = self.tblQueChecklist.indexPathForRow(at: buttonPosition)
        
        let cell = self.tblQueChecklist.cellForRow(at: indexPath!) as! QueTypeOneBarcodeCell
        
        return cell
    }
    
    func setFilledChecklistBARCODE()
    {
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        cSubmitChecklist.user_role = lcDict["role"] as! String
        cSubmitChecklist.com_id = lcDict["com_id"] as! String
        cSubmitChecklist.user_id = lcDict["user_id"] as! String
        
        let classid = UserDefaults.standard.string(forKey: "ClassificationId")
        self.ClassificationId = classid
        
        let projectId = UserDefaults.standard.string(forKey: "ProjId")
        self.ProjId = projectId
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd, hh:mm:ss"
        let DATE = formatter.string(from: date)
        print(DATE)
        self.EndTime = DATE
        
        var lcQueId : String = ""
        var lcQueImg : String = ""
        
        //    self.EndTime = self.getDate()
        var Score : String!
        var OutOfLoc : String!
        LocationDaraArr = LocationData.cLocationData.fetchOfflineLocation()!
    
        var lcMarkObtained: Float = 0.0
        var lcmaxmarks: Float = 0.0
        var lcFinalMarks: Float = 0.0
        var lcFinalmaxmarks: Float = 0.0
        
        let CheckListArr = UserDefaults.standard.array(forKey: "CheckListArr")
        self.CheckListArr = CheckListArr as! [AnyObject]
        
        for lcdict in self.CheckListArr
        {
            self.V_pass = lcdict["c_pass_per"] as! String
            self.V_avg = lcdict["c_avg_per"] as! String
            print(self.V_pass)
            print(V_avg)
        }
        
        let ansChecklistArr = UserDefaults.standard.array(forKey: "AnsChecklistArr")
        self.AnsChecklistArr = ansChecklistArr as! [[String : Any]]
        
        for lcAnsChecklist in self.AnsChecklistArr
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
        
        print("\(perCent)")
        
        for(index, _) in LocationDaraArr.enumerated()
        {
            let LocEntity = LocationDaraArr[index] as! FetchLocation
            
            if LocEntity.l_barcode == self.SecQrStr
            {
                Branchid = LocEntity.branch_id
                Locid = LocEntity.l_id
            }
            
            let lat = (LocEntity.l_latitude! as NSString).doubleValue
            let long = (LocEntity.l_longitude! as NSString).doubleValue
            
            let coordinate0 = CLLocation(latitude: lat, longitude:long)
            
            let coordinate1 = CLLocation(latitude: Double(self.Latitude)!, longitude: Double(self.Longitude)!)
            
            
            let distanceInMeters = coordinate0.distance(from: coordinate1)
            
            if(distanceInMeters <= 500)
            {
                OutOfLoc = "0"
                
                if self.Percent >= self.V_pass{
                    Score = "2"
                }else if self.Percent >= self.V_avg{
                    Score = "1"
                }else
                {
                    Score = "0"
                }
                
            }
            else
            {
                OutOfLoc = "1"
                Score = "0"
            }
            
        }
        
        let Filled_Checklist : [String: Any] =
            [
                "b_id" : Branchid!,
                "cl_id" : self.ClassificationId!,
                "end_time" : self.EndTime!,
                "l_id" : Locid!,
                "l_lat" : self.Latitude,
                "l_long" : self.Longitude,
                "out_of_loc" : OutOfLoc,
                "p_id" : self.ProjId!,
                "percentage" : self.Percent!,
                "rand_q_id" :  "nf",    // lcQueId,
                "rand_q_photo" : "nf",   //lcQueImg,
                "score" : Score,
                "start_time" : self.EndTime!
        ]
        self.FilledChecklistArr.append(Filled_Checklist)
       sendData()
        
    }
    func sendData()
    {
        
        let mTicketStatus = UserDefaults.standard.string(forKey: "m_ticket_status")
        cSubmitChecklist.m_ticket_status = mTicketStatus
        
        let mTicketData = UserDefaults.standard.string(forKey: "m_ticket_data")
        cSubmitChecklist.m_ticket_data = mTicketData
        
        
        
        cSubmitChecklist.checklist_answer = json(from: self.AnsChecklistArr)

       
        cSubmitChecklist.filled_checklist = json(from: self.FilledChecklistArr)
       
        
        let uploadUrl = "http://kanishkagroups.com/Qualus/index.php/AndroidV2/Checklist/upload_filled_checklist"
        
        
        let Param : [String: Any] =
            [ "totalImages" : 0,
              "filled_checklist" : cSubmitChecklist.filled_checklist!,
              "checklist_answer" : cSubmitChecklist.checklist_answer!,
              "answer_image" : [],
              "m_ticket_status" : cSubmitChecklist.m_ticket_status!,
              "m_ticket_data" : cSubmitChecklist.m_ticket_data!,
              "user_id" : cSubmitChecklist.user_id!,
              "user_role" : cSubmitChecklist.user_role!,
              "com_id" : cSubmitChecklist.com_id!,
              ]
        print("Param", Param)
        
        Alamofire.request(uploadUrl, method: .post, parameters: Param).responseJSON { (resp) in
            print(resp)
            
            if let JSON = resp.result.value as? [String: Any] {
                print("Response : ",JSON)
                
 
                let msg = JSON["msg"] as! String
                if msg == "SUCCESS"
                {
                    self.toast.isShow("Checkist submitted successfully")
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckListByLocationVc") as! CheckListByLocationVc
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else
                {
                    self.toast.isShow("Something went wrong")
                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject:  object, options: []) else
        {
            return nil
        }
        
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func random(Index:Int) -> Int
    {
        return Int(arc4random())
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation: CLLocation = locations[locations.count - 1]
        
        self.Latitude = String(format: "%.6f", lastLocation.coordinate.latitude)
        self.Longitude = String(format: "%.6f", lastLocation.coordinate.longitude)
        
    }

    @IBAction func btnLastYes_click(_ sender: Any)
    {
        popUp.dismiss(true)
        self.cBarcode.view.frame = self.view.bounds
        cBarcode.setSecondBarcode = 0
        self.view.addSubview(self.cBarcode.view)
        self.cBarcode.view.clipsToBounds = true
    }
    
    @IBAction func btnLastNo_click(_ sender: Any)
    {
        popUp.dismiss(true)

    }
    
}
