//
//  TechnicianHomePageVc.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 4/1/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class TechnicianHomePageVc: UIViewController {

    @IBOutlet weak var lblusernm: UILabel!
    @IBOutlet weak var lblCloseTicCount: UILabel!
    @IBOutlet weak var lblOpenTicCount: UILabel!
    
    var UserId          : String = ""
    var UserRole        : String = ""
    var UserNm          : String = ""
    var User_Logein     : String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        navigationBarButton()
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        self.UserRole    = lcDict["role"] as! String
        self.UserNm      = lcDict["full_name"] as! String
        self.UserId      = lcDict["user_id"] as! String
        self.User_Logein = lcDict["user_logged_in"] as! String
       setUsername(name: self.UserNm, role: self.UserRole)
    }
   
    func setUsername(name: String, role: String)
    {
        if role == "9"
        {
            self.lblusernm.text = "Welcome  \(name) (Technician)"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        getCount()
    }
    
    func getCount()
    {
        let Api = constant.BaseUrl + constant.technicianCount
        let param = ["user_id" : self.UserId]
        Alamofire.request(Api, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            switch resp.result
            {
            case .success(_):
                let json = resp.result.value as! NSDictionary
                self.lblOpenTicCount.text = (json["my_closed_proactive_tickets"] as! String)
                self.lblCloseTicCount.text = (json["my_open_proactive_tickets"] as! String)
                break
                
            case .failure(_):
                break
            }
        }
    }
    
    func navigationBarButton()
    {
        let img1 = UIImage(named: "power-signal")
        let rightbutton1 = UIButton(type: .system)
        rightbutton1.setImage(img1, for: .normal)
        rightbutton1.frame = CGRect(x: 0, y: 0, width: 40, height: 20)
        rightbutton1.addTarget(self, action: #selector(logout), for: .touchUpInside)
        let buttonitem1 = UIBarButtonItem(customView: rightbutton1)
        navigationItem.rightBarButtonItems = [buttonitem1]
    }
    
    @objc func logout()
    {
        let alert = UIAlertController(title: "Qualus", message: "Are you sure to Logout", preferredStyle: .alert)
        let Yesaction = UIAlertAction(title: "Yes", style: .default, handler: { (okaction) in
            self.UserLogout()
        })
        let NOAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(Yesaction)
        alert.addAction(NOAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func UserLogout()
    {
        let url = "http://kanishkaconsultancy.com/Qualus-FM-Android/logout.php"
        let para = ["user_id": self.UserId]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: URLEncoding.default, headers: nil).responseString { (resp) in
            
            UserDefaults.standard.removeObject(forKey: "UserData")
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginPageVc") as! LoginPageVc
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let navigationController = appDelegate.window?.rootViewController as! UINavigationController
            navigationController.setViewControllers([loginVC], animated: true)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnSynk_onClick(_ sender: Any)
    {
        
        NetworkManager.isReachable { _ in
            print("already connected internet")
            self.SynkData()
            
        }
        NetworkManager.sharedInstance.reachability.whenReachable = { _ in
            print("now connected internet")
            self.SynkData()
        }
        
        NetworkManager.sharedInstance.reachability.whenUnreachable = { _ in
            
            let alert = UIAlertController(title: "Qualus", message: "Please check your internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        NetworkManager.isUnreachable{ _ in
            let alert = UIAlertController(title: "Qualus", message: "Please check your internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnOpenProactiveTik_onClick(_ sender: Any)
    {
        if lblOpenTicCount.text == "0"
        {
            toast(msg: "No any open maverick tickets")
        }else
        {
            callTicketView(StatusParam: "2")
        }
    }
    
    @IBAction func btnCloseProactivrTik_onClick(_ sender: Any)
    {
        if lblCloseTicCount.text == "0"
        {
            toast(msg: "No any closed maverick tickets")
        }else
        {
            callTicketView(StatusParam: "1")
        }
    }
    
    func callTicketView(StatusParam : String)
    {
        let vc = AppStoryboard.SuperVisor.instance.instantiateViewController(withIdentifier: "TechnianProactiveTicketVc") as! TechnianProactiveTicketVc
        vc.ticketStatus = Int(StatusParam)
        vc.getTechnicianTic(id: self.UserId, role: self.UserRole, status: StatusParam)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func SynkData()
    {
        
        OperationQueue.main.addOperation {
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setBackgroundColor(UIColor.gray)
            SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
            SVProgressHUD.show(withStatus: "Fetching data")
        }
        
        ProjectVc.cProjectData.fetchProjectList(usernm: UserId, user_role: UserRole, arg: true, completion: {(sucess) -> Void in
            if sucess
            {
                LocationData.cLocationData.fetchData(lcUID: self.UserId, lcRole: self.UserRole, arg: true, completion: { (success) -> Void
                    in
                    if success
                    {
                        userDataList.cUserData.getUserList(user_id: self.UserId)
                        ClassificationData.cDataClassification.fetchClassifictnData()
                        MapLocation.cMapLocationData.fetchMapLocation(UserId: self.UserId)
                    }else
                    {
                        print("false")
                    }
                    
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                {
                    OperationQueue.main.addOperation {
                        
                        SVProgressHUD.dismiss()
                    }
                    //self.toast.isShow("Data sync successfully")
                    
              
                    self.toast(msg: "Data sync successfully")
                }
                
            } else {
                print("false")
            }
            
        })
    }
    
    func toast(msg: String){
        self.view.showToast(msg, position: .bottom, popTime: 3, dismissOnTap: true)
    }

}
