//
//  ChecklistQuestionsVc.swift
//  QualusApp
//
//  Created by user on 28/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import ALCameraViewController
import CoreLocation
import SVProgressHUD

public class QuestionChecklist{
    var m_bAnswerYes: Bool!
    var m_bAnswerNo: Bool!
    var m_bAnswerNA: Bool!
    var m_sAnsRemark: String!
    var m_bAnsSubmit: Bool!
    var m_cCellColor: UIColor!
    var m_bTakePhoto: Bool!
    var m_bViewPhoto: Bool!
    var m_bAnsRemark: Bool!
    var m_bIsUserIntraction: Bool!
    var m_cImagArr: [ImgeFromCam]?
    var m_cSecAnswer: String!
    var m_cSecRemark: String!
    
    init()
    {
        m_bAnswerYes = false
        m_bAnswerNo = false
        m_bAnswerNA = false
        m_sAnsRemark = ""
        m_bAnsSubmit = false
        m_cCellColor = UIColor.white
        m_bTakePhoto = false
        m_bViewPhoto = true
        m_bAnsRemark = false
        m_bIsUserIntraction = false
        m_cImagArr = [ImgeFromCam]()
        m_cSecAnswer = ""
        m_cSecRemark = ""
    }
    
    init(bAnswerYes: Bool, bAnswerNo: Bool, bAnswerNA: Bool, sAnsRemark: String, bAnsSubmit: Bool, cCellColor: UIColor, bTakePhoto: Bool, bViewPhoto: Bool = true, bAnsRemark: Bool = false, bIsUserIntraction: Bool = false, cImageArr: [ImgeFromCam]?, sSecAnswer: String, sSecRemark: String) {
        m_bAnswerYes = bAnswerYes
        m_bAnswerNo = bAnswerNo
        m_bAnswerNA = bAnswerNA
        m_sAnsRemark = sAnsRemark
        m_bAnsSubmit = bAnsSubmit
        m_cCellColor = cCellColor
        m_bTakePhoto = bTakePhoto
        m_bViewPhoto = bViewPhoto
        m_bAnsRemark = bAnsRemark
        m_bIsUserIntraction = bIsUserIntraction
        m_cImagArr = cImageArr
        m_cSecAnswer = sSecAnswer
        m_cSecRemark = sSecRemark
    }
}

class ImgeFromCam : NSObject, NSCoding
{
    var indexCell : Int!
    var CamImag : UIImage!
    var ImagName: String!
    var ImgURL : String!
    var ImgPicTime: String!
    
    init(Index : Int, Img : UIImage,ImgName: String, ImgUrl: String,ImgPicTime: String) {
        self.indexCell = Index
        self.CamImag = Img
        self.ImagName = ImgName
        self.ImgURL = ImgUrl
        self.ImgPicTime = ImgPicTime
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.indexCell = aDecoder.decodeObject(forKey: "indexCell") as? Int
        self.CamImag = aDecoder.decodeObject(forKey: "CamImag") as? UIImage
        self.ImagName = aDecoder.decodeObject(forKey: "ImagName") as? String
        self.ImgURL = aDecoder.decodeObject(forKey: "ImgURL") as? String
        self.ImgPicTime = aDecoder.decodeObject(forKey: "ImgPicTime") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.indexCell, forKey: "indexCell")
        aCoder.encode(self.CamImag, forKey: "CamImag")
        aCoder.encode(self.ImagName, forKey: "ImagName")
        aCoder.encode(self.ImgURL, forKey: "ImgURL")
        aCoder.encode(self.ImgPicTime, forKey: "ImgPicTime")
        
    }
}

class AnswerChecklist {
    var ans : String!
    var answered_time : Date!
    var input : String!
    var marks_obtained : String!
    var max_marks : String!
    var photo_status : String!
    var q_id : String!
    var q_type : String!
    var remark : String!
 }

class AnsImage : NSObject, NSCoding
{
    var q_id : String!
    var se_img_url : String!
    
    init(QueId: String, ImgUrl : String) {
        self.q_id = QueId
        self.se_img_url = ImgUrl
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.q_id = aDecoder.decodeObject(forKey: "q_id") as? String
        self.se_img_url = aDecoder.decodeObject(forKey: "se_img_url") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.q_id, forKey: "q_id")
        aCoder.encode(self.se_img_url, forKey: "se_img_url")
    }
}

class MtickectData
{
    var action_plan : String!
    var l_barcode : String!
    var l_id : String!
    var mt_photo : String!
    var mt_remark : String!
    var mt_subject : String!
    var p_id : String!
    var pb_id : String!
    var q_id : String!
}

