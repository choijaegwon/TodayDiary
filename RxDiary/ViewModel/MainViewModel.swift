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
    lazy var headerYearLabel = BehaviorRelay(value: nowYearLabel)
    lazy var headerMonthLabel = BehaviorRelay(value: nowMonthLabel)
    lazy var mainSumMood = BehaviorRelay(value: "0")
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
    
    // mainSumMood에다가 현재 달의 감정개수를 필터링해서 그걸 보여주는걸해야한다.
    // 배열값을 BehaviorSubject로 받고, .map 써서 객체하나를꺼내고, .map써서 객체안을 접근해가면된다.
    
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
