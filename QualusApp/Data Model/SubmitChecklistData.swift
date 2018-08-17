//
//  SubmitChecklistData.swift
//  QualusApp
//
//  Created by user on 08/08/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

class SubmitChecklistData : NSObject
{
    static var ParamListShareInst = SubmitChecklistData()
    
    var Images: String!
    var totalImages: String!
    var filled_checklist: String?
    var checklist_answer: String!
    var answer_image: String!
    var m_ticket_status: String!
    var m_ticket_data: String!
    var user_id: String!
    var user_role: String!
    var com_id: String!
    
    override init() {
        
    }
    
}
