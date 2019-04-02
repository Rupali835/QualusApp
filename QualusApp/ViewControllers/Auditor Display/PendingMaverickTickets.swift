//
//  PendingMaverickTickets.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 3/8/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

struct MaverickTicket: Decodable
{
    var code : Int?
    var getMaverickTickets : [getMaverickTickets]
}

struct getMaverickTickets : Decodable
{
    var mt_id : String!
    var com_id : String!
    var p_id : String!
    var pb_id : String!
    var l_id : String!
    var l_barcode : String!
    var user_id : String!
    var fc_id : String!
    var a_id : String!
    var user_role : String!
    var mt_subject : String!
    var mt_photo : [String]!
    var mt_remark : String!
    var mt_action_plan : String!
    var mt_action_plan_date : String!
    var status : String!
    var created_time : String!
    var assigned_to : String!
    var assigned_time : String!
    var sv_accepted_by : String!
    var sv_accepted_time : String!
    var assignment_data : String!
    var closed_by : String!
    var closed_time : String!
    var t_close_action : String!
    var t_close_remark : String!
    var p_name : String!
    var pb_name : String!
    var l_space : String!
    var added_by : String!
}


class PendingMaverickTickets: UIViewController
{
    @IBOutlet weak var tblPendingTickets: UITableView!
  
    var m_cTickets : [getMaverickTickets] = []
    var ticketStatus : Int!
    var LocationDaraArr = [FetchLocation]()

    var locationName = String()
    var context = AppDelegate().persistentContainer.viewContext


    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    self.tblPendingTickets.registerCellNib(PendingMaverickTicketCell.self)

        tblPendingTickets.delegate = self
        tblPendingTickets.dataSource = self
        tblPendingTickets.separatorStyle = .none
        
        let Lresquest = NSFetchRequest<FetchLocation>(entityName: "FetchLocation")
        let Lresponse = try! context.fetch(Lresquest)
        LocationDaraArr = Lresponse
        
    }
    
    func getLid(l_id : String)
    {
        for item2 in LocationDaraArr
        {
            if l_id == item2.l_id
            {
                let fNm = item2.l_floor
                let Rnm = item2.l_room
                let Wnm = item2.l_wing
                let Snm = item2.l_space
                //let Bnm = item2.
                
                if Rnm == "NF" || Wnm == "NF"
                {
                    locationName = "Floor: \(fNm!), Space: \(Snm!)"
                }
                else
                {
                    locationName = "Room: \(Rnm!), Wing: \(Wnm!), Floor: \(fNm!), Space: \(Snm!)"
                }
            }
        }

    }
   
    
    func getPendingTickets(id: String, role: String, status: String)
    {
       let Api = constant.BaseUrl + constant.getMaverickticket
        let param = ["user_id" : id,
                     "user_role" : role,
                     "status" : status]
        
        Alamofire.request(Api, method: .post, parameters: param).responseJSON { (resp) in
         
            switch resp.result
            {
            case .success(_):
    
                do {
                    let pendingTicket = try JSONDecoder().decode(MaverickTicket.self, from: resp.data!)
                    
                    self.m_cTickets = pendingTicket.getMaverickTickets
                
                    self.tblPendingTickets.reloadData()
                    
                }catch let error as NSError{
                    print(error)
                }
              
                break
            case .failure(_):
                break
            }
            
        }
    }
    
    @objc func btnViewMore_onclick(sender: UIButton)
    {
       let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblPendingTickets)
        let indexPath = self.tblPendingTickets.indexPathForRow(at: buttonPosition)
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "DetailMaverickTickVc") as! DetailMaverickTickVc
       
        let lcTickDict = m_cTickets[(indexPath?.row)!]
        
        print(lcTickDict)
        vc.Locationstr = locationName
        vc.setTicketData(lcdict: lcTickDict)
        self.navigationController?.pushViewController(vc, animated: true)
 
    }
    
}
extension PendingMaverickTickets : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_cTickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblPendingTickets.dequeueReusableCell(withIdentifier: "PendingMaverickTicketCell", for: indexPath) as! PendingMaverickTicketCell
        
        let lcdict = m_cTickets[indexPath.row]
        
        if ticketStatus == 0
        {
            cell.assignViewHgt.constant = 0
            cell.closedViewHgt.constant = 0
        }
        if ticketStatus == 1
        {
            cell.assignViewHgt.constant = 21
            cell.closedViewHgt.constant = 0
            
            cell.lblAssignedTo.text = lcdict.assigned_to
        }
        if ticketStatus == 2
        {
            cell.assignViewHgt.constant = 21
            cell.closedViewHgt.constant = 21
            
            cell.lblAssignedTo.text = lcdict.closed_by
            cell.lblClosedBy.text = lcdict.closed_by
        }
        
        cell.lblTicketNo.text = "Ticket No:  \(lcdict.mt_id!)"
        cell.lblObservation.text = lcdict.mt_subject
        cell.lblSpace.text = lcdict.l_space
        getLid(l_id: lcdict.l_id)
        cell.lblLocation.text = locationName
        
        cell.btnViewMore.tag = indexPath.row
        cell.btnViewMore.addTarget(self, action: #selector(btnViewMore_onclick(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
}

