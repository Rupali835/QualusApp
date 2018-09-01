//
//  GenarateMaverickTicketVc.swift
//  QualusApp
//
//  Created by user on 25/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import ALCameraViewController

class GenarateMaverickTicketVc: UIViewController, UITextViewDelegate, UITextFieldDelegate, imageUploadDelegate{
    
    //MARK: OUTLATE
    
    @IBOutlet weak var stackViewTopHIghtConstrains: NSLayoutConstraint!
    @IBOutlet weak var backViewHeight: NSLayoutConstraint!
    @IBOutlet weak var txtRemark: UITextView!
    @IBOutlet weak var txtActionPlan: UITextView!
    @IBOutlet weak var txtEnterObservation: UITextView!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var Selectdate: UITextField!
    @IBOutlet weak var btnAddImg: UIButton!
    @IBOutlet var imageDisplayView: UIView!
    @IBOutlet weak var displayimage: UIImageView!
    
    //MARK: VARIABLE
    var QRstr : String      = ""
    var LocationDaraArr     = [AnyObject]()
    var userId : String     = ""
    var Comid : String      = ""
    var DatePicker          = UIDatePicker()
    let toolBar             = UIToolbar()
    var DateStr             : String!
    var popUp               : KLCPopup!
    var showVc              : Bool!                 // bool to check which ticket should 
    var toast               = JYToast()

    
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
    
    var croppingParameters: CroppingParameters {
        return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumSize)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        popUp = KLCPopup()
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        self.userId = lcDict["user_id"] as! String
        self.Comid = lcDict["com_id"] as! String
        
        self.txtRemark.delegate = self
        self.txtActionPlan.delegate = self
        self.txtEnterObservation.delegate = self
        self.Selectdate.delegate = self
        self.imageCollection.dataSource = self
        self.imageCollection.delegate = self
        self.setTextFld(txtView: txtEnterObservation, cPlaceStr: "Enter Observation")
        self.setTextFld(txtView: txtActionPlan, cPlaceStr: "Suggest Action Plan")
        self.setTextFld(txtView: txtRemark, cPlaceStr: "Enter Remark")
        LocationDaraArr = LocationData.cLocationData.fetchOfflineLocation()!
        imageCollection.registerCellNib(TicketImagesCVC.self)
        createDatePicker()

        print("show vc barcode/scanner\(showVc)")
        
