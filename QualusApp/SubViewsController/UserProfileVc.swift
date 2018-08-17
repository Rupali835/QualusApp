//
//  UserProfileVc.swift
//  QualusApp
//
//  Created by user on 22/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class UserProfileVc: UIViewController {

    @IBOutlet weak var lblUserRole: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    var usernm : String = ""
    var roleUser : String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        self.roleUser = lcDict["role"] as! String
        self.usernm = lcDict["full_name"] as! String
     
        self.lblUserName.text = usernm
        
        if self.roleUser == "3"
        {
            self.lblUserRole.text = "Auditor"
        }
        if self.roleUser == "4"
        {
            self.lblUserRole.text = "Emplolyee"
        }
        if self.roleUser == "6"
        {
            self.lblUserRole.text = "Management"
        }
        if self.roleUser == "7"
        {
            self.lblUserRole.text = "CSR"
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func setdata(Username: String, Userrole: String)
//    {
//        self.usernm = Username
//        self.roleUser = Userrole
//        
//        
//      
//        
//    }
    
    @IBAction func btnOk_click(_ sender: Any)
    {
        self.view.removeFromSuperview()
    }
    
    

}
