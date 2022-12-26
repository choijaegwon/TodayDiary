//
//  MovieMainViewModel.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/25.
//

import Foundation
import RxCocoa
import RxSwift
import RxRealm
import RealmSwift

class MovieMainViewModel {
    private let realm = try! Realm()
    private lazy var movie = self.realm.objects(RealmMoive.self)
    
    // realm에서 가지고있는 배열가져오기
    lazy var realmMoiveObservable = Observable.collection(from: movie).map { $0.sorted(byKeyPath: "movieDate", ascending: false) }
    
    // 전체 값을 가져오는 Observable.
    lazy var fullRealmMoiveObservable = realmMoiveObservable.map { $0.sorted(byKeyPath: "movieDate", ascending: false) }
    
}
