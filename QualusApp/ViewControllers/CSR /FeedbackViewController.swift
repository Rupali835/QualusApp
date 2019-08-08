
import UIKit
import Alamofire
import SVProgressHUD

class FeedbackViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var Mainview: UIView!
    @IBOutlet weak var btnbad: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtremark: UITextView!
    @IBOutlet weak var btnterrible: UIButton!
    @IBOutlet weak var btnokay: UIButton!
    @IBOutlet weak var btngreat: UIButton!
    @IBOutlet weak var btngood: UIButton!
    
    var l_id: String!
    var p_id: String!
    var br_id: String!
    var rating: String!
    var user_id: String!
    var userid:String!
    var smileRating: Int! = 0
    var campanyid:String!
    var toast = JYToast()
    var Password: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OrientationManager.landscapeSupported = true
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        
        UIDevice.current.setValue(value, forKey: "orientation")
        
        
//        let value = UIInterfaceOrientation.landscapeLeft.rawValue
//
//        UIDevice.current.setValue(value, forKey: "orientation")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationDidChange), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
        
        let check = UserDefaults.standard.object(forKey: "checkVC")
        print(check!)
        
        Password = UserDefaults.standard.object(forKey: "passwordd") as! String

        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        userid = lcDict["user_id"] as! String
        campanyid = lcDict["com_id"] as! String
        self.txtremark.delegate = self
        self.txtremark.text = "Enter Remark Here"
        txtremark.layer.borderWidth = 0.5
        txtName.layer.borderWidth = 0.5
        txtremark.layer.cornerRadius = 5
        txtName.layer.cornerRadius = 5
        txtName.layer.borderColor = UIColor.gray.cgColor
        txtremark.layer.borderColor = UIColor.gray.cgColor
        self.navigationItem.hidesBackButton = true
        
        
        var newBackButton = UIBarButtonItem()
        newBackButton = UIBarButtonItem(title: "Select Project", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.BackTapped))
        self.navigationItem.leftBarButtonItem = newBackButton
        
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        OrientationManager.landscapeSupported = true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }

    
     func shouldAutorotate() -> Bool {
        return true
    }
    
    @objc func orientationDidChange(notification: NSNotification) {
        //videocollection!.collectionViewLayout.invalidateLayout()
    }
    
    @objc func BackTapped()
    {
        print("back button pressed")        // check wheter enter pwd is correct
        
        let alert = UIAlertController.init(title: "Please enter a password for select another project", message: "", preferredStyle: .alert )
        alert.addTextField
            { (temp) in
                temp.placeholder = "Enter password"
                temp.isSecureTextEntry = true
        }
        
        let OkAlert = UIAlertAction(title: "OK", style: .default) { (temp) in
            let pwd = alert.textFields?[0].text
          if self.Password == pwd
                {
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)

                    var csrVC = storyboard.instantiateViewController(withIdentifier: "CSRViewController") as! CSRViewController
                    let bool: String = "false"
                    UserDefaults.standard.set(bool, forKey: "checkVC")
                    
//                    UserDefaults.standard.removeObject(forKey: "UserData")
//                    UserDefaults.standard.removeObject(forKey: "checkVC")
 //                   UserDefaults.standard.removeObject(forKey: "passwordd")
                    
                    
                    self.navigationController?.pushViewController(csrVC, animated: true)
                   
                }else{
                    self.toast.isShow("Password Incorrect")
                }

        }
        let CancleAlert = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(OkAlert)
        alert.addAction(CancleAlert)
        self.present(alert, animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView == txtremark
        {
            txtremark.text = nil
            txtremark.textColor = UIColor.black
        }
    }
    
    func SelectedButton()
    {
        if smileRating == 1
        {
            btnterrible.tintColor = UIColor.redlight //terible
            btnbad.tintColor = UIColor.lightGray
            btngood.tintColor = UIColor.lightGray
            btnokay.tintColor = UIColor.lightGray
            btngreat.tintColor = UIColor.lightGray
            
        }else if smileRating == 2
        {
            btnbad.tintColor = UIColor.smileYellow // bad
            btngood.tintColor = UIColor.lightGray
            btnokay.tintColor = UIColor.lightGray
            btngreat.tintColor = UIColor.lightGray
            btnterrible.tintColor = UIColor.lightGray
            
        }else if smileRating == 3{
            btnokay.tintColor = UIColor.smileYellow // ok
            btngood.tintColor = UIColor.lightGray
            btngreat.tintColor = UIColor.lightGray
            btnterrible.tintColor = UIColor.lightGray
            btnbad.tintColor = UIColor.lightGray
            
        }else if smileRating == 4
        {
            btngood.tintColor = UIColor.smileYellow // good
            btnterrible.tintColor = UIColor.lightGray
            btnbad.tintColor = UIColor.lightGray
            btnokay.tintColor = UIColor.lightGray
            btngreat.tintColor = UIColor.lightGray
            
        }else{
            btngreat.tintColor = UIColor.smileYellow // good
            btnterrible.tintColor = UIColor.lightGray
            btnbad.tintColor = UIColor.lightGray
            btnokay.tintColor = UIColor.lightGray
            btngood.tintColor = UIColor.lightGray
        }
        
    }
    
    
//    func checkFeild()
//    {
//        if smileRating
//    }
    
    //Mark:Actions
    
    @IBAction func ratingClicked(_ sender: UIButton) {
            smileRating = sender.tag
          //  print(sender.tag)
            SelectedButton()
    }
    
    @IBAction func submitRemarkClicked(_ sender: Any) {
        print(smileRating)
        
        if smileRating == 0
        {
            self.toast.isShow("Please Selecet Rating")
        }else if (txtremark.text == "")||(txtremark.text == "Enter Remark Here")
        {
            self.toast.isShow("Please Enter Remark")

        }else
        {
            
            OperationQueue.main.addOperation {
                SVProgressHUD.setDefaultMaskType(.custom)
                SVProgressHUD.setBackgroundColor(UIColor.gray)
                SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
                SVProgressHUD.show()
            }
            if txtName.text == ""
            {
                txtName.text = "NF"
            }
            
            let feedbckurl = "http://kanishkagroups.com/Qualus/index.php/AndroidV2/Location/add_location_feedback"
            let parameter = ["l_id":l_id!,
                             "com_id":campanyid!,
                             "p_id":p_id!,
                             "br_id":br_id!,
                             "rating": "\(smileRating!)",
                "remark":txtremark.text!,
                "name":txtName.text!,
                "user_id": userid!]
            
            print(parameter)
            
            Alamofire.request(feedbckurl, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (resp) in
                
                OperationQueue.main.addOperation {
                    
                    let data = resp.result.value
                    
                    if let Data = data
                    {
                        let dict = Data as! [String: AnyObject]
                        let strResult = dict["msg"] as! String
                        if strResult == "SUCCESS"
                        {
                            OperationQueue.main.addOperation {
                                SVProgressHUD.dismiss()
                                
                            }
                            print("Remark Given Done")
                            self.toast.isShow("Remark Uploaded successfully")
                            self.btnterrible.tintColor = UIColor.lightGray
                            self.btnbad.tintColor = UIColor.lightGray
                            self.btnokay.tintColor = UIColor.lightGray
                            self.btngood.tintColor = UIColor.lightGray
                            self.btngreat.tintColor = UIColor.lightGray
                            self.txtName.text = ""
                            self.txtremark.textColor = UIColor.lightGray
                            self.txtremark.text = "Enter Remark Here"

                        }
                        
                    }
                }
            }
        }
        
        
    }
 }




