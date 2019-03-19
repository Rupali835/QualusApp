
import UIKit
import Foundation

struct ManagemnetDataModel:Codable {
    
    var t_today : Int
    var t_gen_and_close_today : Int
    var t_pending_till_date : String
    var sv_chk_fill_month : String
    var au_chk_fill_month : String
   // var getTicketData : [getManageTicketDetails]
    var supervisor_Target : [SupervisiorTicketDetails]
    var auditor_Target : [AuditorTicketDetails]
   // var getTicketData : [getManageTicketDetails]

    
    private enum CodingKeys : String, CodingKey {
      
            case supervisor_Target = "Supervisor Target", auditor_Target = "Auditor Target",t_today,t_gen_and_close_today,t_pending_till_date,sv_chk_fill_month,au_chk_fill_month  //,getTicketData
        }
    
}
struct SupervisiorTicketDetails:Codable {
    var name : String
    var expected : String
    var actual : Int
    var id : Int
    var Spercentage : Int32?
}
struct AuditorTicketDetails:Codable {
    var name : String
    var expected : String
    var actual : Int
    var id : Int
    var Apercentage : Int32?

}
/*
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

*/




