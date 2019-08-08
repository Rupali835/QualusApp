//
//  SplashScreenVc.swift
//  QualusApp
//
//  Created by user on 17/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class SplashScreenVc: UIViewController {

  
    @IBOutlet weak var fullbackImg: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var MyImg: UIImageView!
    var ComId : String = ""
    let urlpath = "http://kanishkagroups.com/Qualus/uploads/company_logo/"
    var ImgPath : String!
    var Userrole : String = ""
    var userId : String = ""
    let manager = Alamofire.SessionManager.default
    private var toast = JYToast()
    
    var Password : String!
   

    override func viewDidLoad() {
        super.viewDidLoad()
     
      }

    override func viewDidAppear(_ animated: Bool)
    {
        NetworkManager.isReachable { _ in
            print("already connected internet")

            self.manager.session.configuration.timeoutIntervalForRequest = 120
            self.SplashData()

            let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
            self.Password = (UserDefaults.standard.value(forKey: "passwordd") as! String)
            print(self.Password)

            let userRole = lcDict["role"] as! String
            let userid = lcDict["user_id"] as! String
            self.setViewController(user_id: userid, Role: userRole)

        }
        NetworkManager.sharedInstance.reachability.whenReachable = { _ in
            print("now connected internet")
           
            self.manager.session.configuration.timeoutIntervalForRequest = 120
            self.SplashData()
            
            let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
            self.Password = UserDefaults.standard.value(forKey: "passwordd") as! String
            print(self.Password)
            
            let userRole = lcDict["role"] as! String
            let userid = lcDict["user_id"] as! String
            self.setViewController(user_id: userid, Role: userRole)
        }
        
        NetworkManager.isUnreachable{ _ in
            let alert = UIAlertController(title: "Qualus", message: "Please check your internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setViewController(user_id : String, Role : String)
    {
        if Role == "3"   // Auditor Login
        {
            ProjectVc.cProjectData.fetchProjectList(usernm: user_id, user_role: Role, arg: true, completion: {(sucess) -> Void in
                if sucess
                {
                    LocationData.cLocationData.fetchData(lcUID: user_id, lcRole: Role, arg: true, completion: { (success) -> Void
                        in
                        if success
                        {
                            userDataList.cUserData.getUserList(user_id: user_id)
                            ClassificationData.cDataClassification.fetchClassifictnData()
                            MapLocation.cMapLocationData.fetchMapLocation(UserId: user_id)
                        }else
                        {
                            print("false")
                        }
                        
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        
                    let ProjVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ProjectInfoVc") as! ProjectInfoVc
                        self.navigationController?.pushViewController(ProjVc, animated: false)
                    }
                    
                } else {
                    print("false")
                }
                
            })
        }
        
        if (Role == "6") || (Role == "1") || (Role == "8")  // 6 :management, 1: SuperAdmin, 8 :Admin
            
        {
            
            ProjectVc.cProjectData.fetchProjectList(usernm: user_id, user_role: Role, arg: true, completion: {(sucess) -> Void in
                if sucess
                {
                    LocationData.cLocationData.fetchData(lcUID: user_id, lcRole: Role, arg: true, completion: { (success) -> Void
                        in
                        if success
                        {
                            userDataList.cUserData.getUserList(user_id: user_id)
                            ClassificationData.cDataClassification.fetchClassifictnData()
                            MapLocation.cMapLocationData.fetchMapLocation(UserId: user_id)
                        }else
                        {
                            print("false")
                        }
                        
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        
                       
                        let vc = AppStoryboard.SuperAdmin.instance.instantiateViewController(withIdentifier: "SuperAdminHomePageVc") as! SuperAdminHomePageVc
                        
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                    
                } else {
                    print("false")
                }
                
            })

     
        }
        
        
        if Role == "7"   // CSR
            
        {
            LocationData.cLocationData.fetchData(lcUID: user_id, lcRole: Role, arg: true, completion: {(sucess) -> Void in
                if sucess{
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    
                    if self.Password != nil
                    {
                       let bool = "true"
                        UserDefaults.standard.set(bool, forKey: "checkVC")

                    let feedbackVc = FeedbackViewController.loadNib()
                self.navigationController?.pushViewController(feedbackVc, animated: true)

                    }else{
                        
                        let bool = "false"
                        UserDefaults.standard.set(bool, forKey: "checkVC")
                         let CSRVc = self.storyboard?.instantiateViewController(withIdentifier: "CSRViewController") as! CSRViewController
                         self.navigationController?.pushViewController(CSRVc, animated: false)
                        }
                      
                    }
                    
                } else {
                    
                    print("false")
                }
                
            })
            
        }
        
        if Role == "4"  // Employee login
        {
            ProjectVc.cProjectData.fetchProjectList(usernm: user_id, user_role: Role, arg: true, completion: {(sucess) -> Void in
                if sucess
                {
                    LocationData.cLocationData.fetchData(lcUID: user_id, lcRole: Role, arg: true, completion: { (success) -> Void
                        in
                        if success
                        {
                            userDataList.cUserData.getUserList(user_id: user_id)
                            ClassificationData.cDataClassification.fetchClassifictnData()
                            MapLocation.cMapLocationData.fetchMapLocation(UserId: user_id)
                        }else
                        {
                            print("false")
                        }
                        
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        
                        let EmpVc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "EmployeeHomePageVc") as! EmployeeHomePageVc
                        self.navigationController?.pushViewController(EmpVc, animated: false)
                    }
                    
                } else {
                    print("false")
                }
                
            })
        }
        
        if Role == "2"  // SuperVisor
        {
            ProjectVc.cProjectData.fetchProjectList(usernm: user_id, user_role: Role, arg: true, completion: {(sucess) -> Void in
                if sucess
                {
                    LocationData.cLocationData.fetchData(lcUID: user_id, lcRole: Role, arg: true, completion: { (success) -> Void
                        in
                        if success
                        {
                            userDataList.cUserData.getUserList(user_id: user_id)
                            ClassificationData.cDataClassification.fetchClassifictnData()
                            MapLocation.cMapLocationData.fetchMapLocation(UserId: user_id)
                        }else
                        {
                            print("false")
                        }

                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

                        let ProjVc = AppStoryboard.SuperVisor.instance.instantiateViewController(withIdentifier: "SuperVisorProjectListVc") as! SuperVisorProjectListVc
                        self.navigationController?.pushViewController(ProjVc, animated: false)
                    }

                } else {
                    print("false")
                }

            })
        }
        
        if Role == "9"  // Technician
        {
            ProjectVc.cProjectData.fetchProjectList(usernm: user_id, user_role: Role, arg: true, completion: {(sucess) -> Void in
                if sucess
                {
                    LocationData.cLocationData.fetchData(lcUID: user_id, lcRole: Role, arg: true, completion: { (success) -> Void
                        in
                        if success
                        {
                            userDataList.cUserData.getUserList(user_id: user_id)
                            ClassificationData.cDataClassification.fetchClassifictnData()
                            MapLocation.cMapLocationData.fetchMapLocation(UserId: user_id)
                        }else
                        {
                            print("false")
                        }
                        
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        
                        let ProjVc = AppStoryboard.SuperVisor.instance.instantiateViewController(withIdentifier: "TechnicianHomePageVc") as! TechnicianHomePageVc
                        self.navigationController?.pushViewController(ProjVc, animated: false)
                    }
                    
                } else {
                    print("false")
                }
                
            })
        }
        if Role == "5" // helpdesk
        {
          let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "LoginPageVc") as! LoginPageVc
            
           self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
    
    func setComId(Com_id : String)
    {
        self.ComId = Com_id
    }
    
    func SplashData()
    {
        let SplashUrl = "http://kanishkaconsultancy.com/Qualus-FM-Android/get_company_data.php"
        let Splashparam = ["com_id" : "36"]
       
        manager.request(SplashUrl, method: .post, parameters: Splashparam).responseJSON { (dataResult) in
           
            
            switch dataResult.result
            {
            case .success(let data):
                    let data = dataResult.result.value
                    let dict  = data as! [AnyObject]
                    
                    self.ImgPath = dict[0]["com_logo"] as! String
                    let name = dict[0]["com_name"] as! String
                  
                    self.img()

                break
                
            case .failure(let error):
                if error._code == NSURLErrorTimedOut
                {
                  self.toast.isShow("Network error")
                }
                
                if error._code == errSecNetworkFailure
                {
                    self.toast.isShow("Network error")
                }
                break
            }
            
        }
        
    }

    func img()
    {
        let strImg = urlpath + self.ImgPath
        Alamofire.request(strImg, method: .get).responseImage { (resp) in
           
            if let img = resp.result.value{
                
                DispatchQueue.main.async {
                    self.MyImg.image = img
                }
            }
            
            
        }
    }

}
