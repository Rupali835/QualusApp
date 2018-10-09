//
//  CSRViewController.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 8/18/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class CSRViewController: UIViewController {

    @IBOutlet weak var bldg: UIButton!
    @IBOutlet weak var brnch: UIButton!
    @IBOutlet weak var btnwing: UIButton!
    @IBOutlet weak var btnFloor: UIButton!
    @IBOutlet weak var btnRoom: UIButton!
    @IBOutlet weak var btnSpace: UIButton!
    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet weak var branchView: UIView!
    @IBOutlet weak var BuildingView: UIView!
    @IBOutlet weak var floorView: UIView!
    @IBOutlet weak var WingView: UIView!
    @IBOutlet weak var RoomView: UIView!
    @IBOutlet weak var SpaceView: UIView!
    
    var bulidingdata: [buildngFetch] = []
    var branchData: [branchFetch] = []
    var locationData: [locationfetch] = []
    //filterdata Store
    var filterbuilding:[buildngFetch] = []
    var filterlocation: [locationfetch] = []
    var wingArray = [String]()
    var floorArray = [String]()
    var roomArray = [String]()
    var spaceArray = [String]()
    
    var selected: Int!
    var Brnhid: String!
    var BLDGID: String!
    var WIng: String!
    var floor: String!
    var room: String!
    var space: String!
    var locationid: String!
    
    var popUp : KLCPopup!
    var toast = JYToast()
    var UserId: String!
    var Role: String!
    var bool:String = "false"

    @IBOutlet var Cview: UIView!
    
    let manager: Alamofire.SessionManager = {
        return Alamofire.SessionManager.default
    }()
    
    //Mark:LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        popUp = KLCPopup()
        
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        self.Role = lcDict["role"] as! String
        self.UserId = lcDict["user_id"] as! String
     
        UserDefaults.standard.set(bool, forKey: "checkVC")

        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.registerCellNib(locationsCollectionViewCell.self)
        self.navigationItem.setHidesBackButton(true, animated:true)

        self.brnch.isHidden = false
        self.bldg.isHidden = true
        self.btnwing.isHidden = true
        self.btnFloor.isHidden = true
        self.btnRoom.isHidden = true
        self.btnSpace.isHidden = true
        
        fetchData()
        viewDesign()

    }

    //Mark: FUNCTIONS

    func fetchData()
    {
        let url = "http://kanishkaconsultancy.com/Qualus-FM-Android/fetchAllLocations.php"
        
        let para = ["u_Id": self.UserId , "u_type": self.Role]
        
       //     let para = ["u_Id": "147" , "u_type": "7"]
        
        print(para)
        
            OperationQueue.main.addOperation {
                SVProgressHUD.setDefaultMaskType(.custom)
                SVProgressHUD.setBackgroundColor(UIColor.gray)
                SVProgressHUD.setBackgroundLayerColor(UIColor.white)
                SVProgressHUD.show()
                
            }
    
        Alamofire.request(url, method: .post, parameters: para, encoding: URLEncoding.default, headers: nil).responseData { (resp) in
            if let data = resp.result.value
            {
                OperationQueue.main.addOperation {
                    SVProgressHUD.dismiss()
                }
                OperationQueue.main.addOperation {
                    do
                    {
                        let dataModel = try JSONDecoder().decode(FeedbckModel.self, from: data)
                       // print(dataModel)
                        self.branchData = dataModel.branches
                        self.bulidingdata = dataModel.buildings
                        self.locationData = dataModel.locations
                        self.collectionview.reloadData()
                    }catch
                    {
                        print(error)
                    }
                }
            }
           
        }
        
      }
    
    func viewDesign()
    {
        branchView.layer.borderWidth = 1
        branchView.layer.borderColor = UIColor.orngelight.cgColor
        branchView.layer.cornerRadius = 10
        
        
        BuildingView.layer.borderWidth = 1
        BuildingView.layer.borderColor = UIColor.greenlight.cgColor
        BuildingView.layer.cornerRadius = 10
        
        WingView.layer.borderWidth = 1
        WingView.layer.borderColor = UIColor.pinklight.cgColor
        WingView.layer.cornerRadius = 10
        
        floorView.layer.borderWidth = 1
        floorView.layer.borderColor = UIColor.darkbluelight.cgColor
        floorView.layer.cornerRadius = 10
        
        RoomView.layer.borderWidth = 1
        RoomView.layer.borderColor = UIColor.redlight.cgColor
        RoomView.layer.cornerRadius = 10
        
        SpaceView.layer.borderWidth = 1
        SpaceView.layer.borderColor = UIColor.chocklatelight.cgColor
        SpaceView.layer.cornerRadius = 10
        
    }
    
    
    
    
    
    func filterWing()
    {
        for itam in filterlocation{
            if wingArray.contains(itam.l_wing)
            {
                //do not enter the iteam
            }else{
                wingArray.append(itam.l_wing)
            }
        }
        
    }
    func filterfloor()
    {
        for itam in filterlocation{
            if floorArray.contains(itam.l_floor)
            {
            }else{
                floorArray.append(itam.l_floor)
            }
        }
    }
    
    func filterRoom(){
        for itam in filterlocation{
            if roomArray.contains(itam.l_room)
            {
            }else{
                roomArray.append(itam.l_room)
            }
        }
    }
    func filterSpace(){
        for itam in filterlocation{
            if spaceArray.contains(itam.l_space)
            {
            }else{
                spaceArray.append(itam.l_space)
            }
        }
    }
    
    func getlocationId()
    {
        // need to filter wing , floor,room ,space for getting l_id
        
        for itam in locationData
        {
            if (WIng == itam.l_wing)&&(floor == itam.l_floor)&&(room == itam.l_room)&&(space == itam.l_space)
            {
              //  print(locationid)
                locationid = itam.l_id
            }
        }
        
    }
    
    
    func UserLogout()
    {
        let url = "http://kanishkaconsultancy.com/Qualus-FM-Android/logout.php"
        let para1 = ["user_id": self.UserId]
    //    print(para1)
        
        OperationQueue.main.addOperation {
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setBackgroundColor(UIColor.gray)
            SVProgressHUD.setBackgroundLayerColor(UIColor.white)
            SVProgressHUD.show()
            
        }
        
        Alamofire.request(url, method: .post, parameters: para1, encoding: URLEncoding.default, headers: nil).responseString { (resp) in
            print(resp)
            let data = resp.result.value
            if data == "success"
            {
                OperationQueue.main.addOperation {
                    SVProgressHUD.dismiss()
                }
                UserDefaults.standard.removeObject(forKey: "UserData")
                UserDefaults.standard.removeObject(forKey: "checkVC")
                UserDefaults.standard.removeObject(forKey: "pwd")
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginPageVc") as! LoginPageVc
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let navigationController = appDelegate.window?.rootViewController as! UINavigationController
                navigationController.setViewControllers([loginVC], animated: true)
                self.navigationController?.popViewController(animated: true)
            }
           
        }
    }
    
    //Mark: ACTIONS
    
    @IBAction func branchSelection(_ sender: UIButton) {
        selected = sender.tag
        bldg.isHidden = false
        bldg.setTitle("Select Building", for: .normal)
        popUp.contentView = Cview
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = true
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        collectionview.reloadData()
        
    }
    
    @IBAction func buildingSelection(_ sender: UIButton) {
        selected = sender.tag
        btnwing.isHidden = false
        btnwing.setTitle("Select Wing", for: .normal)
        
        filterbuilding.removeAll()
        self.filterbuilding = self.bulidingdata.filter { $0.branch_id == self.Brnhid }
        popUp.contentView = Cview
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = true
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        collectionview.reloadData()
    }
    
    @IBAction func WingSelection(_ sender: UIButton) {
        selected = sender.tag
        btnFloor.isHidden = false
        btnFloor.setTitle("Select Floor", for: .normal)

        filterlocation.removeAll()
        self.filterlocation = self.locationData.filter({ $0.b_id == BLDGID})
        OperationQueue.main.addOperation {
            self.filterWing()
        }
        popUp.contentView = Cview
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = true
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        collectionview.reloadData()
        
    }
    
    @IBAction func FloorSelection(_ sender: UIButton) {
        selected = sender.tag
        btnRoom.isHidden = false
        btnRoom.setTitle("Select Room", for: .normal)
        filterlocation.removeAll()
        self.filterlocation = self.locationData.filter { $0.l_wing == WIng }
        OperationQueue.main.addOperation {
            self.filterfloor()
        }
        popUp.contentView = Cview
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = true
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        collectionview.reloadData()
    }
    
    @IBAction func roomSelection(_ sender: UIButton) {
        selected = sender.tag
        btnSpace.isHidden = false
        btnSpace.setTitle("Select Space", for: .normal)
        filterlocation.removeAll()
        self.filterlocation = self.locationData.filter{ $0.l_floor == floor && $0.l_wing == WIng}
        OperationQueue.main.addOperation {
           self.filterRoom()
        }
        popUp.contentView = Cview
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = true
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        collectionview.reloadData()
    }
    
    
    @IBAction func spaceSelection(_ sender: UIButton) {
        selected = sender.tag
        filterlocation.removeAll()
        self.filterlocation = self.locationData.filter { $0.l_room == room }
        OperationQueue.main.addOperation {
            self.filterSpace()
        }
        popUp.contentView = Cview
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = true
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        collectionview.reloadData()
    }
    
    @IBAction func feedbckSelection(_ sender: UIButton) {
        
        if brnch.titleLabel?.text == "Select Building"
        {
            self.toast.isShow("Please select Branch")
        }else if bldg.titleLabel?.text == "Select Building"
        {
            self.toast.isShow("Please select Building")
        }else if btnwing.titleLabel?.text == "Select Wing"
        {
            self.toast.isShow("Please select Wing")
        }else if btnFloor.titleLabel?.text == "Select Floor"
        {
            self.toast.isShow("Please select Floor")
        }else if btnRoom.titleLabel?.text == "Select Room"
        {
            self.toast.isShow("Please select Room")
        }else if btnSpace.titleLabel?.text == "Select Space"
        {
            self.toast.isShow("Please select Space")
        }else
        {
            self.getlocationId()
            let feedbackVc = FeedbackViewController.loadNib()
            feedbackVc.br_id = Brnhid   //brnch id
            feedbackVc.l_id = locationid
            feedbackVc.p_id = "41"
            bool = "true"
            UserDefaults.standard.set(bool, forKey: "checkVC")
            self.navigationController?.pushViewController(feedbackVc, animated: true)
            
        }
        
    }
    
    
    
    @IBAction func logOutSelection(_ sender: Any) {
        let alert = UIAlertController(title: "Qualus", message: "Are you sure to Logout", preferredStyle: .alert)
        let Yesaction = UIAlertAction(title: "Yes", style: .default, handler: { (okaction) in
            self.UserLogout()
        })
        let NOAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(Yesaction)
        alert.addAction(NOAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
}

//Mark: EXTENSION

extension CSRViewController: UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selected == 1
        {
            return branchData.count
        }else if selected == 2
        {
            return filterbuilding.count
        }else if selected == 3
        {
            return wingArray.count
        
        }else if selected == 4
        {
            return floorArray.count
            
        }else if selected == 5
        {
            return roomArray.count
            
        }else if selected == 6
        {
            return spaceArray.count
            
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.className(locationsCollectionViewCell.self), for: indexPath) as! locationsCollectionViewCell
        if selected == 1
        {
            cell.lblName.text = branchData[indexPath.row].pb_name

        }else if selected == 2
        {
            cell.lblName.text = filterbuilding[indexPath.row].b_name
 
        }else if selected == 3
        {
           cell.lblName.text = wingArray[indexPath.row]
        }else if selected == 4
        {
            cell.lblName.text = floorArray[indexPath.row]
        }else if selected == 5
        {
            cell.lblName.text = roomArray[indexPath.row]
        }else if selected == 6
        {
            cell.lblName.text = spaceArray[indexPath.row]
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selected == 1
        {
            let branchName = branchData[indexPath.row].pb_name
            brnch.tintColor = UIColor.black
            brnch.setTitle(branchName, for: .normal)
            Brnhid = branchData[indexPath.row].pb_id
            popUp.dismiss(true)
            
        }else if selected == 2
        {
            let buildingName = filterbuilding[indexPath.row].b_name
            bldg.setTitle(buildingName, for: .normal)
            BLDGID = filterbuilding[indexPath.row].bb_id
            popUp.dismiss(true)

        }else if selected == 3
        {
            WIng = wingArray[indexPath.row]
            btnwing.setTitle(WIng, for: .normal)
            popUp.dismiss(true)
        
        }else if selected == 4
        {
            floor = floorArray[indexPath.row]
            btnFloor.setTitle(floor, for: .normal)
            popUp.dismiss(true)
            
        }else if selected == 5
        {
            room = roomArray[indexPath.row]
            btnRoom.setTitle(room, for: .normal)
            popUp.dismiss(true)
            
        }else if selected == 6
        {

           space = spaceArray[indexPath.row]
            btnSpace.setTitle(space, for: .normal)
            popUp.dismiss(true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width-10, height: collectionView.frame.height-10)
    }

    
    
    
}
