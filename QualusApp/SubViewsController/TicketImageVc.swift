
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        return CGSize(width: (self.ImageCollView.frame.size.width - 30) / 2, height: 165)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 15, bottom: 10, right: 15)
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    
    @IBAction func BtnOk_Click(_ sender: Any)
    {
        self.view.removeFromSuperview()
    }
    

}
