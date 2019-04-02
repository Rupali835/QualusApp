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
    var Fcid = String()
    var imgPath = String()
    var m_bImg = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if m_bImg == false
        {
            imgPath = constant.proactive_imgPath + imgNm
            let Imgurl = URL(string: imgPath)
            imgFullScreen.kf.setImage(with: Imgurl)
        }else
        {
            if imgNm != nil
            {
                if Fcid != "0"
                {
                    imgPath = constant.ansImagePath + imgNm
                }else
                {
                    imgPath = constant.imagePath + imgNm
                }
                let Imgurl = URL(string: imgPath)
                imgFullScreen.kf.setImage(with: Imgurl)
                
            }
            
            if Fcid == nil
            {
                imgPath = constant.ansImagePath + imgNm
                let Imgurl = URL(string: imgPath)
                imgFullScreen.kf.setImage(with: Imgurl)
            }
        }
       
    }
}

