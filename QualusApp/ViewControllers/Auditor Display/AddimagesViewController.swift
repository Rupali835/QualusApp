//
//  AddimagesViewController.swift
//  RealUs
//
//  Created by iAM on 01/02/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit
import SDWebImage
import ALCameraViewController

protocol AddImagesDelegate: class {
    func attachmentarrayImage(index: Int,imagearr: [ImgeFromCam])
}
class AddimagesViewController: UIViewController {

    @IBOutlet var collectionview: UICollectionView!
    @IBOutlet var add: UIButton!
    @IBOutlet var submit: UIButton!
    var index = Int()
    var attachmentarray : NSMutableArray = []
    weak var delegate : AddImagesDelegate!
    var m_cImageArrFromCam = [ImgeFromCam]()
    var User_id = String()
    
    var libraryEnabled      : Bool = false
    var croppingEnabled     : Bool = false
    var allowResizing       : Bool = true
    var allowMoving         : Bool = false
    var deletindex          : Int = 0
    var withHUD             : Bool!
    var minimumSize         : CGSize = CGSize(width: 60, height: 60)
    
    var croppingParameters: CroppingParameters {
        return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumSize)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Images"
       
        add.addTarget(self, action: #selector(addAttachmentAction), for: .touchUpInside)
        submit.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        
        let lcDict: [String: AnyObject] = UserDefaults.standard.object(forKey: "UserData") as! [String : AnyObject]
     
         self.User_id = lcDict["user_id"] as! String

    
    }
   
    @objc func submitAction(){
       
        if self.m_cImageArrFromCam.count == 0
        {
            DispatchQueue.main.async {
                self.view.showToast("No Images Selected For Submit", position: .top, popTime: 2, dismissOnTap: true)
            }
        } else {
            delegate.attachmentarrayImage(index: self.index, imagearr: self.m_cImageArrFromCam)
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc func addAttachmentAction()
    {
        if self.m_cImageArrFromCam.count == 4
        {
        self.view.showToast("Max. 4 images is allowed", position: .top, popTime: 2, dismissOnTap: true)
        }
        else
        {
        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: libraryEnabled){ [weak self] image, asset in
            
            if image != nil{
                let timestamp = Date().toMillis()
                image!.accessibilityIdentifier = String(describing: timestamp)
                let lcFileName = image!.GetFileName()
                
               // let lcFileName = (self?.User_id)! + "_" + String(timestamp)
                
                let lcImageFromCam = ImgeFromCam(Index: self!.index, Img: image!, ImgName: lcFileName, ImgUrl: lcFileName, ImgPicTime: (self?.getDate())!)
                
                self?.m_cImageArrFromCam.append(lcImageFromCam)
                
                self?.collectionview.reloadData()
            }
          
            DispatchQueue.main.async {
                self?.dismiss(animated: true, completion: nil)
            }
            
        }
        
        present(cameraViewController, animated: true, completion: nil)
        }
    
    }

    func getDate() -> String
    {
        let date =  Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd, hh:mm:ss"
        let lcDate = formatter.string(from: date)
        return lcDate
    }
    
}
extension AddimagesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return m_cImageArrFromCam.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! imagesCollectionViewCell
        
        let lcSelectedIndex = self.m_cImageArrFromCam[indexPath.row]
        cell.images.image = lcSelectedIndex.CamImag
        cell.backgroundColor = UIColor.groupTableViewBackground
        cell.delete.tag = indexPath.row
        cell.delete.addTarget(self, action: #selector(btnDeleteImage(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 2) - (10+5), height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    @objc func btnDeleteImage(sender: UIButton)
    {
        self.m_cImageArrFromCam.remove(at: sender.tag)
        collectionview.reloadData()
    }
    
}
