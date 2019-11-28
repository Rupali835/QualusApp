//
//  MapLocations.swift
//  QualusApp
//
//  Created by user on 03/08/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import Alamofire

class MapLocation : NSObject
{
    var MapLocationArr = [AnyObject]()
    static let cMapLocationData = MapLocation()
    
    func fetchMapLocation(UserId : String)
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        
        let Url = "https://qualus.ksoftpl.com/index.php/AndroidV2/Login/get_mapped_locations"
        let param : [String : Any] = ["user_id" : UserId]
        
        Alamofire.request(Url, method: .post, parameters: param).responseJSON { (resp) in
       //     print(resp)
           
            if let JSON = resp.result.value
            {
                self.MapLocationArr = JSON as! [AnyObject]
                self.deleteMapLocationData()
                
                for lcdict in self.MapLocationArr
                {
                    let mapLocationEnt = FetchMapLocation(context: context)
                    mapLocationEnt.branch_id = lcdict["branch_id"] as? String
                    mapLocationEnt.l_id = lcdict["l_id"] as? String
                    mapLocationEnt.lm_id = lcdict["lm_id"] as? String
                    mapLocationEnt.u_id = lcdict["u_id"] as? String
                    mapLocationEnt.p_id = lcdict["p_id"] as? String
                    appDel.saveContext()
              //      print("Save Map Location")
                }
            }
        }
    }
    
    func fetchOfflineMapLocation() -> [AnyObject]?
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        do{
            let DataArr = try context.fetch(FetchMapLocation.fetchRequest()) as [FetchMapLocation]
            
            return DataArr
            
        }catch{
        }
        return nil
    }
    
    
    func deleteMapLocationData()
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let contx = appDel.persistentContainer.viewContext
        do{
            let DataArr = try contx.fetch(FetchMapLocation.fetchRequest()) as [FetchMapLocation]
      //      print("Count=\(DataArr.count) \(DataArr)")
            
            for (index, _) in DataArr.enumerated()
            {
                let MapLocationEntity = DataArr[index] as! FetchMapLocation
                contx.delete(MapLocationEntity)
            }
        }catch{
            
        }
    }
}
