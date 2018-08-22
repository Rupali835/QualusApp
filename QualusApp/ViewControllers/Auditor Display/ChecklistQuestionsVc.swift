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

class ImgeFromCam{
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

class AnsImage
{
    var q_id : String!
    var se_img_url : String!
    
    init(QueId: String, ImgUrl : String) {
        self.q_id = QueId
        self.se_img_url = ImgUrl
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

class ChecklistQuestionsVc: UIViewController, UITableViewDataSource, UITableViewDelegate, imageUploadDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate
  {
   
    func Success(MessgaStr: String) {
        print("Result")
    }
    
    @IBOutlet weak var lblRandomQue: UILabel!
    @IBOutlet var viewRandomQuestion: UIView!
    @IBOutlet var viewImagesChecklist: UIView!
    @IBOutlet weak var tblQuestions: UITableView!
    
    @IBOutlet weak var btnCamRabdom: UIButton!
    @IBOutlet weak var collView: UICollectionView!
    var toast = JYToast()
    var QuestionArray = [AnyObject]()
    var ClassificationId : String!
    var Qcell : ChecklistQuetionCell!
    var selectedIndex = Int(-1)
    var checkBtn = Bool(true)
    var SelectedImgArr   = [UIImage]()
    var UnSelectedImgArr = [UIImage]()
    var formValid = Bool(false)
    var popUp : KLCPopup!
    //images
    var filePath            : String!
    var imgArr              = [String]()           //images name string
    var dictArr             = [Any]()           //para
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
    var ProjId : String!
    var M_Ticket_Status = String()
    var m_cImageArrFromCam = [ImgeFromCam]()
    var SelectedIndexArr = [ImgeFromCam]()
    var AnswerImgArr = [AnyObject]()
    var ImgUrl : URL!
    var bCameraStatus = Bool(false)
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
    
    var croppingParameters: CroppingParameters {
        return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumSize)
    }
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.bCameraStatus = false
        self.selectedIndex = -1
        tblQuestions.delegate = self
        tblQuestions.dataSource = self
        tblQuestions.separatorStyle = .none
        tblQuestions.registerCellNib(ChecklistQuetionCell.self)
        tblQuestions.registerCellNib(ChecklistQTypeCell.self)
        print("Questions", QuestionArray)
        self.AnsChecklistArr.removeAll(keepingCapacity: false)
        self.tblQuestions.separatorStyle = .none
        self.tblQuestions.estimatedRowHeight = 80
        self.tblQuestions.rowHeight = UITableViewAutomaticDimension
        popUp = KLCPopup()
        collView.delegate = self
        collView.dataSource = self
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.tblQuestions.addGestureRecognizer(dismissKeyboardGesture)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.m_cImageArrFromCam.removeAll(keepingCapacity: false)
        
        LocationDaraArr = LocationData.cLocationData.fetchOfflineLocation()!
        
          self.AnswerImgArr.removeAll(keepingCapacity: false)
        
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        cSubmitChecklist.user_role = lcDict["role"] as! String
        cSubmitChecklist.com_id = lcDict["com_id"] as! String
        cSubmitChecklist.user_id = lcDict["user_id"] as! String

    }


//  MARK : TABLEVIEW - METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.QuestionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let lcdict = CheckListArr[indexPath.row]
        self.V_pass = lcdict["c_pass_per"] as! String
        self.V_avg = lcdict["c_avg_per"] as! String
        
        let lcDict = QuestionArray[indexPath.row]
        let indexNumber = indexPath.row + 1

        let Qtype = lcDict["c_q_type"] as! String
        
