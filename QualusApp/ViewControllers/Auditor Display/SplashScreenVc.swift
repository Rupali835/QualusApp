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
    private var toast : JYToast!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isConnectedToNetwork()
        {
            manager.session.configuration.timeoutIntervalForRequest = 120
            toast = JYToast()
            self.SplashData()
            
            let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        }else{
            self.toast.isShow("No internet connection")
        }
        
    
      }

    func setViewController(user_id : String, Role : String)
    {
        
        if Role == "3"
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
                        
                        let ProjVc = self.storyboard?.instantiateViewController(withIdentifier: "ProjectInfoVc") as! ProjectInfoVc
                        self.navigationController?.pushViewController(ProjVc, animated: true)
                    }
                    
                } else {
                    print("false")
                }
                
            })
        }
        
        if (Role == "6") || (Role == "1") || (Role == "8")
            
        {
            LocationData.cLocationData.fetchData(lcUID: user_id, lcRole: Role, arg: true, completion: {(sucess) -> Void in
                if sucess{
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        
                        let managevc = ManagementViewController.init(nibName: "ManagementViewController", bundle: nil)
                        self.navigationController?.pushViewController(managevc, animated: true)
                    }
               
                } else {
                    
                    print("false")
                }
                
            })
         
        }
        
        
        if Role == "7"
            
        {
            LocationData.cLocationData.fetchData(lcUID: user_id, lcRole: Role, arg: true, completion: {(sucess) -> Void in
                if sucess{
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                      
                    let CSRVc = self.storyboard?.instantiateViewController(withIdentifier: "CSRViewController") as! CSRViewController
                        UserDefaults.standard.set(passwd.self, forKey: "pwd")
                    self.navigationController?.pushViewController(CSRVc, animated: true)
                      
                    }
                    
                } else {
                    
                    print("false")
                }
                
            })
            
        }
        
        if Role == "4"
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
                        
                        let ProjVc = self.storyboard?.instantiateViewController(withIdentifier: "MaverickTicketViewVc") as! MaverickTicketViewVc
                        self.navigationController?.pushViewController(ProjVc, animated: true)
                    }
                    
                } else {
                    print("false")
                }
                
            })
        }
        
//        userDataList.cUserData.getUserList(user_id: user_id)
//        ClassificationData.cDataClassification.fetchClassifictnData()
//        MapLocation.cMapLocationData.fetchMapLocation(UserId: user_id)
        
        
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
