//
//  LoginPageVc.swift
//  QualusApp
//
//  Created by user on 17/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import TextFieldEffects
import SVProgressHUD

class LoginPageVc: UIViewController {

    @IBOutlet weak var txtUserNm: KaedeTextField!
    @IBOutlet weak var txtPasswordFld: KaedeTextField!
    
    private var toast : JYToast!
    var cAbbrVc : AbbrevationVc!
    var ComId : String = ""
    var ckeckCom_id : Bool!
    var com_id : String = ""
    var AbbrevationNm : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUi()
        
        let dict = UserDefaults.standard.object(forKey: "UserData") as? [String : AnyObject]
        if dict == nil
        {
             AbbrevationVcCall()
        }
       
//        self.txtUserNm.text = "rupali@kspl.com"
//        self.txtPasswordFld.text = "Rupali@kspl"
//
        
    }

    override func awakeFromNib()
    {
        self.cAbbrVc = self.storyboard?.instantiateViewController(withIdentifier: "AbbrevationVc") as! AbbrevationVc
    }
    

    private func initUi()
    {
        toast = JYToast()
    }
    
    
    func LoginApi()
    {
        if self.ComId != "0"
        {
            self.com_id = self.ComId
        }
        else{
            self.com_id = "0"
        }
        let LoginUrl = "http://kanishkagroups.com/Qualus/index.php/Android/Login/userLogin"
        let loginParam : [String: AnyObject] = [
            
            "com_id" :  self.com_id as AnyObject,
            "user_name" : txtUserNm.text! as AnyObject,
            "user_password" : txtPasswordFld.text! as AnyObject
        ]
        
        
        Alamofire.request(LoginUrl, method: .post, parameters: loginParam).responseJSON { (LoginData) in
            
            OperationQueue.main.addOperation {
                SVProgressHUD.dismiss()
            }
            let data = LoginData.result.value
            
            if let Data = data
            {
                let dict = Data as! [String: AnyObject]
                let strResult = dict["msg"] as! String
                if strResult == "SUCCESS"
                {
                    
                    let UserData = dict["data"] as! [String: AnyObject]
                    print(UserData)
                    UserDefaults.standard.set(UserData, forKey: "UserData")
                    UserDefaults.standard.synchronize()
                    let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
                    //print(lcDict)
                    
                    let user_id = UserData["user_id"] as! String
                    let name = UserData["full_name"] as! String
                    let Role = UserData["role"] as! String
                    let UserLoginStatus = UserData["user_logged_in"] as! String
                    self.ComId = UserData["com_id"] as! String
                    
                    userDataList.cUserData.getUserList(cUserNm: user_id, cRole: Role, user_id: user_id)
                    ClassificationData.cDataClassification.fetchClassifictnData()
                    MapLocation.cMapLocationData.fetchMapLocation(UserId: user_id)
                    
                    LocationData.cLocationData.fetchData(lcUID: user_id, lcRole: Role, arg: true, completion: {(sucess) -> Void in
                         if sucess{
                            self.setViewFromRole(Role: Role)
                            
                        } else {
                            
                            print("false")
                        }
                       

                    })
                    
                    ProjectVc.cProjectData.fetchProjectList(usernm: user_id, user_role: Role, arg: true, completion: {(sucess) -> Void in
                        if sucess
                        {
                            self.setViewFromRole(Role: Role)
                            
                        } else {
                            
                            print("false")
                        }
                        
                    })
                    
                }
                else if strResult == "aleardy loggedin"
                {
                    
                    self.toast.isShow(ErrorMsgs.alredyLogin)
                }
                else if strResult == "nf"
                {
                    self.toast.isShow(ErrorMsgs.loginNotmatch)
                }
            }else{
                self.toast.isShow("No data found")
            }
            
            
        }
        
        
    }
    
    func setViewFromRole(Role: String)
    {
        if (Role == "6") || (Role == "1") || (Role == "8")

        {
            let managevc = ManagementViewController.init(nibName: "ManagementViewController", bundle: nil)
            self.navigationController?.pushViewController(managevc, animated: true)
            
        }else if Role == "3"
        {
            let ProjVc = self.storyboard?.instantiateViewController(withIdentifier: "ProjectInfoVc") as! ProjectInfoVc
            self.navigationController?.pushViewController(ProjVc, animated: true)
        }
    }
    
    
    func funShowAlert(_ varTitle: String, _ varMessage: String){
        let alertPassword = UIAlertController(title: varTitle, message: varMessage, preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
           // print("Ok")
        })
        
        alertPassword.addAction(okAction)
        
        self.present(alertPassword, animated: true, completion: nil)
    }
    
    @IBAction func btnLogin_Click(_ sender: Any)
    {
        var valid = Bool(true)
        
        if txtUserNm.text == ""
        {
            self.toast.isShow("Please Enter a Username")
            valid = false
            return
        }
        if txtPasswordFld.text == ""
        {
            self.toast.isShow("Please Enter a Password")
            valid = false
            return
        }
        if valid == true
        {
            self.LoginApi()
            OperationQueue.main.addOperation {
                
                SVProgressHUD.show()
                
            }
            
        }
        
    }
    
    func getAbbrevation()
    {
        let AbbrUrl = "http://kanishkagroups.com/Qualus/index.php/Android/Login/get_com_id_by_abbr"
        let Abbrparam = ["com_abbr" : self.AbbrevationNm!]
    
        Alamofire.request(AbbrUrl, method: .post, parameters: Abbrparam).responseJSON { (ApiResult) in
            print(ApiResult)
    
            let data = ApiResult.result.value
            let dict = data as! [String: AnyObject]
            let strSuccess = dict["msg"] as! String
            if strSuccess == "SUCCESS"
            {
                self.ComId = dict["com_id"] as! String
                print("Comid:", self.ComId)

    
                self.toast.isShow("Company Abbrevation is correct. Login with Employee Id")
            }
            if strSuccess == "FAIL"
            {
                self.toast.isShow("Company Abbrevation incorrect")
            }
    
        }
    }
    
    func AbbrevationVcCall()
    {
        
        let alert = UIAlertController(title: "Qualus",
                                      message: "If you want to Login with Employee Id Please provide company Abbrevation else use Email Id",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Submit",
                                       style: .default)
        {
            [unowned self] action in
            
            
            
     let textField = alert.textFields?.first
            textField?.placeholder = "Enter a company abbrevation"
            self.AbbrevationNm = textField?.text
                    
          self.getAbbrevation()
                                     
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        self.ComId = "0"
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}
