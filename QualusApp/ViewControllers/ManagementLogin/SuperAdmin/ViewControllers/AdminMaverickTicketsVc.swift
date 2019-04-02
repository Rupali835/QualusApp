//
//  AdminMaverickTicketsVc.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 3/14/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class AdminMaverickTicketsVc: UIViewController {

    @IBOutlet weak var tblmaverickTickets: UITableView!
    
    var arrpendingTicket : [getManageTicketDetails] = []
    var ticketType : Int!
    var UserRole: String!
    var UserId: String!
    var com_id: String!
    var toast = JYToast()
    let manager: Alamofire.SessionManager = {
        return Alamofire.SessionManager.default
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        UserRole = lcDict["role"] as! String
        UserId = lcDict["user_id"] as! String
        com_id = lcDict["com_id"] as! String
        GetMonitorTickets()
    
        tblmaverickTickets.registerCellNib(AdminMaverickTicketCell.self)
        
        tblmaverickTickets.delegate = self
        tblmaverickTickets.dataSource = self
        tblmaverickTickets.separatorStyle = .none
        
    }
    
    func GetMonitorTickets()
    {
        let ticketUrl = "http://kanishkagroups.com/Qualus/index.php/AndroidV2/Reports/get_ticket_monitor_data"
        
        let T_get_para = ["type":  String(ticketType),
                          "role": UserRole!,
                          "user_id":UserId!,
                          "com_id": com_id!]
        print(T_get_para)
        OperationQueue.main.addOperation {
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setBackgroundColor(UIColor.gray)
            SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
            SVProgressHUD.show()
        }
        manager.request(ticketUrl, method: .post, parameters: T_get_para, encoding: URLEncoding.default, headers: nil).responseData { (resp) in
            if let data1 = resp.result.value
            {
                OperationQueue.main.addOperation {
                    SVProgressHUD.dismiss()
                }
                do
                {
                    let TicketModel = try JSONDecoder().decode(TicketMonitorData.self, from: data1)
                    self.arrpendingTicket = TicketModel.getTicketData
                    print("ticketModel", self.arrpendingTicket.count)
                    if self.arrpendingTicket.count == 0 {
                        self.toast.isShow(ErrorMsgs.NOMavrikTicket)
                    }
                    self.tblmaverickTickets.reloadData()
                }catch
                {
                    print(error)
                }
                
            }
        }
        
    }
    
}

extension String
{
    func convertDateFormaterInList() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: self)
      
        if date != nil
        {
            dateFormatter.dateFormat = "dd-MMM-yyyy  h:mm:a"
            return  dateFormatter.string(from: date!)
        }else{
            return ""
        }
        
    }
}
extension AdminMaverickTicketsVc : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return arrpendingTicket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblmaverickTickets.dequeueReusableCell(withIdentifier: "AdminMaverickTicketCell", for: indexPath) as! AdminMaverickTicketCell
        
        let lcdata = arrpendingTicket[indexPath.row]
        let Status = lcdata.status
        
        if Status == "0"
        {
            cell.lblTicketNumStatus.text = "Ticket No - \(lcdata.mt_id) (Pending)"
        }
        if Status == "1"
        {
            cell.lblTicketNumStatus.text = "Ticket No - \(lcdata.mt_id) (Open)"
        }
        if Status == "2"
        {
            cell.lblTicketNumStatus.text = "Ticket No - \(lcdata.mt_id) (Closed)"
        }
        
        cell.lblBranchNm.text = "Branch:  - \(arrpendingTicket[indexPath.row].pb_name!)"
        cell.lblProjectNm.text = "Project: \(arrpendingTicket[indexPath.row].p_name!)"
        cell.lblObserv.text = "Observations: \(arrpendingTicket[indexPath.row].mt_subject)"
        
        let Date = lcdata.created_time
        cell.lbldate.text = Date.convertDateFormaterInList()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AppStoryboard.SuperAdmin.instance.instantiateViewController(withIdentifier: "AdminDetailMaverickTickVc") as! AdminDetailMaverickTickVc
        
        let lcdata = arrpendingTicket[indexPath.row]
        vc.setTicketData(lcTicket: lcdata)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
