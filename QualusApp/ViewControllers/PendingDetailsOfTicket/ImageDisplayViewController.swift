//
//  ImageDisplayViewController.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 7/26/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import SDWebImage

class ImageDisplayViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var imageArray = [String]()
    var selectedIndex : Int!
    var finalurl : URL!
    @IBOutlet weak var collectionView: UICollectionView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCellNib(LargImageCollectionViewCell.self)
        let selectedIndexpath = IndexPath(item: selectedIndex, section: 0)
        collectionView.selectItem(at: selectedIndexpath, animated: false, scrollPosition: .left)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.className(LargImageCollectionViewCell.self), for: indexPath) as! LargImageCollectionViewCell
        let string = imageArray[indexPath.row]
        let url = "http://kanishkagroups.com/Qualus/uploads/ticket_images/\(string)"
        finalurl = URL(string: url)
        cell.largImage.sd_setImage(with: finalurl, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width-60, height: collectionView.frame.height-60)
    }

    

}
