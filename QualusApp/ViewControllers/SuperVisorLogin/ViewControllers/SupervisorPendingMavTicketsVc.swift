//
//  SupervisorPendingMavTicketsVc.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 3/28/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class SupervisorPendingMavTicketsVc: UIViewController {

    @IBOutlet weak var tbltickets: UITableView!
    
  //  var m_cProactiveTickets : [getProactiveTickets] = []
    var m_cTickets : [getMaverickTickets] = []
    var ticketStatus : Int!
    var LocationDaraArr = [FetchLocation]()
    var locationName = String()
    var context = AppDelegate().persistentContainer.viewContext
    var txtActionPlan : String!
    var txtRemark : String!
    var Userid : String!
    var TicketId : String!
    var UserRole        : String = ""
    
    override func viewDidLoad() {
    super.viewDidLoad()
    self.tbltickets.registerCellNib(AcceptPendingMavTick_onClick.self)
    self.tbltickets.dataSource     = self
    self.tbltickets.delegate       = self
    self.tbltickets.separatorStyle = .none
        
        let Lresquest = NSFetchRequest<FetchLocation>(entityName: "FetchLocation")
        let Lresponse = try! context.fetch(Lresquest)
        LocationDaraArr = Lresponse
        
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        self.UserRole    = lcDict["role"] as! String
        self.Userid      = lcDict["user_id"] as! String
        
    }
    
    
    func getPendingTickets(id: String, role: String, status: String)
    {
        let Api = constant.BaseUrl + constant.getMaverickticket
        let param = ["user_id" : id,
                     "user_role" : role,
                     "status" : status]
        
       print(param)
        Alamofire.request(Api, method: .post, parameters: param).responseJSON { (resp) in
            
            switch resp.result
            {
            case .success(_):
                
                do {
                    let pendingTicket = try JSONDecoder().decode(MaverickTicket.self, from: resp.data!)
                    
                   self.m_cTickets = pendingTicket.getMaverickTickets

                    self.tbltickets.reloadData()
                    
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
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tbltickets)
        let indexPath = self.tbltickets.indexPathForRow(at: buttonPosition)
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "DetailMaverickTickVc") as! DetailMaverickTickVc
        
        let lcTickDict = m_cTickets[(indexPath?.row)!]

        print(lcTickDict)
        vc.Locationstr = locationName
        vc.setTicketData(lcdict: lcTickDict)
        self.navigationController?.pushViewController(vc, animated: true)
        
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
  
    func toast(msg: String){
        self.view.showToast(msg, position: .bottom, popTime: 3, dismissOnTap: true)
    }
    
    @objc func AcceptTicket(sender: UIButton)
    {
        Alert.shared.action(vc: self, title: "Qualus", msg: "Are you sure to accept ticket", btn1Title: "Yes", btn2Title: "No", btn1Action:
            {
            
                let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tbltickets)
                let indexPath = self.tbltickets.indexPathForRow(at: buttonPosition)
                
                let lcTickDict = self.m_cTickets[(indexPath?.row)!]
                
                print(lcTickDict)
                let userid = lcTickDict.user_id
                let ticketid =  lcTickDict.mt_id
                let branchId = lcTickDict.pb_id
              
                let Api = constant.BaseUrl + constant.acceptProactiveTic
                let param = ["ticket_id" :ticketid!,
                             "user_id" : self.Userid!,
                             "branch_id" : branchId!]
                print(param)
                Alamofire.request(Api, method: .post, parameters: param).responseJSON { (resp) in
                    print(resp)
                    
                    switch resp.result
                    {
                    case .success(_):
                        let json = resp.result.value as! NSDictionary
                        let msg = json["msg"] as! String
                        if msg == "SUCCESS"
                        {
                            self.toast(msg: "Ticket is accepted")
                            self.getPendingTickets(id: self.Userid, role: self.UserRole, status: "0")
                        }
                        else{
                            self.toast(msg: "Something went wrong, please try again")
                        }
                        break
                        
                    case .failure(_):
                        self.toast(msg: "Network issue")
                        break
                    }
                }
        }) {
            print("select no")
        }

     }
    
    @objc func CloseTicket(sender: UIButton)
    {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tbltickets)
        let indexPath = self.tbltickets.indexPathForRow(at: buttonPosition)
        
        let lcTickDict = self.m_cTickets[(indexPath?.row)!]
        
        print(lcTickDict)
        let l_Barcode = lcTickDict.l_barcode
        let cUserid = lcTickDict.user_id
        let cTicId = lcTickDict.mt_id
        
        Alert.shared.action(vc: self, title: "Qualus", msg: "Are you sure you want to close ticket? \n\n You Need to Scan Respective Location", btn1Title: "Yes", btn2Title: "No", btn1Action:
            {
                print("Click yes")
                let vc = AppStoryboard.SuperVisor.instance.instantiateViewController(withIdentifier: "ScanForCloseProTicVc") as! ScanForCloseProTicVc
                vc.firstQr = l_Barcode!
                vc.setData(userId: cUserid!, ticketId: cTicId!, Qrstr: l_Barcode!)
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
                
        }) {
            print("Click no")
           }

    }
}
extension SupervisorPendingMavTicketsVc : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_cTickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tbltickets.dequeueReusableCell(withIdentifier: "AcceptPendingMavTick_onClick", for: indexPath) as! AcceptPendingMavTick_onClick
        
        let lcdict = m_cTickets[indexPath.row]
        
        if ticketStatus == 0
        {
            cell.viewAcceptedBy.constant = 0
            cell.viewClosedBy.constant = 0
            cell.btnAcceptCloseTicket.isHidden = false
             cell.btnAcceptCloseTicket.setTitle("ACCEPT TICKET", for: .normal)
            cell.btnAcceptCloseTicket.addTarget(self, action: #selector(AcceptTicket(sender:)), for: .touchUpInside)
        }
        if ticketStatus == 1
        {
            cell.viewAcceptedBy.constant = 35
            cell.viewClosedBy.constant = 0
            
            cell.lblAcceptedBy.text = lcdict.sv_accepted_time.convertDateFormaterInList()
            cell.btnAcceptCloseTicket.isHidden = false
            cell.btnAcceptCloseTicket.setTitle("CLOSE TICKET", for: .normal)
            cell.btnAcceptCloseTicket.addTarget(self, action: #selector(CloseTicket(sender:)), for: .touchUpInside)
        }
        if ticketStatus == 2
        {
            cell.viewAcceptedBy.constant = 35
            cell.viewClosedBy.constant = 25
            
            if lcdict.sv_accepted_time == "0000-00-00 00:00:00"
            {
                 cell.lblAcceptedBy.text = lcdict.assigned_time.convertDateFormaterInList()
            }else
            {
                 cell.lblAcceptedBy.text = lcdict.sv_accepted_time.convertDateFormaterInList()
            }
            cell.lblClosedBy.text = lcdict.closed_time.convertDateFormaterInList()
            cell.btnAcceptCloseTicket.isHidden = true
            
        }
        let barcode = lcdict.l_barcode
        let Space = lcdict.l_space
        cell.lblGeneratedBy.text = lcdict.added_by
        cell.lblTicketnum.text = "Ticket No:  \(lcdict.mt_id!)"
        cell.lblobser.text = lcdict.mt_subject
//        cell.lblSpace.text = lcdict.l_space
        cell.lblSpace.text = "\(Space!)(\(barcode!))"
        getLid(l_id: lcdict.l_id)
        cell.lblLocation.text = locationName
        
        cell.btnViewMoreDetail.tag = indexPath.row
        cell.btnViewMoreDetail.addTarget(self, action: #selector(btnViewMore_onclick(sender:)), for: .touchUpInside)
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
extension SupervisorPendingMavTicketsVc : CloseTicketDelegate
{
    func closeTicketAfterScan(userid: String, ticketid: String)
    {
        
        let alertController = UIAlertController(title: "Qualus", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Action Plan Implemented"
        }
        let saveAction = UIAlertAction(title: "Submit", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            
            self.txtActionPlan = firstTextField.text
            self.txtRemark = secondTextField.text
            
            if self.txtActionPlan == "" || self.txtRemark == ""
            {
                self.txtActionPlan = "NF"
                self.txtRemark = "NF"
            }
            if self.txtActionPlan == "" && self.txtRemark == ""
            {
                self.txtActionPlan = "NF"
                self.txtRemark = "NF"
            }
            
            self.CloseTicketByScanning(cuserid: userid, tiId: ticketid, actionTxt: self.txtActionPlan, remarkTxt: self.txtRemark)
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Closure Remark"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
        //AbbrevationVcCall()
    }
    
    func CloseTicketByScanning(cuserid: String, tiId: String, actionTxt: String, remarkTxt: String)
    {
        let m_cUserid = self.Userid
        let m_cTicketid = tiId
        let closeAction = actionTxt
        let remark = remarkTxt
        
        let Api = constant.BaseUrl + constant.closeProactiveTic
        let param = ["user_id" : m_cUserid!,
                     "t_id" : m_cTicketid,
                     "t_close_action" : closeAction,
                     "t_close_remark" : remark]
        print(param)
        
        Alamofire.request(Api, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                
                let json = resp.result.value as! NSDictionary
                let msg = json["msg"] as! String
                if msg == "SUCCESS"
                {
                    self.toast(msg: "Ticket closed successfully")
                    
                self.getPendingTickets(id: self.Userid, role: self.UserRole, status: "1")
                }else
                {
                    self.toast(msg: "Something went wrong. Try again")
                }
                break
            case .failure(_):
                self.toast(msg: "Network issue")
                break
            }
        }
     }
}
