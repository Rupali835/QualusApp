//
//  ScanForCloseProTicVc.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 3/29/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import AVScanner
import AVFoundation

protocol CloseTicketDelegate {
    func closeTicketAfterScan(userid: String, ticketid: String)
}

class ScanForCloseProTicVc: AVScannerViewController {

    var delegate : CloseTicketDelegate!
    var firstQr : String!
    var user_id : String!
    var t_id : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        supportedMetadataObjectTypes = [.qr, .pdf417]
        prepareBarcodeHandler()
        prepareViewTapHandler()
    }
    
    private func prepareBarcodeHandler () {
        barcodeHandler = barcodeDidCaptured
    }
    
    private func prepareViewTapHandler() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapHandler))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func viewTapHandler(_ gesture: UITapGestureRecognizer)
    {
        guard !isSessionRunning else { return }
        startRunningSession()
    }
    
    func setData(userId: String, ticketId: String, Qrstr: String)
    {
        self.user_id = userId
        self.t_id = ticketId
        self.firstQr = Qrstr
    }
    
    lazy var barcodeDidCaptured: (_ codeObject: AVMetadataMachineReadableCodeObject) -> Void = { [unowned self] codeObject in
        let string = codeObject.stringValue!
        print(string)
        let SecondQr = String(string.prefix(10))
        print(SecondQr)
        
        if self.firstQr == SecondQr
        {
             self.navigationController?.popViewController(animated: true)
            self.delegate?.closeTicketAfterScan(userid: self.user_id, ticketid: self.t_id)
           
        }else
        {
            self.toast(msg: "Location not match \n Rescan again")
        }
        
    }
    
    func toast(msg: String){
        self.view.showToast(msg, position: .bottom, popTime: 3, dismissOnTap: true)
    }
}
