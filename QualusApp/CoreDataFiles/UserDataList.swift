//
//  UserDataList.swift
//  QualusApp
//
//  Created by user on 25/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import Alamofire

class userDataList : NSObject
{
     var mainArr: [AnyObject]! = [AnyObject]()
    
     static let cUserData = userDataList()
    
    func getUserList(user_id: String)
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        
        let userUrl = "http://kanishkagroups.com/Qualus/index.php/AndroidV2/Login/get_assigned_project_wise_user"
        let param = ["user_id" : user_id]
        Alamofire.request(userUrl, method: .post, parameters: param).responseJSON { (userData) in
            
            switch userData.result
            {
            case .success(_):
                
              if let Json = userData.result.value as? [AnyObject]
              {
                self.mainArr = Json as! [AnyObject]
                
                self.deleteUserData()
                
                for lcdata in self.mainArr
                {
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

                break
                
            case .failure(_):
                break
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
        //    print("Count=\(DataArr.count) \(DataArr)")
            
            for (index, _) in DataArr.enumerated()
            {
                let UserEntity = DataArr[index] as! FetchUserList
                contx.delete(UserEntity)
            }
        }catch{
            
        }
    }
}
