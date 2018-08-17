//
//  FilledChecklistData.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 8/2/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

struct filledChceklistData:Codable {
    var filled_checklist : [checklistData]
}

struct checklistData : Codable {
    var fc_id : String
    var c_id : String
    var start_time : String
    var end_time : String
    var percent : String
    var score : String
    var c_name : String
    var p_id : String
    var pb_id : String
    var l_id : String
   
}
