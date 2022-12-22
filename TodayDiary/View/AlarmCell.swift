//
//  AlarmCell.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/14.
//

import UIKit
import SnapKit
import Then

class AlarmCell: UITableViewCell {
    
    lazy var title = UILabel().then {
        $0.text = "알림"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    lazy var subTitle = UILabel().then {
        $0.text = "원하는 시간에 알림을 받을 수 있어요."
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .todayContentsColor
    }
    
//    lazy var alarmRightImage = UIImageView().then {
//        $0.image = UIImage(named: "alarmRight")
//    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let titleStack = UIStackView(arrangedSubviews: [title, subTitle])
        titleStack.axis = .vertical
        titleStack.spacing = 4
        
        addSubview(titleStack)
        titleStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0))
        }

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
