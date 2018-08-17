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

    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tblQueChecklist.delegate = self
        tblQueChecklist.dataSource = self
        
        
        self.bCameraStatus = false
        self.selectedIndex = -1
      
        tblQueChecklist.separatorStyle = .none
        tblQueChecklist.registerCellNib(QueTypeOneBarcodeCell.self)
        tblQueChecklist.registerCellNib(QueTypeTwoBarcodeCell.self)
 //       self.AnsChecklistArr.removeAll(keepingCapacity: false)
       
        self.tblQueChecklist.estimatedRowHeight = 80
        self.tblQueChecklist.rowHeight = UITableViewAutomaticDimension
    
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.tblQueChecklist.addGestureRecognizer(dismissKeyboardGesture)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.m_cImageArrFromCam.removeAll(keepingCapacity: false)

    
    }

// MARK : TABLEVIEW - METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.QuestionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let lcDict = QuestionArray[indexPath.row]
        let indexNumber = indexPath.row + 1
        
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
        let Url = "http://kanishkagroups.com/Qualus/index.php/AndroidV2/Checklist/upload_filled_checklist"
        
        let param : [String: Any] =
        [
            "Images" : "",
            "totalimages" : "",
            "filled_checklist" : "",
            "checklist_answer" : "",
            "answer_image" : "",
            "m_ticket_status" : "",
            "m_ticket_data" : "",
            "user_id" : "",
            "user_role" : "",
            "com_id" : ""
        ]
        
        Alamofire.request(Url, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
        }
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
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd, hh:mm:ss"
        let DATE = formatter.string(from: date)
        print(DATE)
        
        let lcDict = QuestionArray[sender.tag]
        m_cAnswerChecklistObj.q_type = lcDict["c_q_type"] as! String
        var AnsListDict = [String: Any]()
        let QueMarks = lcDict["c_q_marks"] as! String
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
            
            AnsListDict["ans"] = m_cAnswerChecklistObj.ans
            AnsListDict["answered_time"] = DATE
            AnsListDict["input"] = "0"
            AnsListDict["marks_obtained"] = m_cAnswerChecklistObj.marks_obtained
            AnsListDict["max_marks"] = m_cAnswerChecklistObj.max_marks
            AnsListDict["photo_status"] = "0"
            AnsListDict["q_id"] = m_cAnswerChecklistObj.q_id
            AnsListDict["q_type"] = m_cAnswerChecklistObj.q_type
            AnsListDict["remark"] = String(describing: cell.txtRemark.text)
            
            self.AnsChecklistArr.append(AnsListDict)
            
      //      cell.backView.isUserInteractionEnabled = false
            
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
                let InputVal = cell.txtAnswer.text
                
                if InputVal != ""
                {
                    let minVal = lcDict["c_q_min_value"] as! String
                    let maxVal = lcDict["c_q_max_value"] as! String
                    
                    if minVal...maxVal ~= InputVal! {
                        m_cAnswerChecklistObj.marks_obtained = QueMarks
                        m_cAnswerChecklistObj.ans = "1"
                    } else {
                        m_cAnswerChecklistObj.marks_obtained = "0"
                        m_cAnswerChecklistObj.ans = "2"
                    }
                }
            }
            
            AnsListDict["ans"] = "10"
            AnsListDict["answered_time"] = DATE
            AnsListDict["input"] = String(describing: cell.txtAnswer.text)
            AnsListDict["marks_obtained"] = m_cAnswerChecklistObj.marks_obtained
            AnsListDict["max_marks"] = m_cAnswerChecklistObj.max_marks
            AnsListDict["photo_status"] = "0"
            AnsListDict["q_id"] = m_cAnswerChecklistObj.q_id
            AnsListDict["q_type"] = m_cAnswerChecklistObj.q_type
            AnsListDict["remark"] = String(describing: cell.txtRemark.text)
            
            self.AnsChecklistArr.append(AnsListDict)
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
    
    
}
