//
//  ticketMonitorDataModel.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 7/25/18.
//  Copyright © 2018 user. All rights reserved.

import UIKit
import Foundation


struct TicketMonitorData: Codable {
    var getTicketData : [getManageTicketDetails]
}

struct getManageTicketDetails:Codable {
    
    var mt_id : String
    var com_id : String
    var p_id : String
    var pb_id : String
    var l_id : String
    var l_barcode : String
    var user_id : String
    var fc_id : String
    var a_id : String
    var user_role : String
    var mt_subject : String
    var mt_photo : [String]
    var mt_remark:String
    var mt_action_plan : String
    var mt_action_plan_date : String
    var status : String
    var created_time : String
    var assigned_to : String
    var assigned_time : String
    var sv_accepted_by: String
    var sv_accepted_time : String
    var assignment_data : String
    var closed_by : String
    var closed_time : String
    var t_close_action : String?
    var t_close_remark : String?
    var p_name : String?
    var pb_name : String?
    var bb_id : String?
    var l_space : String?
    var l_wing : String?
    var l_floor : String?
    var l_room : String?
    var b_name : String?
    var added_by_name : String
    var assigned_to_name : String?
}







