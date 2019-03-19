//
//  ProjectsVc.swift
//  QualusApp
//
//  Created by user on 28/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import Alamofire

class ProjectVc : NSObject
{
   
    var cUserProfile : UserProfileVc!
    var UserId : String = ""
    var UserRole : String = ""
    var UserNm : String = ""
    var mainArr: [AnyObject]! = [AnyObject]()
    var DataArr = NSArray()
    
    static let cProjectData = ProjectVc()

    func fetchProjectList(usernm : String, user_role : String, arg: Bool, completion: @escaping (Bool)->())
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
    
        let fetchUrl = "http://kanishkaconsultancy.com/Qualus-FM-Android/fetchProjects.php"
    
        let fetchParam = [ "u_Id" : usernm,
                        "u_type" : user_role ]

        Alamofire.request(fetchUrl, method: .post, parameters: fetchParam).responseJSON { (fetchData) in
        //print(fetchData)
            
        if let JSON = fetchData.result.value
        {
            self.mainArr = JSON as! [AnyObject]
    
            self.DeleteFetchProjects()

            for lcDict in self.mainArr
            {
                

    let ProjectsEntity = FeatchProjects(context: context)
    
    ProjectsEntity.p_id     = lcDict["p_id"] as? String
    ProjectsEntity.p_name   = lcDict["p_name"] as? String
    ProjectsEntity.p_type   = lcDict["p_type"] as? String
    ProjectsEntity.com_id   = lcDict["com_id"] as? String
    ProjectsEntity.p_address = lcDict["p_address"] as? String
    ProjectsEntity.p_email  = lcDict["p_email"] as? String
    ProjectsEntity.p_city   = lcDict["p_city"] as? String
    ProjectsEntity.p_subcity    = lcDict["p_subcity"] as? String
    ProjectsEntity.p_branch =   lcDict["p_branch"] as? String
    ProjectsEntity.p_buildings   = lcDict["p_buildings"] as? String
    ProjectsEntity.p_barcode    = lcDict["p_barcode"] as? String
    ProjectsEntity.p_camera    = lcDict["p_camera"] as? String
    ProjectsEntity.p_contact_number    = lcDict["p_contact_number"] as? String
    ProjectsEntity.p_img_url    = lcDict["p_img_url"] as? String
    ProjectsEntity.created_by    = lcDict["created_by"] as? String
    ProjectsEntity.created_time    = lcDict["created_time"] as? String
    ProjectsEntity.modified_by    = lcDict["modified_by"] as? String
    ProjectsEntity.modified_time   = lcDict["modified_time"] as? String
    ProjectsEntity.active          = lcDict["active"] as? String
    ProjectsEntity.p_active_by    = lcDict["p_active_by"] as? String
    ProjectsEntity.p_active_time    = lcDict["p_active_time"] as? String
    ProjectsEntity.p_inactive_by    = lcDict["p_inactive_by"] as? String
    ProjectsEntity.p_inactive_time    = lcDict["p_inactive_time"] as? String
    
    appDel.saveContext()
      
   
    }
      completion(arg)
            
    }
   }
    }
    
    func FeatchProjectsDataOffline() -> [AnyObject]?
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        do{
            let DataArr = try context.fetch(FeatchProjects.fetchRequest()) as [FeatchProjects]
            
            return DataArr
        }
        catch{
            
        }
        return nil
    }
    
    func DeleteFetchProjects()
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        
        do{
            let DataArr = try context.fetch(FeatchProjects.fetchRequest()) as [FeatchProjects]
            
        //    print("Count=\(DataArr.count) \(DataArr)")
            
            for (index, _) in DataArr.enumerated()
            {
                let ProjectsEntity = DataArr[index] as! FeatchProjects
                context.delete(ProjectsEntity)
            }
            
        }catch{
            
        }
    }
    
    
    
}
