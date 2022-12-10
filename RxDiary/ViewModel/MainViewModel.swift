//
//  MainViewModel.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/10.
//

import Foundation
import RxCocoa
import RxSwift

class MainViewModel {
    
//    lazy var headerYearLabel = PublishSubject<String>()
    lazy var headerYearLabel = BehaviorSubject(value: nowYearLabel)
    lazy var headerMonthLabel = BehaviorSubject(value: nowMonthLabel)
    lazy var mainSumMood = BehaviorSubject(value: "0")
    private let dateFormatter = DateFormatter()
    
    private lazy var nowYearLabel = nowYear()
    private lazy var nowMonthLabel = nowMonth()
    
    let headerYearDateFormatter = DateFormatter().then {
        $0.dateFormat = "YYYY"
        $0.locale = Locale(identifier: "ko_kr")
        $0.timeZone = TimeZone(identifier: "KST")
    }
    
    // 현재 년도
    private func nowYear() -> String {
        return self.headerYearDateFormatter.string(from: Date())
    }
    
    let MonthDateFormatter = DateFormatter().then {
        $0.dateFormat = "MM월"
        $0.locale = Locale(identifier: "ko_kr")
        $0.timeZone = TimeZone(identifier: "KST")
    }
    
    // 현재 달
    private func nowMonth() -> String {
        return self.MonthDateFormatter.string(from: Date())
    }
    
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    
    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    

}
