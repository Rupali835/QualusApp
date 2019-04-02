//
//  Alert.swift
//  Perfecto
//
//  Created by Prem Sahni on 24/10/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    static let shared : Alert = Alert()
    private init() {}
    
    func basicalert(vc: UIViewController,title: String,msg: String){
        let alertcontroller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertcontroller.addAction(ok)
        if vc == nil {
            vc.present(alertcontroller, animated: true, completion: nil)
        } else{
            vc.dismiss(animated: false) { () -> Void in
                vc.present(alertcontroller, animated: true, completion: nil)
            }
        }
        vc.present(alertcontroller, animated: true, completion: nil)
    }
    func internetoffline(vc: UIViewController){
        Alert.shared.basicalert(vc: vc, title: "Internet Connection Appears Offline", msg: "Go to Setting and Turn on Mobile Data or Wifi Connection")
    }
    func action(vc: UIViewController,title: String,msg: String,btn1Title: String,btn2Title: String,btn1Action: @escaping () -> (),btn2Action: @escaping () -> ()){
        let alertcontroller = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let titleFont = [NSAttributedString.Key.font: UIFont(name: "ArialHebrew-Bold", size: 18.0)!]
        let messageFont = [NSAttributedString.Key.font: UIFont(name: "ArialHebrew-Bold", size: 15.0)!]
        
        let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: msg, attributes: messageFont)
        
        alertcontroller.setValue(titleAttrString, forKey: "attributedTitle")
        alertcontroller.setValue(messageAttrString, forKey: "attributedMessage")
        
        alertcontroller.view.backgroundColor = UIColor.clear
        let button1 = UIAlertAction(title: btn1Title, style: .default) { (action) in
            btn1Action()
        }
        let button2 = UIAlertAction(title: btn2Title, style: .cancel) { (action) in
            btn2Action()
        }
        alertcontroller.addAction(button1)
        alertcontroller.addAction(button2)
        if vc == nil {
            vc.present(alertcontroller, animated: true, completion: nil)
        } else{
            vc.dismiss(animated: false) { () -> Void in
                vc.present(alertcontroller, animated: true, completion: nil)
            }
        }
        vc.present(alertcontroller, animated: true, completion: nil)
    }
    func dismissAlert(vc: UIViewController){
        vc.dismiss(animated: true, completion: nil)
    }
    
    
    func choose(vc: UIViewController,title1: String,title2: String,ActionCompletion: @escaping () -> (),Action2Completion: @escaping () -> ()){
        let alertcontroller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let button1 = UIAlertAction(title: title1, style: .default) { (action) in
            ActionCompletion()
        }
        let button2 = UIAlertAction(title: title2, style: .default) { (action) in
            Action2Completion()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertcontroller.addAction(button1)
        alertcontroller.addAction(button2)
        alertcontroller.addAction(cancel)
        if vc == nil {
            vc.present(alertcontroller, animated: true, completion: nil)
        } else{
            vc.dismiss(animated: false) { () -> Void in
                vc.present(alertcontroller, animated: true, completion: nil)
            }
        }
        vc.present(alertcontroller, animated: true, completion: nil)
    }
}

extension UIAlertAction {
    convenience init(title: String?, style: UIAlertAction.Style, image: UIImage, handler: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: title, style: style, handler: handler)
        self.actionImage = image
    }
    var actionImage: UIImage {
        get {
            return self.value(forKey: "image") as? UIImage ?? UIImage()
        }
        set(image) {
            self.setValue(image, forKey: "image")
        }
    }
}
/*
 
 func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
 let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
 deviceTokenString = token
 print(deviceToken)
 }
 func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
 print("i am not available in simulator \(error)")
 }
 
 UNUserNotificationCenter.current().delegate = self
 application.registerForRemoteNotifications()
 UNUserNotificationCenter.current().cleanRepeatingNotifications()
 UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: -500.0, vertical: 0.0), for: .default)
 
 setCategories()
 
 
 extension AppDelegate:  UNUserNotificationCenterDelegate{
 
 func setCategories(){
 let clearRepeatAction = UNNotificationAction(
 identifier: "clear.repeat.action",
 title: "Stop Repeat",
 options: [])
 let remindaction = UNNotificationAction(
 identifier: "remindLater",
 title: "Remind me later",
 options: [])
 let Category = UNNotificationCategory(
 identifier: "medicine.reminder.category",
 actions: [clearRepeatAction,remindaction],
 intentIdentifiers: [],
 options: [])
 UNUserNotificationCenter.current().setNotificationCategories([Category])
 }
 
 
 func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
 completionHandler([.alert,.sound])
 
 }
 
 func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
 if UIApplication.shared.applicationState == .background{
 print("bg")
 }
 UNUserNotificationCenter.current().cleanRepeatingNotifications()
 print("Did recieve response: \(response.actionIdentifier)")
 if response.actionIdentifier == "clear.repeat.action"{
 UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [response.notification.request.identifier])
 
 }
 if response.actionIdentifier == "remindLater" {
 UNUserNotificationCenter.current().getDeliveredNotifications { (receivedNotifications) in
 for notification in receivedNotifications {
 let content = notification.request.content
 let newDate = Date(timeInterval: 60, since: Date())
 self.scheduleNotification(at: newDate, title: content.title, body: content.body, withCompletionHandler: {
 completionHandler()
 })
 }
 }
 }
 completionHandler()
 }
 func scheduleNotification(at date: Date,title: String,body: String,withCompletionHandler: @escaping() -> ()) {
 let calendar = Calendar(identifier: .gregorian)
 let components = calendar.dateComponents(in: .current, from: date)
 let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
 
 let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
 
 let content = UNMutableNotificationContent()
 content.title = title
 content.body = body
 content.sound = UNNotificationSound.default
 content.categoryIdentifier = "medicine.reminder.category"
 
 let request = UNNotificationRequest(identifier: date.description, content: content, trigger: trigger)
 
 UNUserNotificationCenter.current().delegate = self
 UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
 UNUserNotificationCenter.current().add(request) {(error) in
 if let error = error {
 print("Uh oh! We had an error: \(error)")
 }
 }
 }
 
 }
 
 
 

 
 extension UNUserNotificationCenter{
    func cleanRepeatingNotifications(){
        //cleans notification with a userinfo key endDate
        //which have expired.
        var cleanStatus = "Cleaning...."
        getPendingNotificationRequests {
            (requests) in
            for request in requests{
                if let endDate = request.content.userInfo["endDate"]{
                    if Date() >= (endDate as! Date){
                        cleanStatus += "Cleaned request"
                        let center = UNUserNotificationCenter.current()
                        center.removePendingNotificationRequests(withIdentifiers: [request.identifier])
                    } else {
                        cleanStatus += "No Cleaning"
                    }
                    print(cleanStatus)
                }
            }
        }
    }
    
    
}*/
