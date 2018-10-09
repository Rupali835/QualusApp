//
//  feedbackdataModel.swift
//  QualusApp
//
//  Created by Prajakta Bagade on 8/9/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation


struct FeedbckModel:Codable {
    var locations: [locationfetch]
    var branches : [branchFetch]
    var buildings: [buildngFetch]
}
struct buildngFetch:Codable {
    var bb_id : String
    var branch_id : String
    var b_name : String
    var p_id : String
}

struct branchFetch:Codable {
    var pb_id : String
    var pb_name : String
    var p_id : String
}

struct locationfetch:Codable {
    var l_id : String
    var l_barcode : String
    var p_id : String
    var branch_id : String
    var b_id : String
    var l_wing : String
    var l_floor : String
    var l_room : String
    var l_space : String
    var l_class_id : String
    var l_latitude : String
    var l_longitude : String
}
