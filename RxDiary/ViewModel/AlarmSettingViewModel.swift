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
    
    lazy var timeLabel = BehaviorRelay(value: nowTimeLabel)
    lazy var buttonState = BehaviorRelay(value: false)
    
    // 이용 현재시간구하기
    private lazy var nowTimeLabel = nowTime()
    
    // 현재 년도
    private func nowTime() -> String {
        return self.nowTimeDateFormatter.string(from: Date())
    }
    
    // 포메텅
    let nowTimeDateFormatter = DateFormatter().then {
        $0.dateStyle = .none
        $0.timeStyle = .short
    }
    
}
