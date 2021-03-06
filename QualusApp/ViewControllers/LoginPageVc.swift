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
        let LoginUrl = "https://qualus.ksoftpl.com/index.php/AndroidV2/Login/userLogin"
        
        let loginParam : [String: AnyObject] = [
            
            "com_id" :  self.com_id as AnyObject,
            "user_name" : txtUserNm.text! as AnyObject,
            "user_password" : txtPasswordFld.text! as AnyObject
        ]

        Alamofire.request(LoginUrl, method: .post, parameters: loginParam).responseJSON { (LoginData) in
            print(LoginData)
            
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

                    UserDefaults.standard.set(self.txtPasswordFld.text, forKey: "passwordd");
                    UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
                    
                    let user_id = UserData["user_id"] as! String
                    let Role = UserData["role"] as! String
                    self.ComId = UserData["com_id"] as! String
                    
                    self.sendFcmToken(userid: user_id)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SplashScreenVc") as! SplashScreenVc
                    vc.setViewController(user_id: user_id, Role: Role)
                  //  vc.Password = self.txtPasswordFld.text!
                    self.navigationController?.pushViewController(vc, animated: true)
                    
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
        let AbbrUrl = "https://qualus.ksoftpl.com/index.php/AndroidV2/Login/get_com_id_by_abbr"
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
    
    func sendFcmToken(userid: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let FcmToken = appDelegate.FCMToken
        
        let Api = constant.BaseUrl + constant.fcmToken
        let param = ["user_id" : userid,
                     "gcmid" : FcmToken!,
                     "type" : "ios"]
        print(param)
        
        Alamofire.request(Api, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! String
                if json == "success"
                {
                    self.toast.isShow("fcm token send to server")
                }
                break
            case .failure(_):
                self.toast.isShow("fcm tokem is not generated because of some network issue. If you didn't get any notification, please login again.")
                break
            }
        }
    }
    
}
