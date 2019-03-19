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
        UserRole = (lcDict["role"] as! String)
        UserId = (lcDict["user_id"] as! String)
        com_id = (lcDict["com_id"] as! String)
        setupcollectionView()
        self.navigationController?.navigationItem.title = "Tickets till date pending"
    }
    
    
    
    //MARK:FUNCTIONS

    func setupcollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCellNib(getTicketCollectionViewCell.self)
        collectionView.reloadData()
    }
 
}

//MARK:EXTENSIONS
extension PendingTicketViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return arrpendingTicket.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let SelectedTicketDetails = GetSelectedTicketDetailsViewController.loadNib()
        SelectedTicketDetails.Ticket = arrpendingTicket[indexPath.row]
        self.navigationController?.pushViewController(SelectedTicketDetails, animated: true)
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        <#code#>
//    }
}