        if Qtype == "1"
        {
             self.Qcell = tblQuestions.dequeueReusableCell(withIdentifier: "ChecklistQuetionCell", for: indexPath) as! ChecklistQuetionCell
          
            print(formValid)
            let Qstr = lcDict["c_q_question"] as! String
           Qcell.backView.applyShadowAndRadiustoView()
          
           
            Qcell.lblQuestion.text = "Q." + String(indexNumber) + "  " + Qstr
          
            Qcell.btnSubmit.tag = indexPath.row
            Qcell.btnTakeImg.tag = indexPath.row
            Qcell.btnViewPhotos.tag = indexPath.row
            
            Qcell.btnSubmit.addTarget(self, action:  #selector(SubmitQuetions(sender:)), for: .touchUpInside)
            Qcell.btnTakeImg.addTarget(self, action: #selector(OpenCamera(sender:)), for: .touchUpInside)
            Qcell.btnYes.addTarget(self, action: #selector(btnYes_Click(sender:)), for: .touchUpInside)
            Qcell.btnNO.addTarget(self, action: #selector(btnNo_Click(sender:)), for: .touchUpInside)
            Qcell.btnNA.addTarget(self, action: #selector(btnNA_Click(sender:)), for: .touchUpInside)
            Qcell.btnViewPhotos.addTarget(self, action: #selector(btnViewPhotos_click(sender:)), for: .touchUpInside)
            return Qcell
        }else{
            
            let cell = tblQuestions.dequeueReusableCell(withIdentifier: "ChecklistQTypeCell", for: indexPath) as! ChecklistQTypeCell
            
            let Qstr = lcDict["c_q_question"] as! String
            
            cell.backView.applyShadowAndRadiustoView()
            cell.lblQuetnType.text = "Q." + String(indexNumber) + "  " + Qstr
            
            cell.btnSubmitQ.tag = indexPath.row
            cell.btntakeImage.tag = indexPath.row
            cell.btnViewPics.tag = indexPath.row
            
            cell.btnSubmitQ.addTarget(self, action: #selector(SubmitQuetions(sender:)), for: .touchUpInside)
            cell.btntakeImage.addTarget(self, action: #selector(OpenCamera(sender:)), for: .touchUpInside)
            cell.btnViewPics.addTarget(self, action: #selector(btnViewPhotos_click(sender:)), for: .touchUpInside)
            return cell
        }
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240.0
    }

    
//MARK : COLLECTIONVIEW - METHODS
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.SelectedIndexArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        let lcSelectedIndex = self.SelectedIndexArr[indexPath.row]
        
       cell.imgChecklist.image = lcSelectedIndex.CamImag
        
        return cell
    }
    
    
//  MARK :  ADD-TARGET - METHODS
    
    
    @objc func btnViewPhotos_click(sender: UIButton)
    {
        self.view.endEditing(true)
        
        let indexValue = sender.tag
        print(indexValue)
        
        self.SelectedIndexArr.removeAll(keepingCapacity: false)
        
        for lcImagefromCam in (self.m_cImageArrFromCam)
        {
            if indexValue == lcImagefromCam.indexCell
            {
                self.SelectedIndexArr.append(lcImagefromCam)
            }
            
        }
        
        popUp.contentView = viewImagesChecklist
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = false
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        
        collView.reloadData()
        
   }
    
    func GetArrcount(indexValue: Int) -> Int
    {
        self.SelectedIndexArr.removeAll(keepingCapacity: false)
        
        for lcImagefromCam in (self.m_cImageArrFromCam)
        {
            if indexValue == lcImagefromCam.indexCell
            {
                self.SelectedIndexArr.append(lcImagefromCam)
            }
            
        }
        return self.SelectedIndexArr.count
    }
    
    func getDate() -> String
    {
        var date =  Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd, hh:mm:ss"
        let lcDate = formatter.string(from: date)
        return lcDate
    }
    
   @objc func SubmitQuetions(sender: UIButton)
   {

    ClsfitnArr = ClassificationData.cDataClassification.fetchOfflineClassification()!
    
    ClsQueArr = ClassificationData.cDataClassification.fetchOfflineClsQueData()!
    
    for (index, _) in ClsfitnArr.enumerated()
    {
        let classEnt = ClsfitnArr[index] as! FetchClassification
        if ClassificationId == classEnt.class_id
        {
            for (index, _) in ClsQueArr.enumerated()
            {
                let classQueEnt = ClsQueArr[index] as! FetchQueData
                if classEnt.class_id == classQueEnt.class_id
                {
                    print("successs get")
                }
            }
        }
    }
    
    self.StartTimr = self.getDate()
    
    let lcDict = QuestionArray[sender.tag]
    
    m_cAnswerChecklistObj.q_type = lcDict["c_q_type"] as! String
    var AnsListDict = [String: Any]()
    var AnsImage = [String: Any]()
    var TicketDict = [String: Any]()
    let QueMarks = lcDict["c_q_marks"] as! String
    let Qstr = lcDict["c_q_question"] as! String
    m_cAnswerChecklistObj.max_marks = QueMarks
    m_cAnswerChecklistObj.q_id = lcDict["c_q_id"] as! String
    
    if m_cAnswerChecklistObj.q_type == "1"
    {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let cell = self.tblQuestions.cellForRow(at: indexpath) as! ChecklistQuetionCell
            
            
            if ((cell.btnYes.tag == 0) && (cell.btnNO.tag == 0) && (cell.btnNA.tag == 0))
            {
                self.toast.isShow("Please select answer")
                return
            }
      
        self.SelectedIndexArr.removeAll(keepingCapacity: false)
        
        let countImg = self.GetArrcount(indexValue: sender.tag)
        
            self.bCameraStatus = false
           // if cell.btnNO.tag == 2
           if cell.btnNO.isSelected
            {
                
                if cell.txtRemarks.text == ""
                {
                    self.toast.isShow("Please enter remark")
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
            
            if cell.btnYes.tag == 1
            {
                m_cAnswerChecklistObj.marks_obtained = QueMarks
                
            }else if cell.btnNO.tag == 2
            {
                m_cAnswerChecklistObj.marks_obtained = "0"
                
            }else if cell.btnNA.tag == 3
            {
                m_cAnswerChecklistObj.marks_obtained = "0"
            }
           
            self.SelectedIndexArr.removeAll(keepingCapacity: false)
            
           let count = self.GetArrcount(indexValue: sender.tag)
            
            if count == 0{
               self.m_cAnswerChecklistObj.photo_status = "0"
            }else{
                self.m_cAnswerChecklistObj.photo_status = "1"
            }
            
            AnsListDict["ans"] = m_cAnswerChecklistObj.ans
            AnsListDict["answered_time"] = self.getDate()
            AnsListDict["input"] = "0"
            AnsListDict["marks_obtained"] = m_cAnswerChecklistObj.marks_obtained
            AnsListDict["max_marks"] = m_cAnswerChecklistObj.max_marks
            AnsListDict["photo_status"] = m_cAnswerChecklistObj.photo_status
            AnsListDict["q_id"] = m_cAnswerChecklistObj.q_id
            AnsListDict["q_type"] = m_cAnswerChecklistObj.q_type
        
        if cell.txtRemarks.text != ""
        {
             AnsListDict["remark"] = "\(cell.txtRemarks.text!)"
        }else{
            AnsListDict["remark"] = ""
        }
        
            
            self.AnsChecklistArr.append(AnsListDict)
    
        var lcDict = [String: String]()
        
        for lcSelectedArr in SelectedIndexArr
        {
            lcDict["q_id"] = m_cAnswerChecklistObj.q_id
            lcDict["se_img_time"]  = lcSelectedArr.ImgPicTime
            lcDict["se_img_url"] = lcSelectedArr.ImagName
            self.AnswerImgArr.append(lcDict as AnyObject)
        }
        print(self.AnswerImgArr)
        cSubmitChecklist.m_ticket_status = "0"
        let Random : Int = Int(arc4random_uniform(UInt32(self.QuestionArray.count))+1)
        print("Random Num",Random)
        if Random == sender.tag
        {
           self.RandomQueId = m_cAnswerChecklistObj.q_id
            print("RandQueId", self.RandomQueId)
           self.OpenRandomQue()
        }
       
        cell.backView.backgroundColor = UIColor(red:1.00, green:0.89, blue:0.77, alpha:1.0)
        cell.backView.isUserInteractionEnabled = false
        cell.btnViewPhotos.isUserInteractionEnabled = true
            
        }else{
            let indexpath = IndexPath(row: sender.tag, section: 0)
            
            let cell = self.tblQuestions.cellForRow(at: indexpath) as! ChecklistQTypeCell
        
         let count = self.GetArrcount(indexValue: sender.tag)
            self.bCameraStatus = false
        
           if cell.txtAnswer.text == ""
            {
                self.toast.isShow("Please select answer")
                return
            }
        
            if count == 0{
                self.m_cAnswerChecklistObj.photo_status = "0"
            }else{
                self.m_cAnswerChecklistObj.photo_status = "1"
            }
            
            m_cAnswerChecklistObj.marks_obtained = QueMarks
            cSubmitChecklist.m_ticket_status = "0"
        
        if m_cAnswerChecklistObj.q_type == "3"
         {
            
            if cell.txtAnswer.text == ""
            {
                self.toast.isShow("Please select answer")
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
            
           
            let InputVal = cell.txtAnswer.text
            
            if InputVal != ""
            {
                let minVal = lcDict["c_q_min_value"] as! String
                let maxVal = lcDict["c_q_max_value"] as! String
                
                if minVal...maxVal ~= InputVal!
                {
                    m_cAnswerChecklistObj.marks_obtained = QueMarks
                    m_cAnswerChecklistObj.ans = "1"
                     cSubmitChecklist.m_ticket_status = "0"
                    self.TicketDataArr = []
                    
                }else{
                
                    m_cAnswerChecklistObj.marks_obtained = "0"
                    m_cAnswerChecklistObj.ans = "2"
                    
                     cSubmitChecklist.m_ticket_status = "1"
                    
                    // m_ticket_data is send
                
            for(index, _) in LocationDaraArr.enumerated()
                {
                        let LocEntity = LocationDaraArr[index] as! FetchLocation
                        
                        if LocEntity.l_barcode == self.QrStr
                        {
                            Branchid = LocEntity.branch_id
                            Locid = LocEntity.l_id
                        }
                    }
                    
            
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
            AnsListDict["remark"] = ""
        }
        
            
        self.AnsChecklistArr.append(AnsListDict)
        
        var lcDict = [String: String]()
        
        for lcSelectedArr in SelectedIndexArr
        {
            lcDict["q_id"] = m_cAnswerChecklistObj.q_id
            lcDict["se_img_time"]  = lcSelectedArr.ImgPicTime
            lcDict["se_img_url"] = lcSelectedArr.ImagName
            self.AnswerImgArr.append(lcDict as AnyObject)
        }
        print(self.AnswerImgArr)
        
        let Random : Int = Int(arc4random_uniform(UInt32(self.QuestionArray.count))+1)
        print("Random Num",Random)
        if Random == sender.tag
        {
            self.RandomQueId = m_cAnswerChecklistObj.q_id
            print("RandQueId", self.RandomQueId)
            self.OpenRandomQue()
        }
        
         cell.backView.backgroundColor = UIColor(red:1.00, green:0.89, blue:0.77, alpha:1.0)
        cell.backView.isUserInteractionEnabled = false
        cell.btnViewPics.isUserInteractionEnabled = true
    }
   
    
}
   
    @objc func OpenCamera(sender: UIButton)
    {
        self.view.endEditing(true)
        let indexValue = sender.tag
        print(indexValue)
        
        self.SelectedIndexArr.removeAll(keepingCapacity: false)
        
        for lcImagefromCam in (self.m_cImageArrFromCam)
        {
            if indexValue == lcImagefromCam.indexCell
            {
                self.SelectedIndexArr.append(lcImagefromCam)
            }
        }
        
        let lcDict = QuestionArray[sender.tag]
        let Qtype = lcDict["c_q_type"] as! String
        if Qtype == "1"
        {
            if SelectedIndexArr.count == 4
            {
                let indexpath = IndexPath(row: sender.tag, section: 0)
                let cell = self.tblQuestions.cellForRow(at: indexpath) as! ChecklistQuetionCell
                
                cell.btnTakeImg.isUserInteractionEnabled = false
                cell.btnTakeImg.tintColor = UIColor.gray
                return
            }
        }else
        {
            if SelectedIndexArr.count == 4
            {
                let indexpath = IndexPath(row: sender.tag, section: 0)
                let cell = self.tblQuestions.cellForRow(at: indexpath) as! ChecklistQTypeCell
                
                cell.btntakeImage.isUserInteractionEnabled = false
                cell.btntakeImage.tintColor = UIColor.gray
                return
            }
            
        }
        
        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: libraryEnabled){ [weak self] image, asset in
            var lcFileName: String!
            weak var weakSelf = self
   //         self?.gettingImg = image
            if image != nil
            {
                
                let numberOfImages: UInt32 = 100
                let random = arc4random_uniform(numberOfImages)
                image?.accessibilityIdentifier = "image_\(random).jpeg"
                lcFileName = image?.GetFileName()
        
                print("lcfilename=\(lcFileName)")
                self?.ImageArr.append(image!)
                print(sender.tag)
                
                if (self?.b_randomQueImg)!
                {
                    print("RandQueId", self?.RandomQueId)
                    let lcRandomImg = AnsImage(QueId: (self?.RandomQueId)!, ImgUrl: lcFileName)
                    self?.m_cAnsImage.append(lcRandomImg)
                    
                }else{
                    let lcImageFromCam = ImgeFromCam(Index: sender.tag, Img: image!, ImgName: lcFileName, ImgUrl: lcFileName, ImgPicTime: (self?.getDate())!)
                    self?.m_cImageArrFromCam.append(lcImageFromCam)
                    
                }
                
             
                self?.SelectedIndexArr.removeAll(keepingCapacity: false)
                
                for lcImagefromCam in (self?.m_cImageArrFromCam)!
                {
                    if indexValue == lcImagefromCam.indexCell
                    {
                    self?.SelectedIndexArr.append(lcImagefromCam)
                    }
                    
                }
                
                for _ in (weakSelf?.SelectedIndexArr)!
                {
                    
                    if (weakSelf?.imageNameArr.contains(lcFileName))!
                    {
                        print("getting lcfile name")
                    }else{
                        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        
                        let fileURL = documentsDirectory.appendingPathComponent(lcFileName)
                        print(lcFileName)
                   //     lcFileName = item.GetFileName()
                        self?.imgArr.append(fileURL.lastPathComponent)    // store only namesof images
                        
                        self?.filePathArr.append(fileURL.path)
                        // Create imageData and write to filePath
                        
                        if let data = UIImageJPEGRepresentation(image!, 0.0),
                            !FileManager.default.fileExists(atPath: fileURL.path){
                            do {
                                // writes the image data to disk
                                print("fileURL=\(fileURL)")
                                self?.filePath = fileURL.path
                                try data.write(to: fileURL)
                                print("file saved")
                            } catch {
                                print("error saving file:", error)
                            }
                        }
                        weakSelf?.imageNameArr.append(lcFileName)
                    }
                }
                
                
                self?.bCameraStatus = true
            }else
            {
                self?.bCameraStatus = false
            }
            self?.collView.reloadData()
            self?.dismiss(animated: true, completion: nil)
            
            if (self?.b_randomQueImg)!
            {
                self?.OpenRandomQue()
            }
          
        }
        present(cameraViewController, animated: true, completion: nil)
        
    }
    
    
    @objc func btnYes_Click(sender: DLRadioButton)
    {
        self.view.endEditing(true)
        let cell = GetIndexPath(sender: sender)
        cell.btnYes.tag = 1
        m_cAnswerChecklistObj.ans = "1"
    }
    
    @objc func btnNo_Click(sender: DLRadioButton)
    {
        self.view.endEditing(true)
        let cell = GetIndexPath(sender: sender)
        cell.btnNO.tag = 2
        m_cAnswerChecklistObj.ans = "2"
    }
    
    @objc func btnNA_Click(sender: DLRadioButton)
    {
        self.view.endEditing(true)
        let cell = GetIndexPath(sender: sender)
        cell.btnNA.tag = 3
        m_cAnswerChecklistObj.ans = "0"
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
    
    @IBAction func btnDone_OnClick(_ sender: Any)
    {
        setFilled_ChecklistData()
       sendData()
    }
    
// MARK: EXTRA - METHODS
    
    @IBAction func setRandomQue(_ sender: Any)
    {
        popUp.dismiss(true)
        self.b_randomQueImg = true
        OpenCamera(sender: btnCamRabdom)
    }
    
    @IBAction func btnSubmitRandomQue_Click(_ sender: Any)
    {
        self.b_randomQueImg = false
        popUp.dismiss(true)
    }
    func setFilled_ChecklistData()
    {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd, hh:mm:ss"
//        let DATE = formatter.string(from: date)
//        print(DATE)
//        self.EndTime = DATE
//
        
        self.EndTime = self.getDate()
        var Score : String!
        var OutOfLoc : String!
        LocationDaraArr = LocationData.cLocationData.fetchOfflineLocation()!

        let imgCount = self.SelectedIndexArr.count
        cSubmitChecklist.totalImages = String(imgCount)
        
        var lcMarkObtained: Float = 0.0
        var lcmaxmarks: Float = 0.0
        var lcFinalMarks: Float = 0.0
        var lcFinalmaxmarks: Float = 0.0
        
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
            
            if LocEntity.l_barcode == self.QrStr
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
        
        let lcQueIdArr = self.m_cAnsImage.map {$0.q_id}
        let lcQueImgArr = self.m_cAnsImage.map {$0.se_img_url}
        
        let Filled_Checklist : [String: Any] =
            [
             "b_id" : Branchid,
             "cl_id" : self.ClassificationId,
             "end_time" : self.EndTime,
             "l_id" : Locid,
             "l_lat" : self.Latitude,
             "l_long" : self.Longitude,
             "out_of_loc" : OutOfLoc,
             "p_id" : self.ProjId,
             "percentage" : self.Percent,
             "rand_q_id" : json(from: lcQueIdArr),
             "rand_q_photo" : json(from: lcQueImgArr),
             "score" : Score,
             "start_time" : self.StartTimr
            ]
        self.FilledChecklistArr.append(Filled_Checklist)
       
    }
    
    func sendData()
    {
      
        cSubmitChecklist.totalImages = String(self.m_cImageArrFromCam.count)
        cSubmitChecklist.checklist_answer = json(from: self.AnsChecklistArr)
        cSubmitChecklist.m_ticket_data = json(from: self.TicketDataArr)
        cSubmitChecklist.filled_checklist = json(from: self.FilledChecklistArr)
        cSubmitChecklist.answer_image = json(from: AnswerImgArr)
        
       let uploadUrl = "http://kanishkagroups.com/Qualus/index.php/AndroidV2/Checklist/upload_filled_checklist"
       
        
        let Param : [String: Any] =
            [ "totalImages" : cSubmitChecklist.totalImages,
              "filled_checklist" : cSubmitChecklist.filled_checklist!,
              "checklist_answer" : cSubmitChecklist.checklist_answer,
              "answer_image" : cSubmitChecklist.answer_image,
              "m_ticket_status" : cSubmitChecklist.m_ticket_status,
              "m_ticket_data" : cSubmitChecklist.m_ticket_data,
              "user_id" : cSubmitChecklist.user_id,
              "user_role" : cSubmitChecklist.user_role,
              "com_id" : cSubmitChecklist.com_id,
        
            ]
        print("Param", Param)
    
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                if self.m_cImageArrFromCam.isEmpty
                {
                    print("no Image for upload")
                    self.cSubmitChecklist.Images = "NF"
                }else{
                    
                    for (index,lcImage) in self.m_cImageArrFromCam.enumerated()
                    {
                        let image = lcImage.CamImag
                            print(index)
                        let data = UIImageJPEGRepresentation(image!,0.0)
                        multipartFormData.append(data!, withName: "Images" + String(format:"%d",index), fileName: lcImage.ImagName, mimeType: "image/jpeg")
                        
                    }
                }
            
                for (key, val) in Param {
                    multipartFormData.append((val as AnyObject).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue).rawValue)!, withName: key)
                }
        },
            
            usingThreshold : SessionManager.multipartFormDataEncodingMemoryThreshold,
            to : uploadUrl,
            method: .post)
        { (result) in
            
            
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    
                    if let JSON = response.result.value as? [String: Any] {
                        print("Response : ",JSON)

                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation: CLLocation = locations[locations.count - 1]
        
        self.Latitude = String(format: "%.6f", lastLocation.coordinate.latitude)
        self.Longitude = String(format: "%.6f", lastLocation.coordinate.longitude)
        
    }
  
    func OpenRandomQue()
    {
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
