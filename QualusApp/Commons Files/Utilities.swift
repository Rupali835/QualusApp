//
//  Utilities.swift
//  Perfecto
//
//  Created by Prem Sahni on 25/10/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class Utilities {
    static let shared: Utilities = Utilities()
    private init() {}
    
    func shadow(object: [UIView]){
        for blueView in object{
            blueView.layer.cornerRadius = 5.0 
            blueView.layer.shadowColor = UIColor.darkGray.cgColor
            blueView.layer.shadowOffset = CGSize(width: 0, height: 2)
            blueView.layer.shadowOpacity = 0.5
            blueView.layer.shadowRadius = 1.0
        }
    }
    func bottomBorderSetup(fields: [UITextField],color: UIColor){
        for field in fields {
            field.borderStyle = .none
            field.autocorrectionType = .no
            field.layer.backgroundColor = color.cgColor
            field.layer.masksToBounds = false
            field.layer.shadowColor = UIColor(hexString: "#BDBDBD").cgColor
            field.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            field.layer.shadowOpacity = 1.0
            field.layer.shadowRadius = 0.0
        }
    }
    func borderRadius(objects: [UIView],color: UIColor){
        for object in objects{
            object.layer.borderColor = color.cgColor
            object.layer.borderWidth = 1
            object.layer.cornerRadius = 5.0
            object.clipsToBounds = true
        }
    }
    func cornerRadius(objects: [UIView],number: CGFloat){
        for object in objects{
            object.layer.cornerRadius = number
            object.clipsToBounds = true
        }
    }
    func centermsg(msg: String,view: UIView){
        let message = UILabel()
        message.text = msg
        message.translatesAutoresizingMaskIntoConstraints = false
        message.lineBreakMode = .byWordWrapping
        message.numberOfLines = 0
        message.textAlignment = .center
        message.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(message)
        
        message.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        message.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        message.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

//    func alertview(title: String,msg: String,dismisstitle: String,actiontitle: String,actionCompletion: @escaping()->()){
//        let alert = ZAlertView(title: title, message: msg, alertType: ZAlertView.AlertType.multipleChoice)
//        alert.addButton(actiontitle, font: UIFont.boldSystemFont(ofSize: 18), color: UIColor.orange, titleColor: UIColor.white) { (action) in
//            actionCompletion()
//            alert.dismissAlertView()
//        }
//        alert.addButton(dismisstitle, font: UIFont.boldSystemFont(ofSize: 18), color: UIColor.groupTableViewBackground, titleColor: UIColor.black) { (dismiss) in
//            alert.dismissAlertView()
//        }
//        alert.show()
//    }
    func content(title: String,body: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "Send", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    func dropdowninTextfield(fields: [UITextField]){
        for field in fields {
            let arrow = UIImageView(image: #imageLiteral(resourceName: "arrow-down-sign-to-navigate.png"))
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 30.0, height: size.height)
            }
            arrow.contentMode = UIView.ContentMode.center
            field.rightView = arrow
            field.rightViewMode = UITextField.ViewMode.always
        }
    }
    func setGradientBackground(view: UIView,color1: UIColor,color2: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color1.cgColor,color2.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame.size = view.frame.size
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    func goToHome(vc: UIViewController){
        let home = UIBarButtonItem(image: UIImage(named: "home"), style: .plain, target: self, action: #selector(goHomePage(vc:)))
        vc.navigationItem.leftItemsSupplementBackButton = true
        vc.navigationItem.rightBarButtonItem = home
    }
    @objc func goHomePage(vc: UIViewController){
        let LoggedByManager = UserDefaults.standard.bool(forKey: "LoggedByManager")
        if LoggedByManager == true{
            NotificationCenter.default.post(name: NSNotification.Name("managerHome"), object: self)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name("employeeHome"), object: self)
        }
    }
}
extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
extension String {
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]{2,}@[A-Za-z0-9.-]+\\.[A-Za-z]{3}$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    func isValidBloodGroup() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "(A|B|AB|O)[+-]", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9]{6,14}$";
        let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
        return valid
    }
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    var isValidIndianContact: Bool {
        let phoneNumberRegex = "^[7-9][0-9]{8,9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        return isValidPhone
    }
    //validate Password
    func isValidPassword() -> Bool {
        /*
         Minimum 8 characters at least 1 Alphabet and 1 Number:
         
         "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
         Minimum 8 characters at least 1 Alphabet, 1 Number and 1 Special Character:
         
         "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
         Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet and 1 Number:
         
         "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
         Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
         
         "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
         Minimum 8 and Maximum 10 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
         
         "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{8,10}"
 */
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }

}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer();
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y:self.frame.height - thickness, width:self.frame.width, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0, width: thickness, height: self.bounds.size.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x:self.frame.width - thickness, y: 0, width: thickness, height:self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}
extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIButton {
    func alignVertical(spacing: CGFloat = 6.0) {
        guard let imageSize = self.imageView?.image?.size,
            let text = self.titleLabel?.text,
            let font = self.titleLabel?.font
            else { return }
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font])
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
        self.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
    }
}
extension UIBarButtonItem {
    class func itemWith(colorfulImage: UIImage?, target: AnyObject, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(colorfulImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        button.imageEdgeInsets = UIEdgeInsets(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.tintColor = UIColor.white
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
}
extension UINavigationBar
{
    /// Applies a background gradient with the given colors
    func applyNavigationGradient( colors : [UIColor]) {
        var frameAndStatusBar: CGRect = self.bounds
        frameAndStatusBar.size.height += 20 // add 20 to account for the status bar
        
        setBackgroundImage(UINavigationBar.gradient(size: frameAndStatusBar.size, colors: colors), for: .default)
    }
    
    /// Creates a gradient image with the given settings
    static func gradient(size : CGSize, colors : [UIColor]) -> UIImage?
    {
        // Turn the colors into CGColors
        let cgcolors = colors.map { $0.cgColor }
        
        // Begin the graphics context
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        
        // If no context was retrieved, then it failed
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // From now on, the context gets ended if any return happens
        defer { UIGraphicsEndImageContext() }
        
        // Create the Coregraphics gradient
        var locations : [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgcolors as NSArray as CFArray, locations: &locations) else { return nil }
        
        // Draw the gradient
        context.drawLinearGradient(gradient, start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: size.width, y: 0.0), options: [])
        
        // Generate the image (the defer takes care of closing the context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
extension UISearchBar {
    
    private func getViewElement<T>(type: T.Type) -> T? {
        
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    func setTextFieldColor(color: UIColor) {
        
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
                
            case .prominent, .default:
                textField.backgroundColor = color
            }
        }
    }
}
extension Date
{
    
    func dateAt(hours: Int, minutes: Int) -> Date
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        //get the month/day/year componentsfor today's date.
        
        
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
}
//extension UIImage {
//    func toBase64() -> String? {
//        guard let imageData = self.UIImagePNGRepresentation() else { return nil }
//        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
//    }
//
//}
extension String {
    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }
    
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
extension StringProtocol {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        guard let first = first else { return "" }
        return String(first).capitalized + dropFirst()
    }
}
extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.endIndex.encodedOffset)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.endIndex.encodedOffset
        } else {
            return false
        }
    }
}
extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
}
extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
extension String {
    // Returns true if the String starts with a substring matching to the prefix-parameter.
    // If isCaseSensitive-parameter is true, the function returns false,
    // if you search "sA" from "San Antonio", but if the isCaseSensitive-parameter is false,
    // the function returns true, if you search "sA" from "San Antonio"
    
