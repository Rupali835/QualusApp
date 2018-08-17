//
//  SplashScreenVc.swift
//  QualusApp
//
//  Created by user on 17/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SplashScreenVc: UIViewController {

  
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var MyImg: UIImageView!
    var ComId : String = ""
    let urlpath = "http://kanishkagroups.com/Qualus/uploads/company_logo/"
    var ImgPath : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.SplashData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setComId(Com_id : String)
    {
        self.ComId = Com_id
    }
    
    func SplashData()
    {
        let SplashUrl = "http://kanishkaconsultancy.com/Qualus-FM-Android/get_company_data.php"
        let Splashparam = ["com_id" : "36"]
        print(Splashparam)
        
        Alamofire.request(SplashUrl, method: .post, parameters: Splashparam).responseJSON { (dataResult) in
            print(dataResult)
            let data = dataResult.result.value
            let dict  = data as! [AnyObject]
            
            self.ImgPath = dict[0]["com_logo"] as! String
            let name = dict[0]["com_name"] as! String
            print("Img", self.ImgPath)
            print("name", name)
            self.img()
        }
        
    }

    func img()
    {
        let strImg = urlpath + self.ImgPath
        Alamofire.request(strImg, method: .get).responseImage { (resp) in
            print(resp)
            if let img = resp.result.value{
                
                DispatchQueue.main.async {
                    self.MyImg.image = img
                }
            }
            
            
        }
    }

}
