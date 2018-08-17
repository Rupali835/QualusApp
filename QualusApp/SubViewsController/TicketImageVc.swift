//
//  TicketImageVc.swift
//  QualusApp
//
//  Created by user on 24/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TicketImageVc: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
   
    
    @IBOutlet weak var ImageCollView: UICollectionView!
    @IBOutlet weak var backView: UIView!
    
    var showImg = UIImageView()
    var ImgArr = [String]()
    //var ticketImg : String = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ImageCollView.delegate = self
        ImageCollView.dataSource = self
       
    }

    func SetImage(DataArr : [String])
    {
        self.ImgArr = DataArr
        self.ImageCollView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func img(lcURl: String, cell: TicketImaheCell)
    {
        Alamofire.request(lcURl, method: .get).responseImage { (resp) in
            print(resp)
            if let img = resp.result.value{

                DispatchQueue.main.async
                    {
                        cell.TiktImage.image = img
                }
            }


        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
         return self.ImgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
       let cell = ImageCollView.dequeueReusableCell(withReuseIdentifier: "TicketImaheCell", for: indexPath) as! TicketImaheCell
        
        self.img(lcURl: self.ImgArr[indexPath.row], cell: cell)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cFullScreen = storyboard?.instantiateViewController(withIdentifier: "ShowImgFullScreenVc") as! ShowImgFullScreenVc
        
        let lcSeletedImg = self.ImgArr[indexPath.row]

        cFullScreen.setImageToView(cImgURl: lcSeletedImg)
        present(cFullScreen, animated: true, completion: nil)
        
    }
    
    @IBAction func BtnOk_Click(_ sender: Any)
    {
        self.view.removeFromSuperview()
    }
    

}
