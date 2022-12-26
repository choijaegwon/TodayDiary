//
//  MainView.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/10.
//

import RxSwift
import RxCocoa
import UIKit
import FSCalendar
import SnapKit
import Then

class MainView: UIView {
    
    lazy var calendar: FSCalendar = {
        let calendar = FSCalendar(frame: .zero)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.backgroundColor = .white
        calendar.calendarHeaderView.isHidden = true
        calendar.headerHeight = 100
        calendar.scrollEnabled = true
        calendar.scrollDirection = .horizontal
        calendar.placeholderType = .none
        calendar.appearance.titleSelectionColor = .black
        calendar.appearance.selectionColor = .clear
        calendar.appearance.todaySelectionColor = .todayColor
        calendar.appearance.todayColor = .todayColor
        calendar.calendarWeekdayView.isHidden = true
        return calendar
    }()
    
    lazy var headerYearLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.textColor = .yearTextColor
    }
    
    lazy var headerMonthLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 25, weight: .bold)
        $0.textColor = .black
    }
    
    lazy var leftButton = UIButton().then {
        $0.setImage(UIImage(named: "leftArrow"), for: .normal)
    }
    
    lazy var rightButton = UIButton().then {
        $0.setImage(UIImage(named: "rightArrow"), for: .normal)
    }
    
    private lazy var labelBackgorund = UIView().then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .labelBackgroundColor
    }
    
    private let moodMainImage = UIImageView().then {
        $0.image = UIImage(named: "moodMainImage")
    }
    
    lazy var monthLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .medium)
        $0.textColor = .black
    }
    
    private lazy var sumLabel1 = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .medium)
        $0.text = "지금까지"
    }
    
    lazy var sumMood = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .bold)
    }
    
    private lazy var sumLabel2 = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .medium)
        $0.text = "개의 각이 생겼어요."
    }
    
    private let mainquestionBackgourndView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 10
        $0.layer.shadowOpacity = 0.3
        $0.backgroundColor = UIColor.white
    }
    
    // 오늘의 데이터가 있으면 그 데이터로 button이 바뀌어야줘야한다. 또는
    // 오늘의 데이터가 있으면 이버튼은 hidden으로 숨겨주고 다른 뷰를 띄우게하기.
    lazy var mainquestionbutton = UIButton().then {
        $0.setTitle("오늘은 어떤 하루를 보내셨나요?", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.black
        $0.tintColor = UIColor.white
    }
    
    // 오늘 일 배경
    lazy var todayBackgorund = UIView().then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .labelBackgroundColor
    }
    
    lazy var todayMoodImage = UIImageView().then {
        // 그때 그떄 정할 예정 일단 기본이미지.
        $0.image = UIImage(named: "0")
    }
    
    lazy var todayMoodLabel = UILabel().then {
        $0.text = "테스트용 라벨 "
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    lazy var todayContentsLabel = UILabel().then {
        $0.text = "테스트용 컨텐츠 라벨테스트용 컨텐츠 라벨테스트용 컨텐츠 라벨테스트용 컨텐츠 라벨테스트용 컨텐츠 라벨"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 13, weight: .medium)
        $0.textColor = .todayContentsColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        
        addSubview(headerYearLabel)
        addSubview(headerMonthLabel)
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(mainquestionBackgourndView)
        addSubview(mainquestionbutton)
        addSubview(todayBackgorund)
        todayBackgorund.addSubview(todayMoodImage)
        
        let monthStack = UIStackView(arrangedSubviews: [leftButton, headerMonthLabel, rightButton])
        monthStack.axis = .horizontal
        monthStack.spacing = 8
        
        addSubview(monthStack)
        
        let moonrightTextStack = UIStackView(arrangedSubviews: [sumMood, sumLabel2])
        monthStack.axis = .horizontal
        monthStack.spacing = 0
        
        let moonSumStack = UIStackView(arrangedSubviews: [moodMainImage, monthLabel, sumLabel1, moonrightTextStack])
        moonSumStack.axis = .horizontal
        moonSumStack.spacing = 4
        
        labelBackgorund.addSubview(moonSumStack)
        addSubview(calendar)
        calendar.addSubview(labelBackgorund)
        
        let todayStack = UIStackView(arrangedSubviews: [todayMoodLabel, todayContentsLabel])
        todayStack.axis = .vertical
        todayStack.spacing = 4
        
        todayBackgorund.addSubview(todayStack)
        
        headerYearLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            $0.centerX.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
        
        headerMonthLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
        
        monthStack.snp.makeConstraints {
            $0.top.equalTo(headerYearLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        labelBackgorund.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.top).offset(70)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(moonSumStack.snp.width).offset(16)
            $0.height.equalTo(moonSumStack.snp.height).offset(16)
        }
        
        moonSumStack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        calendar.snp.makeConstraints {
            $0.top.equalTo(monthStack.snp.bottom).offset(0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(390)
            $0.width.equalToSuperview()
        }
        
        mainquestionBackgourndView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(135)
            $0.bottom.equalToSuperview()
        }
        
        mainquestionbutton.snp.makeConstraints {
            $0.width.equalTo(327)
            $0.height.equalTo(52)
            $0.top.equalTo(mainquestionBackgourndView.snp.top).offset(22)
            $0.centerX.equalToSuperview()
        }
        
        todayBackgorund.snp.makeConstraints {
            $0.top.equalTo(mainquestionBackgourndView.snp.top).offset(22)
            $0.width.equalTo(327)
            $0.height.equalTo(68)
            $0.centerX.equalToSuperview()
        }
        
        todayMoodImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(40)
            $0.left.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 0))
        }
        
        todayStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(todayMoodImage.snp.right).offset(13)
            $0.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15))
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
