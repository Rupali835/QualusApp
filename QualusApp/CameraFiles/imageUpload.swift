//
//  imageUpload.swift
//  Activo
//
//  Created by user on 18/05/18.
//  Copyright © 2018 Prajakta Bagade. All rights reserved.
//

import Foundation
import UIKit
import Photos
import SVProgressHUD

protocol imageUploadDelegate: class
{
    func Success(MessgaStr: String)
}

class imageUpload: NSObject
{
    static let SharedInstance = imageUpload()
    //var fileName: String!
    var delegate: imageUploadDelegate?
    
    func ImageUploadData(MyUrl: String, lcParam: [String: String], lcOriginalImgArr: [UIImage],lcImagArr: [Any],cDelegate: imageUploadDelegate, withHUD: Bool)  
{
    
    if withHUD {
    OperationQueue.main.addOperation {

    SVProgressHUD.show()

        }
    }
    
    self.delegate = cDelegate
    
    let cMyUrl = URL(string: MyUrl)
    
    var request = URLRequest(url: cMyUrl!)
    
    request.httpMethod = "POST";
    
    let boundary = generateBoundaryString()
    
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.httpBody = createBodyWithParameters(parameters: lcParam, lcimageViewArr: lcOriginalImgArr, lcImageNameArr: lcImagArr, boundary: boundary) as Data
    
    
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

extension NSMutableData
{

    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

