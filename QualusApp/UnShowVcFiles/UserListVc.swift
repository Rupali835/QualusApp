//
//  UserListVc.swift
//  QualusApp
//
//  Created by user on 21/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class UserListVc: UIViewController {

    var mainArr: [AnyObject]! = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchOfflineUserList()
        getUserList()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserList()
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        
        let userUrl = "https://qualus.ksoftpl.com/index.php/AndroidV2/Login/get_assigned_project_wise_user"
        let param = ["user_id" : "150"]
        Alamofire.request(userUrl, method: .post, parameters: param).responseJSON { (userData) in
          
            let Json = userData.result.value
            
            self.mainArr = Json as! [AnyObject]
            
            for lcdata in self.mainArr
            {
                self.deleteUserData()
                let userEntity = FetchUserList(context: context)
                userEntity.user_id = lcdata["user_id"] as? String
                userEntity.full_name = lcdata["full_name"] as? String
                userEntity.com_id = lcdata["com_id"] as? String
                userEntity.u_emp_id = lcdata["u_emp_id"] as? String
                userEntity.user_email = lcdata["user_email"] as? String
                userEntity.role = lcdata["role"] as? String
                userEntity.up_id = lcdata["up_id"] as? String
                appDel.saveContext()
            }
            
            
        }
    }

    func fetchOfflineUserList()
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let contx = appDel.persistentContainer.viewContext
        do{
            let DataArr = try contx.fetch(FetchUserList.fetchRequest()) as [FetchUserList]
            for (index, value) in DataArr.enumerated()
            {
                let userEnt = DataArr[index] as! FetchUserList
           //     print("user_full_name", userEnt.full_name!)
            }
            
        }catch{
            
        }
    }
    
    func deleteUserData()
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let contx = appDel.persistentContainer.viewContext
        do{
            let DataArr = try contx.fetch(FetchUserList.fetchRequest()) as [FetchUserList]
       //     print("Count=\(DataArr.count) \(DataArr)")
            
            for (index, _) in DataArr.enumerated()
            {
                let UserEntity = DataArr[index] as! FetchUserList
                contx.delete(UserEntity)
            }
        }catch{
            
        }
    }
}