        if self.showVc == false // camera Not allowed
        {
            imageCollection.isHidden = true
            btnAddImg.isHidden = true
            stackViewTopHIghtConstrains.constant = -90
            backViewHeight.constant = 350
            
        }else{
            imageCollection.isHidden = false
            btnAddImg.isHidden = false
            stackViewTopHIghtConstrains.constant = 10
            backViewHeight.constant = 450
        }

        
    }
    
    //MARK: FUNCTIONS
    
    
    func createDatePicker()
    {
        
        DatePicker.datePickerMode = .date
        let currentdate = Date()
        DatePicker.minimumDate = currentdate //customer not allowed to set privious date of privious month
        toolBar.sizeToFit()
       let barBtnItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePresses))
        toolBar.setItems([barBtnItem], animated: false)
        Selectdate.inputAccessoryView = toolBar
        Selectdate.inputView = DatePicker
    }
 
    @objc func donePresses()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        lbldate.text = dateFormatter.string(from: DatePicker.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.DateStr = self.convertDateFormater(dateFormatter.string(from: DatePicker.date))
        lbldate.text = DateStr
        self.view.endEditing(true)
       
    }
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
        
    }
    
    func setQrString(cQr: String)
    {
        self.QRstr = cQr
    }
    
    func designCell(cView : UIView)
    {
        cView.layer.masksToBounds = false
        cView.layer.shadowColor = UIColor.black.cgColor
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: -1, height: 1)
        cView.layer.shadowRadius = 1
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView == txtEnterObservation
        {
            txtEnterObservation.text = nil
            txtEnterObservation.textColor = UIColor.black
        }
        if textView == txtActionPlan
        {
            txtActionPlan.text = nil
            txtActionPlan.textColor = UIColor.black
        }
        if textView == txtRemark
        {
            txtRemark.text = nil
            txtRemark.textColor = UIColor.black
        }
        
    }
    
    func setTextFld(txtView : UITextView, cPlaceStr : String)
    {
        txtView.layer.borderWidth = 1.0
        txtView.layer.borderColor = UIColor.gray.cgColor
        txtView.layer.cornerRadius = 3.0
        txtView.text = cPlaceStr
        txtView.textColor = UIColor.gray
        
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject:  object, options: []) else
        {
            return nil
        }
        
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func getLocation()
    {
        LocationDaraArr = LocationData.cLocationData.fetchOfflineLocation()!
          print("locations")
        for (index, _) in LocationDaraArr.enumerated()
        {
            let locationEnt = LocationDaraArr[index] as! FetchLocation
            
            if locationEnt.l_barcode == QRstr
            {
                let l_id = locationEnt.l_id!
                let p_id = locationEnt.p_id!
                let branchId = locationEnt.branch_id!
            
                Add_MaverickTikt(Pid: p_id, PbId: branchId, Lid: l_id, Userid: self.userId, ComId: self.Comid)
            }
            
            
        }
    }
    
    func Add_MaverickTikt(Pid: String, PbId : String, Lid : String, Userid : String, ComId : String)
    {
        print("Data")
        var jsonimgString = json(from: self.imgArr)
        let imageCount = String(self.ImageArr.count)

        if imgArr.isEmpty == true
        {
            jsonimgString = "NF"
        }
      
        let addParam = ["com_id" : ComId,
                        "p_id" : Pid,
                        "pb_id" : PbId,
                        "l_id" : Lid,
                        "l_barcode" : self.QRstr,
                        "user_id" : Userid,
                        "mt_subject" : "\(txtEnterObservation.text!)",
                        "mt_remark" : "\(txtRemark.text!)",
                        "mt_photo" : jsonimgString,
                        "totalImages" : imageCount,
                        "action_plan" : "\(txtActionPlan.text!)",
        "action_plan_date" : lbldate.text  ]as! [String: String]
        
        imageUpload.SharedInstance.ImageUploadData(lcParam: addParam , lcOriginalImgArr: self.ImageArr, lcImagArr: self.imgArr, cDelegate: self, withHUD: true)
        
    }
    
    func Success(MessgaStr: String) {
        let Alert: UIAlertController = UIAlertController(title: "Alert", message: MessgaStr, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            print("OK Action")
            self.imgArr.removeAll(keepingCapacity: false)
            self.filePathArr.removeAll(keepingCapacity: false)
            self.ImageArr.removeAll(keepingCapacity: false)
            self.txtRemark.text = ""
            self.txtActionPlan.text = ""
            self.txtEnterObservation.text = ""
            let MTVc = MaverickTicketViewVc()
        self.navigationController?.backToViewController(viewController: MaverickTicketViewVc.self)


        } )
        
        Alert.addAction(OKAction)
        self.present(Alert, animated: true, completion: nil)

    }

   
    //MARK: ACTIONS

    @IBAction func btnCamera_Click(_ sender: Any)
    {

   let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: libraryEnabled){ [weak self] image, asset in
            var lcFileName: String!
            weak var weakSelf = self
            
            if image != nil
            {
                let numberOfImages: UInt32 = 100
                let random = arc4random_uniform(numberOfImages)
                image?.accessibilityIdentifier = "image_\(random).jpeg"
                lcFileName = image?.GetFileName()
                print("lcfilename=\(lcFileName)")
                self?.ImageArr.append(image!)
                for _ in (weakSelf?.ImageArr)!
                {
                    if self?.ImageArr.count == 3
                    {
                        self?.btnAddImg.isHidden = true
                    }
                    if (weakSelf?.imageNameArr.contains(lcFileName))!
                    {
                        
                        print("getting lcfile name")
                        
                    }else{
                        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        
                        let fileURL = documentsDirectory.appendingPathComponent(lcFileName)
                        print(lcFileName)
                        //lcFileName = item.GetFileName()
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
                
        }
        self?.imageCollection.reloadData()
        self?.dismiss(animated: true, completion: nil)
        }
        present(cameraViewController, animated: true, completion: nil)
  
    }
    
    @IBAction func btnSubmit_Click(_ sender: Any)
    {
        if self.showVc == false
        {
            if (txtEnterObservation.text! == "Enter Observation") || (txtEnterObservation.text! == "")
            {
                self.toast.isShow(ErrorMsgs.NoObservation)
             }else
            {
               getLocation()
            }

        }else
        {
            if (txtEnterObservation.text! == "Enter Observation") || (txtEnterObservation.text! == "")
            {
                self.toast.isShow(ErrorMsgs.NoObservation)
            }else if imgArr.count <= 0
            {
                self.toast.isShow(ErrorMsgs.imageCmpousory)
                
            }else{
                getLocation()

            }

        }
        
        
    }

    @IBAction func cancledClicked(_ sender: Any) {
        self.navigationController?.backToViewController(viewController: MaverickTicketViewVc.self)

    }
    
    
    
    @IBAction func deleteImageClicked(_ sender: Any) {
        popUp.dismiss(true)
        ImageArr.remove(at: deletindex)
        imgArr.remove(at: deletindex)
        imageCollection.reloadData()
        if ImageArr.count < 3
        {
            btnAddImg.isHidden = false
        }
        
    }
    
    
}


//MARK: EXTENSIONS

extension UIImage
{
    func GetFileName() -> String
    {
        let lcImgName = self.accessibilityIdentifier
        return lcImgName!
    }
}

extension GenarateMaverickTicketVc: UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return ImageArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.className(TicketImagesCVC.self), for: indexPath) as! TicketImagesCVC
        cell.image.image = ImageArr[indexPath.row]
    
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        deletindex = indexPath.item
        popUp.contentView = imageDisplayView
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = true
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        displayimage.image =  ImageArr[indexPath.row]
        imageDisplayView.isHidden = false
    }

}
extension UINavigationController {
    
    func backToViewController(viewController: Swift.AnyClass) {
        
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}
















