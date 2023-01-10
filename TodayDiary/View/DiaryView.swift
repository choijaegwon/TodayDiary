//
//  DiaryView.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/13.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class DiaryView: UIView {

    private var mood = Mood()
    
    private let questionLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.text = "오늘은 어떤 하루를 보내셨나요?"
    }
    
    var moodImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    // 둥근뷰
    private lazy var labelBackgorund = UIView().then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .labelBackgroundColor
    }
    
    // 버튼의 기분 텍스트
    var selectedButtonLable = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.text = "좋은 일만 있었어요"
    }
    
    var textView = UITextView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.tintColor = .black
        $0.textColor = .black
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.black.cgColor
        $0.placeholder = "상세한 내용을 적어보세요"
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    
    lazy var upDateButton = UIButton().then {
        $0.setTitle("수정", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configurUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurUI() {
        addSubview(questionLabel)
        addSubview(moodImageView)
        addSubview(labelBackgorund)
        addSubview(textView)
        addSubview(upDateButton)

        questionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.centerX.equalToSuperview()
        }
        
        moodImageView.snp.makeConstraints {
            $0.height.width.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(questionLabel).offset(50)
        }
        
        labelBackgorund.addSubview(selectedButtonLable)
        
        labelBackgorund.snp.makeConstraints {
            $0.width.equalTo(selectedButtonLable.snp.width).offset(20)
            $0.height.equalTo(selectedButtonLable.snp.height).offset(14)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(moodImageView.snp.bottom).offset(23)
        }
        
        selectedButtonLable.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(labelBackgorund.snp.bottom).offset(25)
            make.width.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
            make.centerX.equalToSuperview()
        }
        
        upDateButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(40)
            make.bottom.equalToSuperview().inset(100)
            make.width.equalTo(textView.snp.width)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
        }
        
    }
    
}

