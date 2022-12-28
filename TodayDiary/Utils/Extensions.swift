//
//  Extensions.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/10.
//

import UIKit
import DLRadioButton
import UserNotifications

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    class var todayColor: UIColor? { return UIColor(named: "todayColor")}
    class var yearTextColor: UIColor? { return UIColor(named: "yearTextColor") }
    class var labelBackgroundColor: UIColor? { return UIColor(named: "labelBackgroundColor")}
    class var todayContentsColor: UIColor? { return UIColor(named: "todayContentsColor")}
    class var switchColor: UIColor? { return UIColor(named: "switchColor")}
    class var cellHeaderBGColor: UIColor? { return UIColor(named: "cellHeaderBGColor")}
    class var mbTextColor: UIColor? { return UIColor(named: "mbTextColor")}
}

extension UIButton {
    func moodButton(icon: String, iconSelected: String) -> DLRadioButton {
        let button = DLRadioButton(type: .custom)
        button.icon = UIImage(named: icon)!
        button.iconSelected = UIImage(named: iconSelected)!
        button.backgroundColor = .white
        button.tintColor = .white
        return button
    }
}

extension UNUserNotificationCenter {
    func addNotificationRequest(by alert: Alert) {
        let content = UNMutableNotificationContent()
        content.title = "각없는 오늘"
        content.body = "오늘은 어떤 하루를 보내셨나요?"
        content.sound = .default
        content.badge = 1
        
        let component = Calendar.current.dateComponents([.hour, .minute], from: alert.date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
        
        let request = UNNotificationRequest(identifier: alert.id, content: content, trigger: trigger)
        self.add(request, withCompletionHandler: nil)
    }
}
