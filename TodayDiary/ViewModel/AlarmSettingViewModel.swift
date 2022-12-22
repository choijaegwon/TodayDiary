//
//  AlarmSettingViewModel.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/15.
//

import Foundation
import RxCocoa
import RxSwift
import RxRealm
import RealmSwift

class AlarmSettingViewModel {
    
    lazy var timeLabel = BehaviorRelay(value: timeLabels)
    lazy var buttonState = BehaviorRelay(value: alertisEmpty)
    
    let realm = try! Realm()
    lazy var alert = self.realm.objects(Alert.self)
    var alerts: [Alert] = []
    
    // 이용 현재시간구하기
    private lazy var nowTimeLabel = nowTime()
    // realm에 있는 시간 넣어주기
    private lazy var timeLabels = realmTime()
    // 알람이 있는지 없는지 확인하기
    lazy var alertisEmpty = alertIsEmpty()
    
    
    // 현재 년도
    private func nowTime() -> String {
        return self.nowTimeDateFormatter.string(from: Date())
    }
    
    // 포메텅
    let nowTimeDateFormatter = DateFormatter().then {
        $0.dateStyle = .none
        $0.timeStyle = .short
    }
    
    // 포메텅
    let timeDateFormatter = DateFormatter().then {
        $0.dateStyle = .none
        $0.timeStyle = .short
    }
    
    // relam에서 데이터확인후 알람이 있으면 true 없으면 false를 리턴해줌.
    private func alertIsEmpty() -> Bool {
        self.alerts = Array(self.alert)
        if alerts.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    // relam에있는 데이터 객체에서 시간 가져오기.
    private func realmTime() -> String {
        self.alerts = Array(self.alert)
        if alerts.isEmpty {
            // 비어있으면 현재시간 넣어주기
            return self.nowTimeLabel
        } else {
            // 알람이 있으면 시간 가져오기
            return self.timeDateFormatter.string(from: alert.first!.date)
        }
    }
}
