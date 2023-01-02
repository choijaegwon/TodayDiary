//
//  BookMainViewModel.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2023/01/03.
//

import Foundation
import RxCocoa
import RxSwift
import RxRealm
import RealmSwift

class BookMainViewModel {
    private let realm = try! Realm()
    private lazy var book = self.realm.objects(RealmBook.self)
    
    // realm에서 가지고있는 배열가져오기
    lazy var realmBookObservable = Observable.collection(from: book).map { $0.sorted(byKeyPath: "bookDate", ascending: false) }
    
    // 전체 값을 가져오는 Observable.
    lazy var fullRealmBookObservable = realmBookObservable.map { $0.sorted(byKeyPath: "bookDate", ascending: false) }
    
}
