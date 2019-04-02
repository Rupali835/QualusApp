//
//  TechnianProactiveTicketVc.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 4/1/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class TechnianProactiveTicketVc: UIViewController {

    @IBOutlet weak var tblProTickets: UITableView!
    
    var locationnm = String()
    var ticketStatus : Int!
    var LocationDaraArr = [FetchLocation]()
    var context = AppDelegate().persistentContainer.viewContext
    var UserId = String()
    var UserRole = String()
    var m_cTickets : [getProactiveTickets] = []
    var txtActionPlan : String!
    var txtRemark : String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.tblProTickets.registerCellNib(AcceptPendingMavTick_onClick.self)
        self.tblProTickets.dataSource     = self
        self.tblProTickets.delegate       = self
        self.tblProTickets.separatorStyle = .none
        
        let Lresquest = NSFetchRequest<FetchLocation>(entityName: "FetchLocation")
        let Lresponse = try! context.fetch(Lresquest)
        LocationDaraArr = Lresponse
        
        var lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        self.UserRole    = lcDict["role"] as! String
        self.UserId      = lcDict["user_id"] as! String
        
    }
 
    func toast(msg: String){
        self.view.showToast(msg, position: .bottom, popTime: 3, dismissOnTap: true)
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
    
    func getTechnicianTic(id: String, role: String, status: String)
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
                    
                    self.m_cTickets = pendingTicket.getProactiveTickets
                    
                    self.tblProTickets.reloadData()
                    
                }catch let error as NSError{
                    print(error)
                }
                
                break
            case .failure(_):
                break
            }
            
        }
    }
    
    @objc func CloseTicket(sender: UIButton)
    {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblProTickets)
        
        let indexPath = self.tblProTickets.indexPathForRow(at: buttonPosition)
        
        let lcTickDict = self.m_cTickets[(indexPath?.row)!]
        
        print(lcTickDict)
        let l_Barcode = lcTickDict.l_barcode
        let cUserid = lcTickDict.user_id
        let cTicId = lcTickDict.pt_id
        
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
    
    @objc func btnViewMore_onclick(sender: UIButton)
    {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblProTickets)
        
        let indexPath = self.tblProTickets.indexPathForRow(at: buttonPosition)
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "DetailMaverickTickVc") as! DetailMaverickTickVc
        
        let lcTickDict = m_cTickets[(indexPath?.row)!]
        
        print(lcTickDict)
        vc.Locationstr = locationnm
        vc.setProactiveTicket(lcproactive: lcTickDict)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
extension TechnianProactiveTicketVc : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_cTickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblProTickets.dequeueReusableCell(withIdentifier: "AcceptPendingMavTick_onClick", for: indexPath) as! AcceptPendingMavTick_onClick
        
        let lcdict = m_cTickets[indexPath.row]
        
        if ticketStatus == 1
        {
            cell.viewAcceptedBy.constant = 35
            cell.viewClosedBy.constant = 0
        
            cell.btnAcceptCloseTicket.isHidden = false
            cell.btnAcceptCloseTicket.setTitle("CLOSE TICKET", for: .normal)
            cell.btnAcceptCloseTicket.addTarget(self, action: #selector(CloseTicket(sender:)), for: .touchUpInside)
        }
        if ticketStatus == 2
        {
            cell.viewAcceptedBy.constant = 35
            cell.viewClosedBy.constant = 25
        
            cell.lblClosedBy.text = lcdict.closed_time.convertDateFormaterInList()
            cell.btnAcceptCloseTicket.isHidden = true
            
        }
        let barcode = lcdict.l_barcode
        let Space = lcdict.l_space
        cell.lblGeneratedBy.text = lcdict.added_by
        cell.lblTicketnum.text = "Ticket No:  \(lcdict.pt_id!)"
        cell.lblobser.text = lcdict.pt_subject
        //        cell.lblSpace.text = lcdict.l_space
        cell.lblSpace.text = "\(Space!)(\(barcode!))"
        getLid(l_id: lcdict.l_id)
        cell.lblLocation.text = locationnm
        
        cell.btnViewMoreDetail.tag = indexPath.row
        cell.btnViewMoreDetail.addTarget(self, action: #selector(btnViewMore_onclick(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
extension TechnianProactiveTicketVc : CloseTicketDelegate
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
        let m_cUserid = self.UserId
        let m_cTicketid = tiId
        let closeAction = actionTxt
        let remark = remarkTxt
        
        let Api = constant.BaseUrl + constant.closeTechnianProTic
        let param = ["user_id" : m_cUserid,
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
                    
                    self.getTechnicianTic(id: self.UserId, role: self.UserRole, status: "1")

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
