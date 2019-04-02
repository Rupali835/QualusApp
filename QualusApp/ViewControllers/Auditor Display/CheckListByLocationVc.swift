

import UIKit
import Alamofire

class CheckListByLocationVc: UIViewController, UITableViewDelegate, UITableViewDataSource
{
   
    var userRole : String = ""
    var QrString : String!
    var LocationDaraArr = [AnyObject]()
   // var Lid : String = ""
    var checklistArr = [AnyObject]()
    var QuetionArr = [AnyObject]()
    var ClassId : String!
    var projectId : String!
    var showVC = Bool()
    private var toast : JYToast!
    var ColorArr = [UIColor]()
    
    @IBOutlet weak var tblChecklist: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CheckListByLocationVc.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
        self.userRole = lcDict["role"] as! String
     
        tblChecklist.dataSource = self
        tblChecklist.delegate = self
        toast = JYToast()
        tblChecklist.registerCellNib(LocationCell.self)
        
        LocationDaraArr = LocationData.cLocationData.fetchOfflineLocation()!
       
        for (index, _) in LocationDaraArr.enumerated()
        {
            let locationEnt = LocationDaraArr[index] as! FetchLocation
           
            if locationEnt.l_barcode == self.QrString
            {
                let l_id = locationEnt.l_id!
                self.getChecklist(lcl_Id: l_id,rollId: self.userRole )
                
            }
           
        }
        
           self.ColorArr = [UIColor.MKColor.Red.P400, UIColor.MKColor.Blue.P400, UIColor.MKColor.Orange.P400, UIColor.MKColor.Green.P400, UIColor.MKColor.Indigo.P400, UIColor.MKColor.Amber.P400, UIColor.MKColor.LightBlue.P400, UIColor.MKColor.BlueGrey.P400, UIColor.MKColor.Brown.P400, UIColor.MKColor.Cyan.P400, UIColor.MKColor.Teal.P400, UIColor.MKColor.Lime.P400, UIColor.MKColor.Pink.P400, UIColor.MKColor.Purple.P400]
        
        
    }

    @objc func back(sender: UIBarButtonItem) {

        self.navigationController?.popViewController(animated: true)
    }
    
    func setQrString(cQr: String, ProjId: String, Showvc: Bool)
    {
        self.QrString = cQr
        self.projectId = ProjId
        self.showVC = Showvc    // if from barcode = true or from scanner = false
    }
   
    func designCell(cView : UIView)
    {
        cView.layer.masksToBounds = false
        cView.layer.shadowColor = UIColor.black.cgColor
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: -1, height: 1)
        cView.layer.shadowRadius = 1
    }
    
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    func getChecklist(lcl_Id: String,rollId: String )
    {
        let checklistUrl = "https://kanishkagroups.com/Qualus/index.php/AndroidV2/Checklist/get_checklist_by_location"
        let checklistParam = ["l_id" : lcl_Id,
                              "user_role" : rollId]
    
        
          Alamofire.request(checklistUrl, method: .post, parameters: checklistParam).responseJSON { (fetchData) in
            print(fetchData)

           switch fetchData.result
           {
           case .success(_):
             let JSON = fetchData.result.value as! [String: AnyObject]

             self.checklistArr = JSON["Checklist"] as! [AnyObject]
             self.QuetionArr = JSON["Questions"] as! [AnyObject]

             if self.checklistArr.count == 0
             {
                Utilities.shared.centermsg(msg: "No checklist", view: self.view)
             }
             
             self.tblChecklist.reloadData()
            break

           case .failure(let error):
            print(error)
            self.toast.isShow("something went wrong")
            break
            }
        
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return checklistArr.count
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblChecklist.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        
        let lcDict = self.checklistArr[indexPath.row]
        
            let randomColor = ColorArr[Int(arc4random_uniform(UInt32(ColorArr.count)))]
        
        self.designCell(cView: cell.backView)
        
        let lcUserName = lcDict["c_name"] as! String
        cell.lblLocationNm.text = (lcDict["c_name"] as! String)
        self.ClassId = (lcDict["class_id"] as! String)
        let firstLetter = lcUserName.first!
        cell.lblFirstLetter.text = String(describing: firstLetter)
        cell.lblFirstLetter.backgroundColor = randomColor
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if self.showVC == false
        {
            let QuestionVc = storyboard?.instantiateViewController(withIdentifier: "ChecklistQuestionsVc") as! ChecklistQuestionsVc
            
            let lcDict = self.checklistArr[indexPath.row]
            let cid = lcDict["c_id"] as! String
            
            var questionArr = [AnyObject]()
            
        
            for lcDict in self.QuetionArr
            {
                let cidQues = lcDict["c_id"] as! String
                if cid == cidQues
                {
                    let tempDic: NSMutableDictionary = lcDict.mutableCopy() as! NSMutableDictionary

                    //lcDictData = lcDict.mutableCopy() as! [String : Bool]
                    tempDic["isYesSelected"] = false
                    tempDic["isNoSelected"]  = false
                    tempDic["isNASelected"]  = false
                    questionArr.append(tempDic as AnyObject)
                }
            }
            
            QuestionVc.ProjId = self.projectId
            QuestionVc.ClassificationId = cid
            QuestionVc.QuestionArray = questionArr
            QuestionVc.QrStr = self.QrString
            QuestionVc.CheckListArr = lcDict as! [String : Any]
            self.navigationController?.pushViewController(QuestionVc, animated: true)
        }
        else{
            
            let QueBarcodeVc = storyboard?.instantiateViewController(withIdentifier: "ChecklistQueForBarcodeVC") as! ChecklistQueForBarcodeVC
            
            let lcDict = self.checklistArr[indexPath.row]
            let cid = lcDict["c_id"] as! String
            var questionArr = [AnyObject]()
            
            for lcDict in self.QuetionArr
            {
                let cidQues = lcDict["c_id"] as! String
                
                if cid == cidQues
                {
                    questionArr.append(lcDict)
                }
            }
            QueBarcodeVc.ProjId = self.projectId
            QueBarcodeVc.ClassificationId = cid
            QueBarcodeVc.QuestionArray = questionArr
            QueBarcodeVc.CheckListArr = self.checklistArr
            QueBarcodeVc.QrStr = self.QrString
            self.navigationController?.pushViewController(QueBarcodeVc, animated: true)
        }
    }
}
