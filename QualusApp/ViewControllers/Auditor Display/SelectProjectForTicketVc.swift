//
//  SelectProjectForTicketVc.swift
//  QualusApp
//
//  Created by user on 29/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class SelectProjectForTicketVc: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tblProject: UITableView!
    var cProject : ProjectInfoVc!
    var cShowVc = Bool(false)
    var ProjNmArr = [AnyObject]()
    var P_Name : String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tblProject.delegate = self
        tblProject.dataSource = self
        tblProject.registerCellNib(LocationCell.self)
        tblProject.separatorStyle = .none
      
        
        for (index, value) in ProjNmArr.enumerated()
        {
            let locationEnt = ProjNmArr[index] as! FeatchProjects
            self.P_Name = locationEnt.p_name!
        }
        
        tblProject.reloadData()
        
    }
    
    
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        return UIColor(red:red, green: green, blue: blue, alpha: 0.7)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        ProjNmArr = ProjectVc.cProjectData.FeatchProjectsDataOffline()!
        
        if ProjNmArr.count > 0
        {
            return ProjNmArr.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblProject.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        ProjNmArr = ProjectVc.cProjectData.FeatchProjectsDataOffline()!
        let projEnt = ProjNmArr[indexPath.row] as! FeatchProjects
        let Pname = projEnt.p_name
        cell.lblLocationNm.text = Pname
        let firstName = Pname?.first
        cell.lblFirstLetter.text = String(firstName!)
        cell.lblFirstLetter.backgroundColor = getRandomColor()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        ProjNmArr = ProjectVc.cProjectData.FeatchProjectsDataOffline()!
        
        let projEnt = ProjNmArr[indexPath.row] as! FeatchProjects
        let pId = projEnt.p_id
        let CameraFlag = projEnt.p_camera
   //     print(CameraFlag)
        
        if CameraFlag == "0"  // no camera
        {
            let cBarcode = storyboard?.instantiateViewController(withIdentifier: "BarCodeVc") as! BarCodeVc
            cBarcode.showvc = cShowVc
            cBarcode.pId = pId!
            self.present(cBarcode, animated:true, completion: nil)

            
        }else
        {
            let cScanner = storyboard?.instantiateViewController(withIdentifier: "ScannerVc") as! ScannerVc
            cScanner.showvc = cShowVc
            cScanner.PId = pId!
            present(cScanner, animated: true, completion: nil)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}
