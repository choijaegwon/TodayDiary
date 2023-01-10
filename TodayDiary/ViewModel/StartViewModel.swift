//
//  StartViewModel.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/21.
//

import Foundation
import RxCocoa
import RxSwift
import RxRealm
import RealmSwift

class StartViewModel {
    private var disposeBag = DisposeBag()
    private let realm = try! Realm()
    private lazy var diary = self.realm.objects(Diary.self)

    // 월
    lazy var headerMonthLabel = BehaviorRelay(value: lastMonthLabel)
    // 개수
    lazy var sumMood = BehaviorRelay(value: "0")
    
    lazy var readRealmDateString = BehaviorRelay(value: lastYearMonthLabel)

    // realm에서 가지고있는 배열가져오기
    lazy var diaryObservable = Observable.collection(from: diary).map { $0.sorted(byKeyPath: "date", ascending: true) }
    
    // 특정 달만 가져오는 Observable.
    lazy var sortedDiaryObservable =  readRealmDateString
        .flatMap { (filterDate: String) -> Observable<Results<Diary>> in
            return self.diaryObservable
                            .map { $0.sorted(byKeyPath: "date", ascending: true) // 오름차순 정렬
                            .filter(NSPredicate(format: "date like '\(filterDate)**'")) } // readRealmDateString이 가져온 값
        }
    
    // 달의 개수의 합
    lazy var lastSumMood = sumMood.flatMap { (b: String) -> Observable<String> in
        return self.sortedDiaryObservable.map { Array($0) }.map {
            var moods = $0.map { $0.mood }
            return String(moods.reduce(0) { $0 + $1 })
        }
    }
    
    //
    private lazy var lastMonthLabel = lastMonth()
    private lazy var lastYearMonthLabel = lastYearMonth()
    
    // 지난달  그 이유는 이뷰는 01일에만 보여줄 뷰니까 하루전을 대입하면 될것같다
    private func lastMonth() -> String {
        return self.monthDateFormatter.string(from: Date(timeIntervalSinceNow: -86400))
    }
    
    private let monthDateFormatter = DateFormatter().then {
        $0.dateFormat = "MM월"
        $0.locale = Locale(identifier: "ko_kr")
        $0.timeZone = TimeZone(identifier: "KST")
    }
    
    // 지난년도와 지난달
    private func lastYearMonth() -> String {
        return self.filterDateDateFormatter.string(from: Date(timeIntervalSinceNow: -86400))
    }
    
    let filterDateDateFormatter = DateFormatter().then {
        $0.dateFormat = "YYYYMM"
        $0.locale = Locale(identifier: "ko_kr")
        $0.timeZone = TimeZone(identifier: "KST")
    }
}
