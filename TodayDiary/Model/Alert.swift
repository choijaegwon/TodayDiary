//
//  Alert.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/19.
//

import RealmSwift

class Alert: Object {
    @Persisted var id: String = "1"
    @Persisted var date: Date
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
