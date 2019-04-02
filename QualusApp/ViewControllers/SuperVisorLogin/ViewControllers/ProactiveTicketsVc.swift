//
//  ProactiveTicketsVc.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 3/28/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

struct ProactiveTicket: Decodable
{
    var code                : Int?
    var getProactiveTickets : [getProactiveTickets]
}

struct getProactiveTickets: Decodable
{
    var pt_id                : String!
    var com_id               : String!
    var p_id                 : String!
    var pb_id                : String!
    var l_id                 : String!
    var l_barcode            : String!
    var user_id              : String!
    var pt_subject           : String!
    var pt_photo             : [String]!
    var pt_remark            : String!
    var pt_action_plan       : String!
    var pt_action_plan_date  : String!
    var status               : String!
    var created_time         : String!
    var assigned_to          : String!
    var assigned_time        : String!
    var assignment_data      : String!
    var closed_by            : String!
    var closed_time          : String!
    var pt_close_action      : String!
    var pt_close_remark      : String!
    var p_name               : String!
    var pb_name              : String!
    var added_by             : String!
    var l_space              : String!
}

class ProactiveTicketsVc: UIViewController {

    @IBOutlet weak var tblProactiveTickets: UITableView!
    
    var m_cProactiveTickets : [getProactiveTickets] = []
    var locationnm = String()
    var ticketStatus : Int!
    var LocationDaraArr = [FetchLocation]()
    var context = AppDelegate().persistentContainer.viewContext

    override func viewDidLoad()
    {
        super.viewDidLoad()
    self.tblProactiveTickets.registerCellNib(PendingMaverickTicketCell.self)
        self.tblProactiveTickets.delegate = self
        self.tblProactiveTickets.dataSource = self
        self.tblProactiveTickets.separatorStyle = .none
       
        let Lresquest = NSFetchRequest<FetchLocation>(entityName: "FetchLocation")
        let Lresponse = try! context.fetch(Lresquest)
        LocationDaraArr = Lresponse
    }
    
    func getPendingTickets(id: String, role: String, status: String)
    {
        let Api = constant.BaseUrl + constant.getProactiveTicket
        let param = ["user_id" : id,
                     "user_role" : role,
                     "status" : status]
        
        print(param)
        Alamofire.request(Api, method: .post, parameters: param).responseJSON { (resp) in
            
            switch resp.result
            {
            case .success(_):
                
                do {
                    let pendingTicket = try JSONDecoder().decode(ProactiveTicket.self, from: resp.data!)
                    
                   self.m_cProactiveTickets = pendingTicket.getProactiveTickets
                    
                    self.tblProactiveTickets.reloadData()
                    
                }catch let error as NSError{
                    print(error)
                }
                
                break
            case .failure(_):
                break
            }
            
        }
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
                    locationnm = "Floor: \(fNm!), Space: \(Snm!)"
                }
                else
                {
                    locationnm = "Room: \(Rnm!), Wing: \(Wnm!), Floor: \(fNm!), Space: \(Snm!)"
                }
            }
        }
        
    }
    
    @objc func btnViewMore_onclick(sender: UIButton)
    {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblProactiveTickets)
        let indexPath = self.tblProactiveTickets.indexPathForRow(at: buttonPosition)
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "DetailMaverickTickVc") as! DetailMaverickTickVc
        
        let lcTickDict = m_cProactiveTickets[(indexPath?.row)!]
        
        print(lcTickDict)
        vc.Locationstr = locationnm
        vc.setProactiveTicket(lcproactive: lcTickDict)
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
}
extension ProactiveTicketsVc : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_cProactiveTickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblProactiveTickets.dequeueReusableCell(withIdentifier: "PendingMaverickTicketCell", for: indexPath) as! PendingMaverickTicketCell
       
        let lcdict = m_cProactiveTickets[indexPath.row]
        
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
        
        cell.lblTicketNo.text = "Ticket No:  \(lcdict.pt_id!)"
        cell.lblObservation.text = lcdict.pt_subject
        cell.lblSpace.text = lcdict.l_space
        getLid(l_id: lcdict.l_id)
        cell.lblLocation.text = locationnm
        
        cell.btnViewMore.tag = indexPath.row
        cell.btnViewMore.addTarget(self, action: #selector(btnViewMore_onclick(sender:)), for: .touchUpInside)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
