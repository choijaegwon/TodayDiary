//
//  SettingView.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/23.
//

import UIKit
import Then
import SnapKit

class SettingView: UIView {
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(reviewbutton)
        reviewbutton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(135)
            $0.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