class ChecklistQuestionsVc: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var lblRandomQue: UILabel!
    @IBOutlet var viewRandomQuestion: UIView!
    @IBOutlet weak var tblQuestions: UITableView!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var btnCamRabdom: UIButton!
    
    var collViewinAlert : UICollectionView!
    var toast = JYToast()
    var QuestionArray = [AnyObject]()
    var ClassificationId : String!
    var Qcell : ChecklistQuetionCell!
    var checkBtn = Bool(true)
    var SelectedImgArr   = [UIImage]()
    var formValid = Bool(false)
    var popUp : KLCPopup!
    //images
    var filePath            : String!
    var imgArr              = [String]()           //images name string
    var filePathArr         = [Any]()            //imagepath
    var ImageArr            = [UIImage]()   //count of images
    var imageNameArr        = [String]()
    var libraryEnabled      : Bool = false
    var croppingEnabled     : Bool = false
    var allowResizing       : Bool = true
    var allowMoving         : Bool = false
    var deletindex          : Int = 0
    var withHUD             : Bool!
    var minimumSize         : CGSize = CGSize(width: 60, height: 60)
   
    var Latitude : String = ""
    var Longitude : String = ""
    var locationManager: CLLocationManager = CLLocationManager()
    var cSubmitChecklist = SubmitChecklistData()
    var m_cAnswerChecklist = [AnswerChecklist]()
    var m_cAnswerChecklistObj = AnswerChecklist()
    var m_cAnsImage = [AnsImage]()
    var m_cTicketData = [MtickectData]()
    var m_cTicketDataObj = MtickectData()
    var AnsChecklistArr = [[String: Any]]()
    var TicketDataArr = [[String: Any]]()
    var FilledChecklistArr = [[String: Any]]()
    var LocationDaraArr = [AnyObject]()
    var ClsfitnArr = [AnyObject]()
    var ClsQueArr = [AnyObject]()
    var QrStr : String = ""
    var ProjId : String = ""
    var M_Ticket_Status = String()
    var m_cImageArrFromCam = [ImgeFromCam]()
    var SelectedIndexArr = [ImgeFromCam]()
    var AnswerImgArr = [AnyObject]()
    var ImgUrl : URL!
    var bCameraStatus = Bool(false)
    var Branchid : String = ""
    var Locid : String = ""
    var CheckListArr = [String : Any]()
  
    var RandomQueId :  String = ""
    var b_randomQueImg = Bool(false)
    var Random : Int = 0
    var date = Date()
    var SecQrStr : String = ""
    var QrCodeStrSec : String = ""
  
    var dataToServer = Bool(false)
    let userDefaults = UserDefaults.standard
    var StartTime = String()
    var m_cQuestionCheckList = [QuestionChecklist]()
    
    var croppingParameters: CroppingParameters {
        return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumSize)
    }
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.bCameraStatus = false
        
        tblQuestions.registerCellNib(ChecklistQuetionCell.self)
        tblQuestions.registerCellNib(ChecklistQTypeCell.self)
       
        self.AnsChecklistArr.removeAll(keepingCapacity: false)
   
        popUp = KLCPopup()
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.tblQuestions.addGestureRecognizer(dismissKeyboardGesture)
        
        QuestionArray.forEach{_ in
            let lcQuestionListValue = QuestionChecklist(bAnswerYes: false, bAnswerNo: false, bAnswerNA: false, sAnsRemark: "", bAnsSubmit: false, cCellColor: UIColor.white, bTakePhoto: false,cImageArr: nil, sSecAnswer: "", sSecRemark: "")
            m_cQuestionCheckList.append(lcQuestionListValue)
        }
        AssignDelegate()
        UserDefaultsVal()
        tableFrame()
        ClassificationDataFromCore()
      
        self.m_cImageArrFromCam.removeAll(keepingCapacity: false)
        self.AnswerImgArr.removeAll(keepingCapacity: false)
        
        LocationDaraArr = LocationData.cLocationData.fetchOfflineLocation()!
        
        self.StartTime = GetCurrentDate_Time()
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ChecklistQuestionsVc.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }

    @objc func back(sender: UIBarButtonItem) {
        Alert.shared.action(vc: self, title: "Qualus", msg: "Please Submit Checklist on Top Right corner to Continue", btn1Title: "DELETE CHECKLIST", btn2Title: "OK", btn1Action:
            {
                print("Click yes")
                self.navigationController?.popViewController(animated: true)
         
        }) {
            print("Click no")
         }
    }
    
    func GetCurrentDate_Time() -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
    
    func tableFrame()
    {
        tblQuestions.separatorStyle = .none
        self.tblQuestions.separatorStyle = .none
        self.tblQuestions.estimatedRowHeight = 80
        self.tblQuestions.rowHeight = UITableViewAutomaticDimension
    }
    
    func AssignDelegate()
    {
        tblQuestions.delegate = self
        tblQuestions.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        collViewinAlert = UICollectionView(frame: CGRect(x: 0, y: 0, width: 270, height: 320), collectionViewLayout: layout)
        collViewinAlert.backgroundColor = UIColor.white
        
         collViewinAlert.register(UINib(nibName: "ShowImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShowImagesCollectionViewCell")
        
        collViewinAlert.delegate = self
        collViewinAlert.dataSource = self
    }
    
    func UserDefaultsVal()
    {
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        cSubmitChecklist.user_role = (lcDict["role"] as! String)
        cSubmitChecklist.com_id = (lcDict["com_id"] as! String)
        cSubmitChecklist.user_id = (lcDict["user_id"] as! String)
    }
    
    func ClassificationDataFromCore()
    {
        ClsQueArr = ClassificationData.cDataClassification.fetchOfflineClsQueData()!
        
        for (_, valClassEnt) in ClsQueArr.enumerated()
        {
            let classEnt = valClassEnt as! FetchQueData
            if ClassificationId == classEnt.class_id
            {
                let random : Int = Int(arc4random_uniform(UInt32(self.QuestionArray.count))+1)
                print("Random Num", random)
                self.Random = random
            }
        }
    }
    
    @objc func remark_textfieldEditing(sender: UITextField){
        self.m_cQuestionCheckList[sender.tag].m_sAnsRemark = sender.text
    }

    @objc func txtAnswer_textfieldEditing(sender: UITextField){
        self.m_cQuestionCheckList[sender.tag].m_cSecAnswer = sender.text
    }
    
    @objc func txtRemark_textfieldEditing(sender: UITextField){
        self.m_cQuestionCheckList[sender.tag].m_cSecRemark = sender.text
    }
    
//  MARK : TABLEVIEW - METHODS
    
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
            self.Qcell = tblQuestions.dequeueReusableCell(withIdentifier: "ChecklistQuetionCell", for: indexPath) as? ChecklistQuetionCell
            CellForRowAt(Qcell: self.Qcell, cDict: lcDict as! [String : Any], indexNumber: indexNumber,indexPathrow: indexPath.row)
           
            Qcell.txtRemarks.addTarget(self, action: #selector(remark_textfieldEditing(sender:)), for: .editingDidEnd)
            return Qcell
        }else{
            
            let cell = tblQuestions.dequeueReusableCell(withIdentifier: "ChecklistQTypeCell", for: indexPath) as! ChecklistQTypeCell
            
            let Qstr = lcDict["c_q_question"] as! String
            
            cell.backView.applyShadowAndRadiustoView()
            cell.lblQuetnType.text = "Q." + String(indexNumber) + "  " + Qstr
            
            cell.backView.applyShadowAndRadiustoView()
            
            cell.btntakeImage.isHidden = m_cQuestionCheckList[indexPath.row].m_bTakePhoto ? true : false
            cell.btnViewPics.isHidden = m_cQuestionCheckList[indexPath.row].m_bViewPhoto ? true : false
            cell.btnSubmitQ.isHidden = m_cQuestionCheckList[indexPath.row].m_bAnsSubmit ? true : false
            
            cell.backView.backgroundColor = m_cQuestionCheckList[indexPath.row].m_bAnsSubmit ? UIColor(hexString: "dbebfa") : UIColor.white
      
            cell.btnViewPics.isUserInteractionEnabled = true
            
            cell.txtRemark.isUserInteractionEnabled = self.m_cQuestionCheckList[indexPath.row].m_bIsUserIntraction ? false : true
          
            cell.txtAnswer.isUserInteractionEnabled = self.m_cQuestionCheckList[indexPath.row].m_bIsUserIntraction ? false : true
        
            //cell.txtRemark.delegate = self
            cell.txtRemark.text = m_cQuestionCheckList[indexPath.row].m_cSecRemark
            
          // cell.txtAnswer.delegate = self
            cell.txtAnswer.text = m_cQuestionCheckList[indexPath.row].m_cSecAnswer
            
            cell.txtAnswer.tag = indexPath.row
            cell.txtRemark.tag = indexPath.row
            cell.btnSubmitQ.tag = indexPath.row
            cell.btntakeImage.tag = indexPath.row
            cell.btnViewPics.tag = indexPath.row
            
            cell.txtAnswer.addTarget(self, action: #selector(txtAnswer_textfieldEditing(sender:)), for: .editingDidEnd)
            
            cell.txtRemark.addTarget(self, action: #selector(txtRemark_textfieldEditing(sender:)), for: .editingDidEnd)
       
            cell.btnSubmitQ.addTarget(self, action: #selector(SubmitQuetions(sender:)), for: .touchUpInside)
            cell.btntakeImage.addTarget(self, action: #selector(OpenCamera(sender:)), for: .touchUpInside)
            cell.btnViewPics.addTarget(self, action: #selector(btnViewPhotos_click(sender:)), for: .touchUpInside)
            return cell
        }
        
    }

    func CellForRowAt(Qcell: UITableViewCell, cDict: [String: Any],indexNumber: Int,indexPathrow: Int)
    {
        
        let Qcell = Qcell as! ChecklistQuetionCell
        let Qstr = cDict["c_q_question"] as! String
        Qcell.lblQuestion.text = "Q." + String(indexNumber) + "  " + Qstr
        
        
        Qcell.backView.applyShadowAndRadiustoView()
        
        Qcell.btnTakeImg.isHidden = m_cQuestionCheckList[indexPathrow].m_bTakePhoto ? true : false
        Qcell.btnViewPhotos.isHidden = m_cQuestionCheckList[indexPathrow].m_bViewPhoto ? true : false
        Qcell.btnSubmit.isHidden = m_cQuestionCheckList[indexPathrow].m_bAnsSubmit ? true : false
        
        Qcell.btnYes.isSelected = m_cQuestionCheckList[indexPathrow].m_bAnswerYes ? true : false
        Qcell.btnNO.isSelected = m_cQuestionCheckList[indexPathrow].m_bAnswerNo ? true : false
        Qcell.btnNA.isSelected = m_cQuestionCheckList[indexPathrow].m_bAnswerNA ? true : false
        
        Qcell.backView.backgroundColor = m_cQuestionCheckList[indexPathrow].m_bAnsSubmit ? UIColor(hexString: "dbebfa") : UIColor.white
        
        Qcell.btnViewPhotos.isUserInteractionEnabled = true
        
        Qcell.txtRemarks.isUserInteractionEnabled = self.m_cQuestionCheckList[indexPathrow].m_bIsUserIntraction ? false : true
        Qcell.btnYes.isUserInteractionEnabled = self.m_cQuestionCheckList[indexPathrow].m_bIsUserIntraction ? false : true
        Qcell.btnNA.isUserInteractionEnabled = self.m_cQuestionCheckList[indexPathrow].m_bIsUserIntraction ? false : true
        Qcell.btnNO.isUserInteractionEnabled = self.m_cQuestionCheckList[indexPathrow].m_bIsUserIntraction ? false : true
        
        Qcell.txtRemarks.tag = indexPathrow
        //Qcell.txtRemarks.delegate = self
        Qcell.txtRemarks.text = m_cQuestionCheckList[indexPathrow].m_sAnsRemark
        
        Qcell.txtRemarks.tag = indexPathrow
        Qcell.btnSubmit.tag = indexPathrow
        Qcell.btnTakeImg.tag = indexPathrow
        Qcell.btnViewPhotos.tag = indexPathrow
        
        Qcell.btnSubmit.addTarget(self, action:  #selector(SubmitQuetions(sender:)), for: .touchUpInside)
        
        Qcell.btnTakeImg.addTarget(self, action: #selector(OpenCamera(sender:)), for: .touchUpInside)
        Qcell.btnYes.addTarget(self, action: #selector(btnYes_Click(sender:)), for: .touchUpInside)
        Qcell.btnNO.addTarget(self, action: #selector(btnNo_Click(sender:)), for: .touchUpInside)
        Qcell.btnNA.addTarget(self, action: #selector(btnNA_Click(sender:)), for: .touchUpInside)
        Qcell.btnViewPhotos.addTarget(self, action: #selector(btnViewPhotos_click(sender:)), for: .touchUpInside)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 230.0
    }

//  MARK :  ADD-TARGET - METHODS
    
    @objc func btnViewPhotos_click(sender: UIButton)
    {
        self.view.endEditing(true)
      
          self.SelectedIndexArr = self.m_cQuestionCheckList[sender.tag].m_cImagArr!

        collViewinAlert.reloadData()
        createAlertView()
        
   }
    
    func GetArrcount(indexValue: Int) -> Int
    {
        
        self.SelectedIndexArr.removeAll(keepingCapacity: false)
       
        if let lcimgArr = self.m_cQuestionCheckList[indexValue].m_cImagArr
        {
            return lcimgArr.count
        }
        return 0
    }
    
    func getDate() -> String
    {
        let date =  Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd, HH:mm:ss zzz"
        let lcDate = formatter.string(from: date)
        return lcDate
     }
    
   @objc func SubmitQuetions(sender: UIButton)
   {
   
    let lcDict = QuestionArray[sender.tag]
    
    m_cAnswerChecklistObj.q_type = (lcDict["c_q_type"] as! String)
    var AnsListDict = [String: Any]()
    var TicketDict = [String: Any]()
    let QueMarks = lcDict["c_q_marks"] as! String
    let Qstr = lcDict["c_q_question"] as! String
  
    m_cAnswerChecklistObj.q_id = (lcDict["c_q_id"] as! String)
    
     let indexpath = IndexPath(row: sender.tag, section: 0)
    
    if m_cAnswerChecklistObj.q_type == "1"
    {
       
        let cell = self.tblQuestions.cellForRow(at: indexpath) as! ChecklistQuetionCell
            
            
            if ((self.m_cQuestionCheckList[sender.tag].m_bAnswerYes == false) && (self.m_cQuestionCheckList[sender.tag].m_bAnswerNo == false) && (self.m_cQuestionCheckList[sender.tag].m_bAnswerNA == false))
            {
                self.toast(msg: "Please select answer")
                return
            }

        
        let countImg = self.GetArrcount(indexValue: sender.tag)
        
           self.bCameraStatus = false
           if cell.btnNO.isSelected
            {
                
                if cell.txtRemarks.text == ""
                {
                    self.toast(msg: "Please enter remark")
                    return
                    
                }else if countImg == 0
                {
                    if self.bCameraStatus == false
                    {
                        self.bCameraStatus = true
                        OpenCamera(sender: cell.btnTakeImg)
                        return
                    }
                }
            }
        
        if (self.m_cQuestionCheckList[sender.tag].m_bAnswerYes == true)
        {
            m_cAnswerChecklistObj.marks_obtained = QueMarks
            m_cAnswerChecklistObj.max_marks = QueMarks
           
        }else if (self.m_cQuestionCheckList[sender.tag].m_bAnswerNo == true)
        {
              m_cAnswerChecklistObj.marks_obtained = "0"
              m_cAnswerChecklistObj.max_marks = QueMarks
        }else if (self.m_cQuestionCheckList[sender.tag].m_bAnswerNA == true)
        {
            m_cAnswerChecklistObj.marks_obtained = "0"
              m_cAnswerChecklistObj.max_marks = "0"
        }
        
        if countImg == 0
        {
            self.m_cAnswerChecklistObj.photo_status = "0"
        }else{
                self.m_cAnswerChecklistObj.photo_status = "1"
        }
        
        if cell.txtRemarks.text != ""
        {
            self.m_cAnswerChecklistObj.remark = cell.txtRemarks.text
        }else{
            self.m_cAnswerChecklistObj.remark = "NF"
        }
        
        
            AnsListDict["ans"] = m_cAnswerChecklistObj.ans
            AnsListDict["answered_time"] = self.getDate()
            AnsListDict["input"] = "0"
            AnsListDict["marks_obtained"] = m_cAnswerChecklistObj.marks_obtained
        
            AnsListDict["max_marks"] = m_cAnswerChecklistObj.max_marks
            AnsListDict["photo_status"] = m_cAnswerChecklistObj.photo_status
            AnsListDict["q_id"] = m_cAnswerChecklistObj.q_id
            AnsListDict["q_type"] = m_cAnswerChecklistObj.q_type
            AnsListDict["remark"] = m_cAnswerChecklistObj.remark
       
        
        print(AnsListDict)
        
        self.m_cAnswerChecklist.append(m_cAnswerChecklistObj)
        self.AnsChecklistArr.append(AnsListDict)
       
        var lcDict = [String: String]()
        
        self.SelectedIndexArr = self.m_cQuestionCheckList[indexpath.row].m_cImagArr ?? []
        
        if self.SelectedIndexArr.count != 0
        {
            for lcSelectedArr in SelectedIndexArr
            {
                lcDict["q_id"] = m_cAnswerChecklistObj.q_id
                lcDict["se_img_time"]  = lcSelectedArr.ImgPicTime
                lcDict["se_img_url"] = lcSelectedArr.ImagName
                self.AnswerImgArr.append(lcDict as AnyObject)
            }
        }
      
        print(self.AnswerImgArr)
    
        cSubmitChecklist.m_ticket_status = "0"
        cSubmitChecklist.m_ticket_data = ""
 
        if self.Random == sender.tag
        {
           self.RandomQueId = m_cAnswerChecklistObj.q_id
            print("RandQueId", self.RandomQueId)
           self.OpenRandomQue()
        }
        
        self.m_cQuestionCheckList[sender.tag].m_bIsUserIntraction = true
    
        }else{
    /////////////////second cell
        
        
        
        let indexpath = IndexPath(row: sender.tag, section: 0)
        
         self.SelectedIndexArr = self.m_cQuestionCheckList[indexpath.row].m_cImagArr ?? []
        
            let cell = self.tblQuestions.cellForRow(at: indexpath) as! ChecklistQTypeCell
        
         let count = self.GetArrcount(indexValue: sender.tag)
        
            self.bCameraStatus = false
        
           if cell.txtAnswer.text == ""
            {
                self.toast(msg: "Please select answer")
                return
            }
        
            if count == 0{
                self.m_cAnswerChecklistObj.photo_status = "0"
            }else{
                self.m_cAnswerChecklistObj.photo_status = "1"
            }
            
            m_cAnswerChecklistObj.marks_obtained = QueMarks
            m_cAnswerChecklistObj.max_marks = QueMarks
        
            cSubmitChecklist.m_ticket_status = "0"
         UserDefaults.standard.setValue(cSubmitChecklist.m_ticket_status, forKey: "m_ticket_status")
        
        if m_cAnswerChecklistObj.q_type == "3"
         {
            
            if cell.txtAnswer.text == ""
            {
                self.toast(msg: "Please select answer")
                return
            }else if count == 0
            {
                if self.bCameraStatus == false
                {
                    self.bCameraStatus = true
                    OpenCamera(sender: cell.btntakeImage)
                    return
                }
                return
            }
            
            if cell.txtRemark.text == ""
            {
                self.toast(msg: "Please enter remark")
            }
            
           let InputVal = cell.txtAnswer.text
            
            if InputVal != ""
            {
                let minVal = lcDict["c_q_min_value"] as! String
                let maxVal = lcDict["c_q_max_value"] as! String
                
                    
                if (InputVal! > minVal) && (InputVal! < maxVal)
               { // In range
                    m_cAnswerChecklistObj.marks_obtained = QueMarks
                    m_cAnswerChecklistObj.max_marks = QueMarks
                    m_cAnswerChecklistObj.ans = "1"
                    cSubmitChecklist.m_ticket_status = "0"
       
                    self.TicketDataArr = []
                    
                }else{
                       // Out of range
                    
                    m_cAnswerChecklistObj.marks_obtained = "0"
                    m_cAnswerChecklistObj.max_marks = QueMarks
                  
                    m_cAnswerChecklistObj.ans = "2"
                    
                    cSubmitChecklist.m_ticket_status = "1"
      
                    
                    // m_ticket_data is send
                
            for(index, _) in LocationDaraArr.enumerated()
                {
                        let LocEntity = LocationDaraArr[index] as! FetchLocation
                        
                        if LocEntity.l_barcode == self.QrStr
                        {
                            Branchid = LocEntity.branch_id!
                            Locid = LocEntity.l_id!
                        }
                }
                    
            self.SelectedIndexArr = self.m_cQuestionCheckList[indexpath.row].m_cImagArr ?? []
                    let lcSelectedImgArr = self.SelectedIndexArr.map{$0.ImagName}
                print(lcSelectedImgArr)
                TicketDict["action_plan"] = "NF"
                TicketDict["l_barcode"] = QrStr
                TicketDict["l_id"] = Locid
                TicketDict["mt_photo"] = self.json(from: lcSelectedImgArr)
                TicketDict["mt_remark"] = cell.txtRemark.text
                TicketDict["mt_subject"] = Qstr
                TicketDict["p_id"] = self.ProjId
                TicketDict["pb_id"] = Branchid
                TicketDict["q_id"] = m_cAnswerChecklistObj.q_id
                self.TicketDataArr.append(TicketDict)
                
        cSubmitChecklist.m_ticket_data = json(from: self.TicketDataArr)
        UserDefaults.standard.setValue(cSubmitChecklist.m_ticket_data, forKey: "m_ticket_data")
                 
            }
            
         }else{
         }
            
    }
        
       AnsListDict["ans"] = "10"
       AnsListDict["answered_time"] = self.getDate()
       AnsListDict["input"] = "\(cell.txtAnswer.text!)"
       AnsListDict["marks_obtained"] = m_cAnswerChecklistObj.marks_obtained
       AnsListDict["max_marks"] = m_cAnswerChecklistObj.max_marks
       AnsListDict["photo_status"] = m_cAnswerChecklistObj.photo_status
       AnsListDict["q_id"] = m_cAnswerChecklistObj.q_id
       AnsListDict["q_type"] = m_cAnswerChecklistObj.q_type
        
        if cell.txtRemark.text != ""
        {
            AnsListDict["remark"] = "\(cell.txtRemark.text!)"
        }else{
            AnsListDict["remark"] = "NF"
        }
        self.AnsChecklistArr.append(AnsListDict)
        var lcDict = [String: String]()
        
         self.SelectedIndexArr = self.m_cQuestionCheckList[indexpath.row].m_cImagArr ?? []
        if self.SelectedIndexArr.count != 0
        {
            for lcSelectedArr in SelectedIndexArr
            {
                lcDict["q_id"] = m_cAnswerChecklistObj.q_id
                lcDict["se_img_time"]  = lcSelectedArr.ImgPicTime
                lcDict["se_img_url"] = lcSelectedArr.ImagName
                self.AnswerImgArr.append(lcDict as AnyObject)
            }
        }
         print(self.AnswerImgArr)
        
        if self.Random == sender.tag
        {
            self.RandomQueId = m_cAnswerChecklistObj.q_id
            print("RandQueId", self.RandomQueId)
            self.OpenRandomQue()
        }
    
    }
    m_cQuestionCheckList[indexpath.row].m_bTakePhoto = true   //hide buttun
    m_cQuestionCheckList[indexpath.row].m_bAnsSubmit = true
    
    if let lcImageArr = m_cQuestionCheckList[indexpath.row].m_cImagArr
    {
        m_cQuestionCheckList[indexpath.row].m_bViewPhoto = lcImageArr.count == 0 ? true : false
    }
    holdtableview(tag: sender.tag)
    
}
   
    @objc func OpenCamera(sender: UIButton)
    {
        
    let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "AddimagesViewController") as! AddimagesViewController
       vc.index = sender.tag
       vc.delegate = self
       self.navigationController?.pushViewController(vc, animated: true)
    }
        
    func openCamForRandomQu(sender: UIButton)
    {
        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: libraryEnabled){ [weak self] image, asset in
        
            if image != nil
            {
                self!.OpenRandomQue()
                
                let timestamp = Date().toMillis()
                image!.accessibilityIdentifier = String(describing: timestamp)
                self?.btnCamRabdom.setImage(image, for: .normal)
                let lcFileName = image?.GetFileName()
                let randonImgNm = self!.cSubmitChecklist.user_id + "_" + lcFileName!
                let lcRandomImg = AnsImage(QueId: (self?.RandomQueId)!, ImgUrl: randonImgNm)
                self?.m_cAnsImage.append(lcRandomImg)
            }
 
         DispatchQueue.main.async {
              self?.dismiss(animated: true, completion: nil)
          }
        
       }
        present(cameraViewController, animated: true, completion: nil)
    }
    
    @objc func btnYes_Click(sender: DLRadioButton)
    {
        
        self.view.endEditing(true)
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblQuestions)
        
        let indexPath = self.tblQuestions.indexPathForRow(at: buttonPosition)
        
        let cell = self.tblQuestions.cellForRow(at: indexPath!) as! ChecklistQuetionCell

        
        let lcSetValue = m_cQuestionCheckList[(indexPath?.row)!]
        lcSetValue.m_bAnswerYes = true
        lcSetValue.m_bAnswerNo = false
        lcSetValue.m_bAnswerNA = false
        
       // cell.btnYes.tag = 1
        m_cAnswerChecklistObj.ans = "1"
        holdtableview(tag: (indexPath?.row)!)
      //  tblQuestions.reloadRows(at: [indexPath!], with: .none)
    }
    
    @objc func btnNo_Click(sender: DLRadioButton)
    {
        self.view.endEditing(true)
      //  let cell = GetIndexPath(sender: sender)
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblQuestions)
        let indexPath = self.tblQuestions.indexPathForRow(at: buttonPosition)
        let cell = self.tblQuestions.cellForRow(at: indexPath!) as! ChecklistQuetionCell

        let setValue = m_cQuestionCheckList[(indexPath?.row)!]
        setValue.m_bAnswerYes = false
        setValue.m_bAnswerNo = true
        setValue.m_bAnswerNA = false
        //cell.btnNO.tag = 2
        m_cAnswerChecklistObj.ans = "2"
        holdtableview(tag: (indexPath?.row)!)
       // tblQuestions.reloadRows(at: [indexPath!], with: .none)

    }
    
    @objc func btnNA_Click(sender: DLRadioButton)
    {
        self.view.endEditing(true)
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblQuestions)
        let indexPath = self.tblQuestions.indexPathForRow(at: buttonPosition)
        let cell = self.tblQuestions.cellForRow(at: indexPath!) as! ChecklistQuetionCell

        let setValue = m_cQuestionCheckList[(indexPath?.row)!]
        setValue.m_bAnswerYes = false
        setValue.m_bAnswerNo = false
        setValue.m_bAnswerNA = true
        cell.btnNA.tag = 3
        m_cAnswerChecklistObj.ans = "0"
        holdtableview(tag: (indexPath?.row)!)
       // tblQuestions.reloadRows(at: [indexPath!], with: .none)
    }
    
    func holdtableview(tag: Int){
        DispatchQueue.main.async {
            UIView.performWithoutAnimation({
                let loc = self.tblQuestions.contentOffset
                self.tblQuestions.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
                self.tblQuestions.contentOffset = loc
            })
        }
    }

    
  func GetIndexPath(sender: DLRadioButton) -> ChecklistQuetionCell
  {
    let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblQuestions)
    let indexPath = self.tblQuestions.indexPathForRow(at: buttonPosition)
    let cell = self.tblQuestions.cellForRow(at: indexPath!) as! ChecklistQuetionCell
    return cell
  }
    
    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }

    @IBAction func btnOKForImage_Click(_ sender: Any)
    {
        self.popUp.dismiss(true)
    }
    
    func toast(msg: String){
        self.view.showToast(msg, position: .bottom, popTime: 3, dismissOnTap: true)
    }
    
    @IBAction func btnDone_OnClick(_ sender: Any)
    {
        if self.AnsChecklistArr.count != self.QuestionArray.count
        {
            self.toast(msg: "Please fill all checklist")
        }
        else
        {
            Alert.shared.action(vc: self, title: "Qualus", msg: "Are you sure you want to submit checklist? \n\n You Need to Scan Respective Location", btn1Title: "Yes", btn2Title: "No", btn1Action:
                {
                    print("Click yes")
                    let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ScanAfterChecklistVc") as! ScanAfterChecklistVc
                    
                    vc.setChecklistData(ChecklistArr: self.CheckListArr, Checklist_Answer: self.AnsChecklistArr, Ans_images: self.AnswerImgArr, M_ticket_status: self.cSubmitChecklist.m_ticket_status, M_ticket_data: self.TicketDataArr, Random_image: self.m_cAnsImage, firstQr: self.QrStr, Pid: self.ProjId, classification_id: self.ClassificationId, AllchecklistImages: self.m_cImageArrFromCam, start_time: self.StartTime)
                    
                    print("All Images : \(self.m_cImageArrFromCam)")
                    self.navigationController?.pushViewController(vc, animated: true)
                    
            }) {
                print("Click no")
                
            }
        }
       
   
        
    }
    
// MARK: EXTRA - METHODS
    
    @IBAction func setRandomQue(_ sender: Any)
    {
        popUp.dismiss(true)
        self.b_randomQueImg = true
        openCamForRandomQu(sender: btnCamRabdom)
    }
    
    @IBAction func btnSubmitRandomQue_Click(_ sender: Any)
    {
        self.b_randomQueImg = false
        popUp.dismiss(true)
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
    
    func OpenRandomQue()
    {
        viewRandomQuestion.isHidden = false
        popUp.contentView = viewRandomQuestion
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = false
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
    }
    
  
    func random(Index:Int) -> Int
    {
      return Int(arc4random())
    }
    
}

extension ChecklistQuestionsVc : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.SelectedIndexArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowImagesCollectionViewCell", for: indexPath) as! ShowImagesCollectionViewCell
        
       // let lcImgeFromCam = self.m_cQuestionCheckList[indexPath.row].m_cImagArr as? [ImgeFromCam]
       // let lcImage = lcImgeFromCam![indexPath.row].CamImag
        let lcSelectedIndex = self.SelectedIndexArr[indexPath.row]
        cell.images.image = lcSelectedIndex.CamImag
        cell.backgroundColor = UIColor.groupTableViewBackground
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 2) - (5+2.5), height: (collectionView.frame.size.height / 2) - (5+2.5))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func createAlertView() {
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 320,height: 320)
        vc.view.backgroundColor = UIColor.white
        
        vc.view.addSubview(collViewinAlert)
        
        let editRadiusAlert = UIAlertController(title: "Show Images", message: "", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        let done = UIAlertAction(title: "Done", style: .default, handler: { (done) in
            
        })
        editRadiusAlert.addAction(done)
        self.present(editRadiusAlert, animated: true)
    }
    
}
extension ChecklistQuestionsVc : AddImagesDelegate
{
    func attachmentarrayImage(index: Int, imagearr: [ImgeFromCam])
    {
        let indexPath = IndexPath(row: index, section: 0)
        m_cQuestionCheckList[index].m_bTakePhoto = true
        m_cQuestionCheckList[index].m_bViewPhoto = false
        self.m_cQuestionCheckList[index].m_cImagArr = imagearr
        
         for lcImg in imagearr
         {
            self.m_cImageArrFromCam.append(lcImg)
         }

        //self.m_cImageArrFromCam = self.m_cQuestionCheckList[index].m_cImagArr!
        
        tblQuestions.reloadRows(at: [indexPath], with: .none)
    }
    
    
}
