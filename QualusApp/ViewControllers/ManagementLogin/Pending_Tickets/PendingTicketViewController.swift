//
//  PendingTicketViewController.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 7/19/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class PendingTicketViewController: UIViewController {
    
    //MARK:OUTLATE
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:VARIABLES
    var arrpendingTicket : [getManageTicketDetails] = []
    var ticketType = Int()
    var UserRole: String!
    var UserId: String!
    var com_id: String!
    var toast = JYToast()

    let manager: Alamofire.SessionManager = {
        return Alamofire.SessionManager.default
    }()
    
    //MARK:LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        UserRole = lcDict["role"] as! String
        UserId = lcDict["user_id"] as! String
        com_id = lcDict["com_id"] as! String
        GetMonitorTickets()
        setupcollectionView()
    }
    
    
    
    //MARK:FUNCTIONS

    func setupcollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCellNib(getTicketCollectionViewCell.self)
        collectionView.reloadData()
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
            SVProgressHUD.setBackgroundLayerColor(UIColor.white)
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
                self.collectionView.reloadData()
            }catch
            {
                print(error)
            }
        
         }
        }

    }

    //MARK:ACTIONS

}

//MARK:EXTENSIONS
extension PendingTicketViewController: UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return arrpendingTicket.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "getTicketCollectionViewCell", for: indexPath)as! getTicketCollectionViewCell
        cell.lblBranch.text = "Branch:  - \(arrpendingTicket[indexPath.row].pb_name)"
        cell.lblproject1.text = "Project: \(arrpendingTicket[indexPath.row].p_name)"
        cell.lblObservations.text = "Observations: \(arrpendingTicket[indexPath.row].mt_subject)"
        cell.lblticketnoandStatus.text = "Ticket NO - \(arrpendingTicket[indexPath.row].mt_id)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let SelectedTicketDetails = GetSelectedTicketDetailsViewController.loadNib()
        SelectedTicketDetails.Ticket = arrpendingTicket[indexPath.row]
        self.navigationController?.pushViewController(SelectedTicketDetails, animated: true)
        
    }
    
}



