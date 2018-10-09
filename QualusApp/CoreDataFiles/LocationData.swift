//
//  LocationData.swift
//  QualusApp
//
//  Created by user on 25/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import Alamofire

class LocationData: NSObject
{
    var User_id : String = ""
    var UsrRole : String = ""
    var LocationArr = [AnyObject]()
    var BranchArr = [AnyObject]()
    var BuuildingArr = [AnyObject]()
    
    static let cLocationData = LocationData()
    
    func fetchData(lcUID : String, lcRole : String, arg: Bool, completion: @escaping (Bool)->())

    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        
        let loctUrl = "http://kanishkaconsultancy.com/Qualus-FM-Android/fetchAllLocations.php"
        let lctParam = ["u_Id" : lcUID,
                        "u_type" : lcRole]
        
        
       
        Alamofire.request(loctUrl, method: .post, parameters: lctParam).responseJSON { (fetchData) in
            
    //print(fetchData)
            
            if let JSON = fetchData.result.value
            {
                let lcDict = JSON as! [String: AnyObject]
                self.LocationArr = lcDict["locations"] as! [AnyObject]
                
                self.deleteLocationData()
                
                for lcData in self.LocationArr
                {
                    
                    let locationEntity = FetchLocation(context: context)
                    locationEntity.l_id = lcData["l_id"] as? String
                    locationEntity.l_barcode = lcData["l_barcode"] as? String
                    locationEntity.p_id = lcData["p_id"] as? String
                    locationEntity.branch_id = lcData["branch_id"] as? String
                    locationEntity.b_id = lcData["b_id"] as? String
                    locationEntity.l_wing = lcData["l_wing"] as? String
                    locationEntity.l_floor = lcData["l_floor"] as? String
                    locationEntity.l_room = lcData["l_room"] as? String
                    locationEntity.l_space = lcData["l_space"] as? String
                    locationEntity.l_class_id = lcData["l_class_id"] as? String
                    locationEntity.l_latitude = lcData["l_latitude"] as? String
                    locationEntity.l_longitude = lcData["l_longitude"] as? String
                    
                    
                    appDel.saveContext()
             //      print("Location data save")
                    
                }
                
                self.BranchArr = lcDict["branches"] as! [AnyObject]
                self.deleteBranchData()
                for lcDataa in self.BranchArr
                {
                    
                    let branchEntity = FetchBranches(context: context)
                    branchEntity.pb_id = lcDataa["pb_id"] as? String
                    branchEntity.pb_name = lcDataa["pb_name"] as? String
                    branchEntity.p_id = lcDataa["p_id"] as? String
                    appDel.saveContext()
                //    print("Branch data save")
                    
                }
                
                self.BuuildingArr = lcDict["buildings"] as! [AnyObject]
                
                self.deleteBuildingData()
                
                for lcDataaa in self.BuuildingArr
                {
                    
                    let buildingEntity = FetchBuilding(context: context)
                    buildingEntity.bb_id = lcDataaa["bb_id"] as? String
                    buildingEntity.branch_id = lcDataaa["branch_id"] as? String
                    buildingEntity.b_name = lcDataaa["b_name"] as? String
                    buildingEntity.p_id = lcDataaa["p_id"] as? String
                    appDel.saveContext()
                //    print("Building data save")
                }
            }
            completion(arg)
        }
        
    }
    
    func fetchOfflineLocation() -> [AnyObject]?
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        do{
            let DataArr = try context.fetch(FetchLocation.fetchRequest()) as [AnyObject]
            
            for (index, value) in DataArr.enumerated()
            {
                let locationEnt = DataArr[index] as! FetchLocation
                
                print("L_name", locationEnt.l_id!)
            }
            
            return DataArr
            
        }catch{
              }
       
        return nil
    }
    
    func fetchOfflineBranches() -> [AnyObject]?
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let contx = appDel.persistentContainer.viewContext
        do{
            let DataArr = try contx.fetch(FetchBranches.fetchRequest()) as [AnyObject]

            return DataArr
        }catch{
            
        }
        
        return nil
    }
    
    
    func fetchOfflineBuilding() -> [AnyObject]?
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let contx = appDel.persistentContainer.viewContext
        do{
            let DataArr = try contx.fetch(FetchBuilding.fetchRequest()) as [AnyObject]
//            for (index, value) in DataArr.enumerated()
//            {
//                let branchEnt = DataArr[index] as! FetchBuilding
//                print("Branch_id", branchEnt.branch_id!)
//            }
            return DataArr
        }catch{
            
        }
        
        return nil
    }
    
    func deleteLocationData()
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let contx = appDel.persistentContainer.viewContext
        do{
            let DataArr = try contx.fetch(FetchLocation.fetchRequest()) as [AnyObject]
       //     print("Count=\(DataArr.count) \(DataArr)")
          
            
            for (index, _) in DataArr.enumerated()
            {
                let ProjectsEntity = DataArr[index] as! FetchLocation
                contx.delete(ProjectsEntity)
            }
            
        }catch{
            
        }
    }
    
    func deleteBranchData()
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let contx = appDel.persistentContainer.viewContext
        do{
            let DataArr = try contx.fetch(FetchBranches.fetchRequest()) as [AnyObject]
           // print("Count=\(DataArr.count) \(DataArr)")
            
            for (index, _) in DataArr.enumerated()
            {
                let ProjectsEntity = DataArr[index] as! FetchBranches
                contx.delete(ProjectsEntity)
            }
        }catch{
            
        }
    }
    
    func deleteBuildingData()
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let contx = appDel.persistentContainer.viewContext
        do{
            let DataArr = try contx.fetch(FetchBuilding.fetchRequest()) as [AnyObject]
           // print("Count=\(DataArr.count) \(DataArr)")
            
            for (index, _) in DataArr.enumerated()
            {
                let ProjectsEntity = DataArr[index] as! FetchBuilding
                contx.delete(ProjectsEntity)
            }
        }catch{
            
        }
    }

}

