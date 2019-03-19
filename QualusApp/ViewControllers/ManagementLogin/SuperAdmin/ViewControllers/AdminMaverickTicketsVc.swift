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

    @IBOutlet weak var collMaverickTickets: UICollectionView!
    
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
        
    
    collMaverickTickets.registerCellNib(getTicketCollectionViewCell.self)
        print(arrpendingTicket.count)
        
        if let flowLayout = collMaverickTickets.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
       
        collMaverickTickets.delegate = self
        collMaverickTickets.dataSource = self
        
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
                    self.collMaverickTickets.reloadData()
                }catch
                {
                    print(error)
                }
                
            }
        }
        
    }
    
}
extension AdminMaverickTicketsVc : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrpendingTicket.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "getTicketCollectionViewCell", for: indexPath)as! getTicketCollectionViewCell
        
        let lcdata = arrpendingTicket[indexPath.row]
        let Status = lcdata.status
        
        if Status == "0"
        {
            cell.lblticketnoandStatus.text = "Ticket No - \(lcdata.mt_id) (Pending)"
        }
        if Status == "1"
        {
            cell.lblticketnoandStatus.text = "Ticket No - \(lcdata.mt_id) (Open)"
        }
        if Status == "2"
        {
            cell.lblticketnoandStatus.text = "Ticket No - \(lcdata.mt_id) (Closed)"
        }
        
        cell.lblBranch.text = "Branch:  - \(arrpendingTicket[indexPath.row].pb_name!)"
        cell.lblproject1.text = "Project: \(arrpendingTicket[indexPath.row].p_name!)"
        cell.lblObservations.text = "Observations: \(arrpendingTicket[indexPath.row].mt_subject)"
        //  cell.lblticketnoandStatus.text = "Ticket NO - \(arrpendingTicket[indexPath.row].mt_id)"
        return cell
    }
   
    

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
{
    let vc = AppStoryboard.SuperAdmin.instance.instantiateViewController(withIdentifier: "AdminDetailMaverickTickVc") as! AdminDetailMaverickTickVc

      let lcdata = arrpendingTicket[indexPath.row]
      vc.setTicketData(lcTicket: lcdata)
   
    self.navigationController?.pushViewController(vc, animated: true)
    
    
//    let SelectedTicketDetails = GetSelectedTicketDetailsViewController.loadNib()
//    SelectedTicketDetails.Ticket = arrpendingTicket[indexPath.row]
//    self.navigationController?.pushViewController(SelectedTicketDetails, animated: true)
//
}

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.collMaverickTickets.frame.width, height: 160)

        return size
    }
    
}

