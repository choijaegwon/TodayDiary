//
//  EmptyBookView.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/26.
//

import UIKit
import SnapKit
import Then

class EmptyBookView: UIView {
    
    private let emptyLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 22)
        $0.text = "아직 추가된 책이 없어요."
        $0.textColor = .todayContentsColor
    }
    
    private let emptySmallLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.text = "책 후기를 남겨주세요."
        $0.textColor = .yearTextColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        addSubview(emptySmallLabel)
        emptySmallLabel.snp.makeConstraints {
            $0.top.equalTo(emptyLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
