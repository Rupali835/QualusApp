//
//  OpenImageVC.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 3/11/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Kingfisher

class OpenImageVC: UIViewController {

    @IBOutlet weak var imgFullScreen: UIImageView!
    
    var imgNm = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       if imgNm != nil
       {
           let imgpath = constant.imagePath + imgNm
           let Imgurl = URL(string: imgpath)
           imgFullScreen.kf.setImage(with: Imgurl)
        
        }
    }
    


}
