//
//  MainViewModel.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/10.
//

import Foundation
import RxCocoa
import RxSwift
import RxRealm
import RealmSwift

class MainViewModel {
    
    private let realm = try! Realm()
    private lazy var diary = self.realm.objects(Diary.self)
    
    lazy var headerYearLabel = BehaviorRelay(value: nowYearLabel)
    lazy var headerMonthLabel = BehaviorRelay(value: nowMonthLabel)
    lazy var mainSumMood = BehaviorRelay(value: "0")
    lazy var readRealmDateString = BehaviorRelay(value: nowYearMonthLabel)
    
    // realm에서 가지고있는 배열가져오기
    lazy var diaryObservable = Observable.collection(from: diary)
    lazy var sortedDiaryObservable =  readRealmDateString
        .flatMap { (filterDate: String) -> Observable<Results<Diary>> in
            return self.diaryObservable
                            .map { $0.sorted(byKeyPath: "date", ascending: true) // 오름차순 정렬
                            .filter(NSPredicate(format: "date like '\(filterDate)**'")) } // readRealmDateString이 가져온 값
        }
    
    // 달의 개수의 합
    lazy var sumMood = mainSumMood.flatMap { (b: String) -> Observable<String> in
        return self.sortedDiaryObservable.map { Array($0) }.map {
            var moods = $0.map { $0.mood }
            return String(moods.reduce(0) { $0 + $1 })
        }
    }
    
    
//    lazy var sortedDiaryObservable = self.diaryObservable.map { diary in
//        return diary.sorted(byKeyPath: "date", ascending: true)
//    }
    
    private let dateFormatter = DateFormatter()
    private lazy var nowYearLabel = nowYear()
    private lazy var nowMonthLabel = nowMonth()
    private lazy var nowYearMonthLabel = nowYearMonth()
    
    let headerYearDateFormatter = DateFormatter().then {
        $0.dateFormat = "YYYY"
        $0.locale = Locale(identifier: "ko_kr")
        $0.timeZone = TimeZone(identifier: "KST")
    }
    
    // 현재 년도
    private func nowYear() -> String {
        return self.headerYearDateFormatter.string(from: Date())
    }
    
    let monthDateFormatter = DateFormatter().then {
        $0.dateFormat = "MM월"
        $0.locale = Locale(identifier: "ko_kr")
        $0.timeZone = TimeZone(identifier: "KST")
    }
    
    // mainSumMood에다가 현재 달의 감정개수를 필터링해서 그걸 보여주는걸해야한다.
    // 배열값을 BehaviorSubject로 받고, .map 써서 객체하나를꺼내고, .map써서 객체안을 접근해가면된다.
    
    
    let filterDateDateFormatter = DateFormatter().then {
        $0.dateFormat = "YYYYMM"
        $0.locale = Locale(identifier: "ko_kr")
        $0.timeZone = TimeZone(identifier: "KST")
    }
    
    // 현재년도와 달
    private func nowYearMonth() -> String {
        return self.filterDateDateFormatter.string(from: Date())
    }
    
    // 현재 달
    private func nowMonth() -> String {
        return self.monthDateFormatter.string(from: Date())
    }
    
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    
    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
}