    func hasPrefixCheck(prefix: String, isCaseSensitive: Bool) -> Bool {
        
        if isCaseSensitive == true {
            return self.hasPrefix(prefix)
        } else {
            var thePrefix: String = prefix, theString: String = self
            
            while thePrefix.count != 0 {
                if theString.count == 0 { return false }
                if theString.lowercased().first != thePrefix.lowercased().first { return false }
                theString = String(theString.dropFirst())
                thePrefix = String(thePrefix.dropFirst())
            }; return true
        }
    }
    // Returns true if the String ends with a substring matching to the prefix-parameter.
    // If isCaseSensitive-parameter is true, the function returns false,
    // if you search "Nio" from "San Antonio", but if the isCaseSensitive-parameter is false,
    // the function returns true, if you search "Nio" from "San Antonio"
    func hasSuffixCheck(suffix: String, isCaseSensitive: Bool) -> Bool {
        
        if isCaseSensitive == true {
            return self.hasSuffix(suffix)
        } else {
            var theSuffix: String = suffix, theString: String = self
            
            while theSuffix.count != 0 {
                if theString.count == 0 { return false }
                if theString.lowercased().last != theSuffix.lowercased().last { return false }
                theString = String(theString.dropLast())
                theSuffix = String(theSuffix.dropLast())
            }; return true
        }
    }
    // Returns true if the String contains a substring matching to the prefix-parameter.
    // If isCaseSensitive-parameter is true, the function returns false,
    // if you search "aN" from "San Antonio", but if the isCaseSensitive-parameter is false,
    // the function returns true, if you search "aN" from "San Antonio"
    func containsSubString(theSubString: String, isCaseSensitive: Bool) -> Bool {
        
        if isCaseSensitive == true {
            return self.range(of: theSubString) != nil
        } else {
            return self.range(of: theSubString, options: .caseInsensitive) != nil
        }
    }
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

extension UIButton {
    func image_rightAlingment(){
        self.imageEdgeInsets = UIEdgeInsets(top: 15, left: (bounds.width - 5), bottom: 15, right: 5)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
    }
}
