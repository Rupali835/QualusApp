//
//  checkListDataModel.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 7/26/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

struct checkListDataModel:Codable {
    var getChecklistData : [checlist]
}

struct checlist : Codable {
    var fc_id : String
    var c_id : String
    var start_time : String
    var end_time : String
    var percent : String
    var score : String
    var score_loc_out : String
    var c_name : String
    var p_id : String
    var pb_id : String
    var l_id : String
    var user_id : String
    var created_time : String
}
