//
//  ErrorMsgs.swift
//  ACTIF
//
//  Created by webwerks1 on 6/15/18.
//  Copyright © 2018 Prajakta Bagade. All rights reserved.
//

import Foundation


struct ErrorMsgs {
    
    static let NOMavrikTicket = "No maverick tickets"
    static let alredyLogin = "This user is Already LoggedIn.Please retry with another credentials"
    static let loginNotmatch = "Login credential did not match. Please retry"
    static let NoObservation = "Ticket Subject is mandatory"
    static let imageCmpousory = "Please click At least one Image"
    static let InvalidDateSelection = "Do not select the Privious date"
}



//    func filterTickets() {
//        if ticketType == 1{
//            arrpendingTicket = arrpendingTicket.filter { $0.status == "1"} //today gen
//        }else if ticketType == 2 {
//            arrpendingTicket = arrpendingTicket.filter { $0.status == "2"} //today gen & closed
//        }else{
//            arrpendingTicket = arrpendingTicket.filter { $0.status == "3"} // pending till
//        }
//        collectionView.reloadData()
//    }
