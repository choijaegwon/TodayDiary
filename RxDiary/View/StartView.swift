//
//  StartView.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/21.
//

import RxSwift
import RxCocoa
import UIKit
import FSCalendar
import SnapKit
import Then

class StartView: UIView {
    
    lazy var headerMonthLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 25, weight: .bold)
        $0.text = "11월"
        $0.textColor = .todayContentsColor
    }
    
    lazy var headerSumLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 25, weight: .bold)
        $0.text = "2"
    }
    
    lazy var headerLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 25, weight: .bold)
        $0.text = "개의 각"
        $0.textColor = .todayContentsColor
    }
    
    private lazy var labelBackgorund = UIView().then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .labelBackgroundColor
    }
    
    private lazy var sumLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .bold)
        $0.text = "총"
    }
    
    lazy var sumLabel1 = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .bold)
        $0.text = "2"
    }
    
    private lazy var sumLabel2 = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .medium)
        $0.text = "번의 기분 상하는 일이 있었네요."
    }
    
    lazy var monthImage = UIImageView().then {
        $0.image = UIImage(named: "mood0")
    }
    
    lazy var monthLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.text = "정말 최고로 둥근"
    }
    
    lazy var monthLabel2 = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.text = "한 달을 보내셨네요!"
    }
    
    lazy var fixLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.text = "우리 이번 달도 둥근 달을 만들어봐요!"
        $0.textColor = .todayContentsColor
    }
    
    lazy var dismissbutton = UIButton().then {
        $0.setTitle("이번 달도 파이팅 할게요!", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.black
        $0.tintColor = UIColor.white
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let headerStack = UIStackView(arrangedSubviews: [headerSumLabel, headerLabel])
        headerStack.axis = .horizontal
        headerStack.spacing = 0

        let headerFullStack = UIStackView(arrangedSubviews: [headerMonthLabel, headerStack])
        headerFullStack.axis = .horizontal
        headerFullStack.spacing = 8

        addSubview(headerFullStack)
        headerFullStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(100)
        }
        
        let sumStack = UIStackView(arrangedSubviews: [sumLabel1, sumLabel2])
        sumStack.axis = .horizontal
        sumStack.spacing = 0
        
        let sumFullStack = UIStackView(arrangedSubviews: [sumLabel, sumStack])
        sumFullStack.axis = .horizontal
        sumFullStack.spacing = 4
        
        addSubview(labelBackgorund)
        labelBackgorund.addSubview(sumFullStack)
        
        labelBackgorund.snp.makeConstraints {
            $0.top.equalTo(headerFullStack.snp.bottom).offset(11)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(sumFullStack.snp.width).offset(16)
            $0.height.equalTo(sumFullStack.snp.height).offset(16)
        }
        
        sumFullStack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        addSubview(monthImage)
        monthImage.snp.makeConstraints {
            $0.top.equalTo(sumFullStack.snp.bottom).offset(40)
            $0.width.height.equalTo(240)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(monthLabel)
        monthLabel.snp.makeConstraints {
            $0.top.equalTo(monthImage.snp.bottom).offset(34)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(monthLabel2)
        monthLabel2.snp.makeConstraints {
            $0.top.equalTo(monthLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(fixLabel)
        fixLabel.snp.makeConstraints {
            $0.top.equalTo(monthLabel2.snp.bottom).offset(93)
            $0.centerX.equalToSuperview()
        }
//18
        addSubview(dismissbutton)
        dismissbutton.snp.makeConstraints {
            $0.top.equalTo(fixLabel.snp.bottom).offset(18)
            $0.width.equalTo(327)
            $0.height.equalTo(52)
            $0.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

