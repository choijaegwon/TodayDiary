//
//  Diary.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/12.
//

import RealmSwift

class Diary: Object {
    @Persisted var date: String = "20220202"
    @Persisted var mood: Int = 0
    @Persisted var contents: String = ""
    
//    override static func primaryKey() -> String? {
//        return "date"
//    }
}
