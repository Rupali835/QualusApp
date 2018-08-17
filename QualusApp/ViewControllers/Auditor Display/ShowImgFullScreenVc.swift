//
//  ShowImgFullScreenVc.swift
//  QualusApp
//
//  Created by user on 24/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ShowImgFullScreenVc: UIViewController
{

    @IBOutlet weak var fullTiktimg: UIImageView!
    
    @IBOutlet weak var NavigtnView: UIView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.NavigtnView.backgroundColor = UIColor(red:0.40, green:0.23, blue:0.72, alpha:1.0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func img(lcURl: String)
    {
        Alamofire.request(lcURl, method: .get).responseImage { (resp) in
            print(resp)
            if let img = resp.result.value{

                DispatchQueue.main.async
                    {
                        self.fullTiktimg.image = img
                }
            }


        }
    }

    func setImageToView(cImgURl : String)
    {
       self.img(lcURl: cImgURl)
    }

    @IBAction func btnback_Click(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
