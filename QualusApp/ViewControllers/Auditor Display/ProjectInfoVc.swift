//
//  ProjectInfoVc.swift
//  QualusApp
//
//  Created by user on 17/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import AVScanner

class ProjectInfoVc: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet weak var projectCollView: UICollectionView!
    @IBOutlet weak var ticketView: UIView!
    var cUserProfile : UserProfileVc!
    var UserId : String = ""
    var UserRole : String = ""
    var UserNm : String = ""
    var mainArr: [AnyObject]! = [AnyObject]()
    var DataArr = NSArray()
    var projectDataArr = [AnyObject]()
    var cameraFlag : String = ""
    var showVc = Bool(true)
    var user_active: String = ""
    var User_Logein : String = ""
    var P_id: String = ""
    var m_bTicketView = Bool(true)
    var projEnt : FeatchProjects!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ticketView.isHidden = self.m_bTicketView
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        self.UserRole = lcDict["role"] as! String
        print("Role", self.UserRole)
        self.UserNm = lcDict["full_name"] as! String
        self.UserId = lcDict["user_id"] as! String
        self.User_Logein = lcDict["user_logged_in"] as! String
        self.designCell(cView: ticketView)
        projectCollView.delegate = self
        projectCollView.dataSource = self
        projectDataArr = ProjectVc.cProjectData.FeatchProjectsDataOffline()!
        print("Projects",projectDataArr)
        self.projectCollView.reloadData()

    }
    
    
    func designCell(cView : UIView)
    {
        cView.layer.masksToBounds = false
        cView.layer.shadowColor = UIColor.black.cgColor
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cView.layer.shadowRadius = 1
   }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if self.projectDataArr.count > 0
        {
            return self.projectDataArr.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = projectCollView.dequeueReusableCell(withReuseIdentifier: "ProjectInfoCell", for: indexPath) as! ProjectInfoCell
        projEnt = projectDataArr[indexPath.row] as! FeatchProjects
        cell.lblProjectName.text = projEnt.p_name
        
        let cFlag = projEnt.p_camera
        
        if cFlag == "1"
        {
            cell.lblScannerFlag.text = "With Scanner"
            cell.lblScannerFlag.textColor = UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
            
        }else{
            cell.lblScannerFlag.text = "Without Scanner"
            cell.lblScannerFlag.textColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
        }
        self.designCell(cView: cell.backView)
        
        return cell

        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
       // let lcDict = projectDataArr[indexPath.row]
        
        //let abc = lcDict["p_id"]
        projEnt = projectDataArr[indexPath.row] as! FeatchProjects
        let P_id = projEnt.p_id
        
        let cFlag = projEnt.p_camera
        
        if cFlag == "0"
        {
            let cBarcode = storyboard?.instantiateViewController(withIdentifier: "BarCodeVc") as! BarCodeVc
            cBarcode.showvc = showVc
            cBarcode.pId = P_id!
            self.navigationController?.pushViewController(cBarcode, animated: true)
            
        }else
        {
            let cScanner = storyboard?.instantiateViewController(withIdentifier: "ScannerVc") as! ScannerVc
            cScanner.GetData(pid: P_id!, bShowVC: showVc)
            self.navigationController?.pushViewController(cScanner, animated: true)
        }
        
    }
    
    
    @IBAction func btnUserProfile_Click(_ sender: Any)
    {
        self.cUserProfile.view.frame =  self.view.bounds
        self.view.addSubview(self.cUserProfile.view)
        self.cUserProfile.view.clipsToBounds = true
    }
    
    override func awakeFromNib()
    {
        self.cUserProfile = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileVc") as! UserProfileVc
    }
    
    @IBAction func btnLogout_Click(_ sender: Any)
    {
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure to logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("Ok pressed")
            self.logout()
        }
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func logout()
    {
        let logouturl = "http://kanishkaconsultancy.com/Qualus-FM-Android/logout.php"
        let logParam = ["user_id" : self.UserId]
        Alamofire.request(logouturl, method: .post, parameters: logParam).responseString { (logDATA) in
            print(logDATA)
            
            if self.User_Logein == "0"
            {
                UserDefaults.standard.removeObject(forKey: "UserData")
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginPageVc") as! LoginPageVc
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let navigationController = appDelegate.window?.rootViewController as! UINavigationController
                navigationController.setViewControllers([loginVC], animated: true)
                self.navigationController?.popViewController(animated: true)
                
                
            }else{
                
            }
        }
       
    }
    
    @IBAction func btnTicket_Click(_ sender: Any)
    {
        self.m_bTicketView = !self.m_bTicketView
        self.ticketView.isHidden = self.m_bTicketView
    }
    
    @IBAction func btnSubmitedChecklist_click(_ sender: Any)
    {
        self.btnTicket_Click(sender)
        
        let sumbitChecklistVc = storyboard?.instantiateViewController(withIdentifier: "SubmittedChecklistVc") as! SubmittedChecklistVc
        self.navigationController?.pushViewController(sumbitChecklistVc, animated: true)
    }
    
    @IBAction func btnmaverconstantt_click(_ sender: Any)
    {
        self.btnTicket_Click(sender)
        let ticketVc = storyboard?.instantiateViewController(withIdentifier: "MaverickTicketViewVc") as! MaverickTicketViewVc
        ticketVc.ProjArr = mainArr
        self.navigationController?.pushViewController(ticketVc, animated: true)
    }
    
    @IBAction func btnSync_Click(_ sender: Any)
    {
        self.btnTicket_Click(sender)
        
       
        
    }
}
