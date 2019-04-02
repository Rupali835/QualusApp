//
//  Constant.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 7/20/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

struct constant {
    
    static let BaseUrl              = "http://kanishkagroups.com/Qualus/index.php/AndroidV2/"
    
    static let Login     = "Login/userLogin"
    static let Logout    = "logout.php"
    static let fcmToken  = "Login/updateGCMID"
    
    
    static let Management           = "Reports/get_monitor_data"
    
    static let addUrl               = "Tickets/add_maverick_ticket"
    
    static let todaysChecklist      = "Reports/get_today_filled_checklist_monitor_data"
    
    static let ticketsCount         = "Reports/get_counts_for_auditor"
    
    static let getMaverickticket    = "Tickets/get_maverick_ticket_details"
    
    static let imagePath            = "http://kanishkagroups.com/Qualus/uploads/ticket_images/"
    
    static let ansImagePath         = "http://kanishkagroups.com/Qualus/uploads/answer_images/"
    
    static let SuperVisorCount      = "Reports/get_counts_for_supervisor"
    
    static let getProactiveTicket   = "Tickets/get_proactive_ticket_details"
    
//    Tickets/get_proactive_ticket_details
    
    static let proactive_imgPath    = "http://kanishkagroups.com/Qualus/uploads/pro_ticket_images/"
    
    static let acceptProactiveTic       = "Tickets/accept_ticket"
    static let closeProactiveTic        = "Tickets/close_ticket"
    static let generateProactiveTic     = "Tickets/add_proactive_ticket"
    
    static let technicianCount = "Reports/get_counts_for_technician"
    static let closeTechnianProTic = "Tickets/close_proactive_ticket"
   
}



