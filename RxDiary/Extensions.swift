//
//  Extensions.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/10.
//

import UIKit
import DLRadioButton

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    class var todayColor: UIColor? { return UIColor(named: "todayColor")}
    class var yearTextColor: UIColor? { return UIColor(named: "yearTextColor") }
    class var labelBackgroundColor: UIColor? { return UIColor(named: "labelBackgroundColor")}
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
