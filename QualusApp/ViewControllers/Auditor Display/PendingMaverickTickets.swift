//
//  PendingMaverickTickets.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 3/8/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Alamofire

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
    @IBOutlet weak var lblProjectNm: UILabel!
    @IBOutlet weak var lblObservation: UILabel!
    @IBOutlet weak var lblRemark: UILabel!
    @IBOutlet weak var lblBranchNm: UILabel!
    @IBOutlet weak var lblPhotoCount: UILabel!
    @IBOutlet weak var lblActionPlan: UILabel!
    @IBOutlet weak var lblCompletionDate: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblSpace: UILabel!
    @IBOutlet var viewMoreDetail: UIView!
    @IBOutlet weak var lblTicketnum: UILabel!
    @IBOutlet weak var collView: UICollectionView!
    
    var m_cTickets : [getMaverickTickets] = []
    let popUp = KLCPopup()
    var imgArr = [String]()
    var ticketStatus : Int!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tblPendingTickets.registerCellNib(PendingMaverickTicketCell.self)

        tblPendingTickets.delegate = self
        tblPendingTickets.dataSource = self
        tblPendingTickets.separatorStyle = .none
        
        collView.delegate = self
        collView.dataSource = self
        
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        let role = lcDict["role"] as! String
        let userid = lcDict["user_id"] as! String
        
      //  getPendingTickets(id: userid, role: role, status: "0")
        
        
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
        
        vc.setTicketData(lcdict: lcTickDict)
        self.navigationController?.pushViewController(vc, animated: true)
        
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblPendingTickets)
//
//        let indexPath = self.tblPendingTickets.indexPathForRow(at: buttonPosition)
//
//        let lcTickDict = m_cTickets[(indexPath?.row)!]
//
//        setTicketData(lcdict: lcTickDict)
//
//        popUp.contentView = viewMoreDetail
//        popUp.maskType = .dimmed
//        popUp.shouldDismissOnBackgroundTouch = false
//        popUp.shouldDismissOnContentTouch = false
//        popUp.showType = .slideInFromRight
//        popUp.dismissType = .slideOutToLeft
//        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
//
       // collView.reloadData()

    }
    
    func setTicketData(lcdict : getMaverickTickets)
    {
        lblTicketnum.text = "Ticket No: \(lcdict.mt_id!)"
        lblObservation.text = lcdict.mt_subject
        lblProjectNm.text = lcdict.p_name
        lblBranchNm.text = lcdict.pb_name
        lblSpace.text = lcdict.l_space
        lblLocation.text = lcdict.l_id
        
        if lcdict.mt_action_plan_date == "0000-00-00"
        {
            lblCompletionDate.text = "Not Provided"
        }else
        {
            lblCompletionDate.text = lcdict.mt_action_plan_date
        }
    
        lblRemark.text = lcdict.mt_remark
        lblActionPlan.text = lcdict.mt_action_plan
        
        imgArr = lcdict.mt_photo
        let picCount = imgArr.count
        
        lblPhotoCount.text = "\(picCount) Photos"
        collView.reloadData()
     
     }
    
    @IBAction func btnOk_onclick(_ sender: Any) {
        popUp.dismiss(true)
    }
    
    func img(lcURl: String, cell: MaverickTicketImageCell)
    {
        Alamofire.request(lcURl, method: .get).responseImage { (resp) in
            print(resp)
            if let img = resp.result.value{
                
                DispatchQueue.main.async
                    {
                        cell.imgTicket.image = img
                }
            }
        }
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
        cell.lblLocation.text = lcdict.l_id
        
        cell.btnViewMore.tag = indexPath.row
        cell.btnViewMore.addTarget(self, action: #selector(btnViewMore_onclick(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
}
extension PendingMaverickTickets : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collView.dequeueReusableCell(withReuseIdentifier: "MaverickTicketImageCell", for: indexPath) as! MaverickTicketImageCell
        let lcurl = self.imgArr[indexPath.row]
        
        let imgpath = constant.imagePath + lcurl
        
        img(lcURl: imgpath, cell: cell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cFullScreen = storyboard?.instantiateViewController(withIdentifier: "OpenImageVC") as! OpenImageVC
        
        popUp.dismiss(true)
        
        let lcSeletedImg = self.imgArr[indexPath.row]
        
        cFullScreen.imgNm = lcSeletedImg
        
        self.navigationController?.pushViewController(cFullScreen, animated: true)
    
    }
    
}
