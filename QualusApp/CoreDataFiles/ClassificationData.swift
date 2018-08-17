//
//  ClassificationData.swift
//  QualusApp
//
//  Created by user on 07/08/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import Alamofire

class ClassificationData : NSObject
{
    var ClassificationArr = [AnyObject]()
    var ClassQueDataArr = [AnyObject]()
    
    static let cDataClassification = ClassificationData()
    
    func fetchClassifictnData()
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext

        let clsficationUrl = "http://kanishkagroups.com/Qualus/index.php/AndroidV2/Login/get_active_classifications"
        Alamofire.request(clsficationUrl, method: .get, parameters: nil).responseJSON { (resp) in
            print(resp)
            
            if let JSON = resp.result.value
            {
                let lcData = JSON as! [String: AnyObject]
                self.ClassificationArr = lcData["class_data"] as! [AnyObject]
                
                self.deleteClsification()
                
                for lcDict in self.ClassificationArr
                {
                    let clsEntity = FetchClassification(context: context)
                    clsEntity.class_id = lcDict["class_id"] as? String
                    clsEntity.class_name = lcDict["class_name"] as? String
                    clsEntity.clas_desc = lcDict["clas_desc"] as? String
                    clsEntity.active = lcDict["active"] as? String
                    clsEntity.created_time = lcDict["created_time"] as? String
                    clsEntity.modified_time = lcDict["modified_time"] as? String
                    clsEntity.active_time = lcDict["active_time"] as? String
                    clsEntity.inactive_time = lcDict["inactive_time"] as? String
                }
                
                self.ClassQueDataArr = lcData["class_que_data"] as! [AnyObject]
                
                self.deleteClsQueData()
                for lcDict in self.ClassQueDataArr
                {
                    let clsQentity = FetchQueData(context: context)
                    clsQentity.cq_id = lcDict["cq_id"] as? String
                    clsQentity.cq_name = lcDict["cq_name"] as? String
                    clsQentity.class_id = lcDict["class_id"] as? String
                }
            }
            
        }
        print("Save classification data")
    }
    
    func fetchOfflineClassification() -> [AnyObject]?
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        do{
            
            let DataArr = try context.fetch(FetchClassification.fetchRequest()) as [AnyObject]
            
            return DataArr
            
        }catch{
        }
        
        return nil
    }
    
    func fetchOfflineClsQueData() -> [AnyObject]?
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        do{
            
            let DataArr = try context.fetch(FetchQueData.fetchRequest()) as [AnyObject]
            
            return DataArr
            
        }catch{
        }
        
        return nil
    }
   
    func deleteClsification()
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let contx = appDel.persistentContainer.viewContext
        do{
            let DataArr = try contx.fetch(FetchClassification.fetchRequest()) as [AnyObject]
           
            for (index, _) in DataArr.enumerated()
            {
                let ProjectsEntity = DataArr[index] as! FetchClassification
                contx.delete(ProjectsEntity)
            }
        }catch{
            
        }
    }
    
    func deleteClsQueData()
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let contx = appDel.persistentContainer.viewContext
        do{
            let DataArr = try contx.fetch(FetchQueData.fetchRequest()) as [AnyObject]
            
            for (index, _) in DataArr.enumerated()
            {
                let ProjectsEntity = DataArr[index] as! FetchQueData
                contx.delete(ProjectsEntity)
            }
        }catch{
            
        }
    }
    
}

