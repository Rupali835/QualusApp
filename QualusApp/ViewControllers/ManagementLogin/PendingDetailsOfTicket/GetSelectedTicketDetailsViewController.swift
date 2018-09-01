//
//  GetSelectedTicketDetailsViewController.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 7/18/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class GetSelectedTicketDetailsViewController: UIViewController,imgaeSelectionProtocal {
    @IBOutlet var bigImgView: UIView!
    @IBOutlet weak var largImg: UIImage!
    
    
    var context = AppDelegate().persistentContainer.viewContext

    func SelectedImg(ImageArr: [String], selectedindex: Int) {
        let imgeVc = ImageDisplayViewController.loadNib()
        imgeVc.imageArray = ImageArr
        imgeVc.selectedIndex = selectedindex
        navigationController?.pushViewController(imgeVc, animated: true)
    }
    
    @IBOutlet weak var lblTciketNo: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var Ticket : getManageTicketDetails!
    var Arr : [[String:Any]] = []
    var Arrimage = [UIImage]()
    var AssignUserName : String!
    var userArray = [FetchUserList]()
    var remark : String!
    var Actions : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        self.tableview.separatorStyle = .none
        self.tableview.rowHeight = UITableViewAutomaticDimension
        lblTciketNo.text = "Ticket No"+""+Ticket.mt_id
        tableview.registerCellNib(TicketDetaIsTableViewCell.self)
        tableview.registerCellNib(ticketdetailsTableViewCell.self)
        NFCheck()
        dataDisplay()
        Arrimage = [#imageLiteral(resourceName: "binocular"),#imageLiteral(resourceName: "checklist"),#imageLiteral(resourceName: "branch1"),#imageLiteral(resourceName: "location"),#imageLiteral(resourceName: "Office"),#imageLiteral(resourceName: "stopwatch"),#imageLiteral(resourceName: "user"),#imageLiteral(resourceName: "user"),#imageLiteral(resourceName: "chat"),#imageLiteral(resourceName: "write"),#imageLiteral(resourceName: "ticket"),#imageLiteral(resourceName: "ticket"),#imageLiteral(resourceName: "camera")]
        tableview.reloadData()
    }
    
    func NFCheck()
    {
        if Ticket.assigned_to == "0"
        {
            Ticket.assigned_to = "Not Assigned"
        }
        if Ticket.mt_action_plan == "NF"
        {
            Ticket.mt_action_plan = "Status Pending"
        }
        if Ticket.t_close_action == "NF"
        {
            Ticket.t_close_action = "Not Provided"
        }
        if Ticket.t_close_remark == "NF"
        {
            Ticket.t_close_remark  = "Not Provided"
        }
    }
    
    func dataDisplay()
    {
        
         if let Data = Ticket
        {
            Arr =  [["title":"Observation","details":(Ticket.mt_subject)],["title":"Project","details":(Ticket.p_name)],
                    ["title":"Branch","details":(Ticket.pb_name)],
                    ["title":"Space","details":(Ticket.l_space)],
                    ["title":"locations","details":("Floor:\(Ticket.l_floor),Building:\(Ticket.b_name)")],
                    ["title":"Expected Completion Date","details":(Ticket.mt_action_plan_date)],
                    ["title":"Added by ","details":(Ticket.added_by_name)],
                    ["title":"Assigned To/Accepted by","details": Ticket.assigned_to],
                    ["title":"Remark","details":(Ticket.mt_remark)],
                    ["title":"Action Plan implemented by Supervisor","details":(Ticket.mt_action_plan)],
                    ["title":"Remark by Supervisor","details": Ticket.t_close_remark],
                    ["title":"Ticket close action","details": Ticket.t_close_action],
                    ["title":"Photos","details":Ticket.mt_photo]]
        }
    }
   
}


extension GetSelectedTicketDetailsViewController: UITableViewDataSource,UITableViewDelegate

{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == Arr.count-1 {
            return 188.0
        }else{
            return 77
        }
    }

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let title = Arr[indexPath.row]["title"] as? String
    
        if title == "Photos"{
            let cell = tableView.dequeueReusableCell(withIdentifier: String.className(ticketdetailsTableViewCell.self), for: indexPath) as! ticketdetailsTableViewCell
            cell.loadData(data: Arr[indexPath.row])
            cell.delegate = self
            return cell
            
        }else{

            let cell = tableView.dequeueReusableCell(withIdentifier: String.className(TicketDetaIsTableViewCell.self), for: indexPath) as! TicketDetaIsTableViewCell
            cell.lblTittle.text = Arr[indexPath.row]["title"] as? String
            cell.lblDetails.text = Arr[indexPath.row]["details"] as? String
            cell.ImagesOflable.image = Arrimage[indexPath.row]
            return cell
        }
     }
    
}
