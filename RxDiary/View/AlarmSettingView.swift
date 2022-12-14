//
//  AlarmSettingView.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/14.
//

import UIKit
import Then
import SnapKit

class AlarmSettingView: UIView {
    
    lazy var backView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var title = UILabel().then {
        $0.text = "알림"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    lazy var subTitle = UILabel().then {
        $0.text = "원하는 시간에 알림을 받을 수 있어요."
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .todayContentsColor
    }
    
    lazy var timeBackView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .labelBackgroundColor
    }
    
    lazy var timeTitle = UILabel().then {
        $0.text = "시간 설정"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    lazy var time = UILabel().then {
        $0.text = "오전 11:30"
    }
    
    lazy var timeRightImage = UIImageView().then {
        $0.image = UIImage(named: "alarmRight")
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(backView)
        backView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        let titleStack = UIStackView(arrangedSubviews: [title, subTitle])
        titleStack.axis = .vertical
        titleStack.spacing = 4
        
        backView.addSubview(titleStack)
        titleStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0))
        }
        
        addSubview(timeBackView)
        timeBackView.snp.makeConstraints {
            $0.top.equalTo(titleStack.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.left.equalTo(titleStack.snp.left)
            $0.right.equalTo(titleStack.snp.right)
            $0.height.equalTo(64)
        }
        
        timeBackView.addSubview(timeTitle)
        timeTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0))
        }
        
        timeBackView.addSubview(timeRightImage)
        timeRightImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(25)
            $0.width.height.equalTo(15)
        }
        
        timeBackView.addSubview(time)
        time.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(timeRightImage.snp.left).offset(-15)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
