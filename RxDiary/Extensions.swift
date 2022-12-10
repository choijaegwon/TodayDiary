//
//  Extensions.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/10.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    class var yearTextColor: UIColor? { return UIColor(named: "yearTextColor") }
    class var labelBackgroundColor: UIColor? { return UIColor(named: "labelBackgroundColor")}
}
