//
//  AbbrevationVc.swift
//  QualusApp
//
//  Created by user on 17/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class AbbrevationVc: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var txtAbbr: UITextField!
    
    private var toast: JYToast!
    var checkComid = Bool(true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   initUi()

    }
    private func initUi()
    {
        toast = JYToast()
    }
    

  
    
 //   @IBAction func btnSubmit_Click(_ sender: Any)
//    {
//        let AbbrUrl = "http://kanishkagroups.com/Qualus/index.php/Android/Login/get_com_id_by_abbr"
//        let Abbrparam = ["com_abbr" : txtAbbr.text!]
//
//        Alamofire.request(AbbrUrl, method: .post, parameters: Abbrparam).responseJSON { (ApiResult) in
//            print(ApiResult)
//
//            let data = ApiResult.result.value
//            let dict = data as! [String: AnyObject]
//            let strSuccess = dict["msg"] as! String
//            if strSuccess == "SUCCESS"
//            {
//                let comId = dict["com_id"] as! String
//                print("Comid:", comId)
//
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginPageVc") as! LoginPageVc
//
//                vc.setComId(Com_id: comId, checkId: true)
//                //vc.ckeckCom_id = self.checkComid
//
//                self.view.removeFromSuperview()
//
//
//                self.toast.isShow("Company Abbrevation is correct. Login with Employee Id")
//            }
//            if strSuccess == "FAIL"
//            {
//                self.toast.isShow("Company Abbrevation incorrect")
//                self.view.removeFromSuperview()
//            }
//
//        }
//    }
//
//    @IBAction func btnCancle_Click(_ sender: Any)
//    {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginPageVc") as! LoginPageVc
//
//        vc.setComId(Com_id: "0", checkId: false)
//
//        self.view.removeFromSuperview()
//    }
//
//


  
}
