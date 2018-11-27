
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
    private enum CodingKeys : String, CodingKey {
      
            case supervisor_Target = "Supervisor Target", auditor_Target = "Auditor Target",t_today,t_gen_and_close_today,t_pending_till_date,sv_chk_fill_month,au_chk_fill_month
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







