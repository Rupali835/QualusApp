//
//  ImgeUploadForChecklist.swift
//  QualusApp
//
//  Created by user on 16/08/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import UIKit
import Photos
import SVProgressHUD

protocol ChecklistImageUploadDelegate: class
{
    func Success(MessgaStr: String)
}

class ImgeUploadForChecklist: NSObject
{
    static let SharedInstance = ImgeUploadForChecklist()
    //var fileName: String!
    var delegate: ChecklistImageUploadDelegate?
    
    func ImdUploadData(Images: [UIImage], TotalImge: String, Filled_checklist: [[String: Any]], Checklist_answer: [[String: Any]], Answer_images: [[String: Any]], M_ticket_status: String, M_ticket_data: [[String: Any]], UserId: String, UserRole: String, ComId: String, cDelegate: ChecklistImageUploadDelegate, withHUD: Bool)
    {
        
        if withHUD {
            OperationQueue.main.addOperation {
                
                SVProgressHUD.show()
                
            }
        }
        
        self.delegate = cDelegate
        
        let MyUrl = URL(string: constant.BaseUrl+constant.addUrl)
        
        var request = URLRequest(url: MyUrl!)
        
        request.httpMethod = "POST";
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
  //      request.httpBody = createBodyWithParameters(parameters: lcParam, lcimageViewArr: lcOriginalImgArr, lcImageNameArr: lcImagArr, boundary: boundary) as Data
        
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            
            if error != nil {
                return
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print("****** response data = \(responseString!)")
            
            if withHUD {
                OperationQueue.main.addOperation {
                    SVProgressHUD.dismiss()
                }
            }
            self.delegate?.Success(MessgaStr: "Ticket uploaded Successfully")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                let message =  json!["msg"] as! String
                if message == "SUCCESS"
                {
                    print("ticket updated successfully")
                }
                
                DispatchQueue.main.async {
                    
                }
                
            }catch
            {
                print(error)
            }
            
        }
        
        task.resume()
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, lcimageViewArr: [UIImage], lcImageNameArr: [Any], boundary: String) -> Data
    {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters!
            {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        
        for (index, value) in lcImageNameArr.enumerated()
        {
            let lcImage = lcimageViewArr[index]
            let filePathKey = "images\(index)"
            let filename = value                     //"user-profile.jpg"
            let mimetype = "image/jpg"
            
            lcImage.resized(withPercentage: 0.3)
            lcImage.resized(toWidth: 10.0)
            let imageData = UIImageJPEGRepresentation(lcImage, 0.0)
            
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageData!)
            body.appendString(string: "\r\n")
        }
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body as Data
    }
    
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
}






