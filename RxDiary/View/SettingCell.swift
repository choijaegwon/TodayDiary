//
//  SettingCell.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/14.
//

import UIKit
import SnapKit
import Then

class SettingCell: UITableViewCell {
    
    lazy var alarmImage = UIImageView().then {
        $0.image = UIImage(named: "alarm")
    }
    
    lazy var title = UILabel().then {
        $0.text = "알람"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    lazy var alarmRightImage = UIImageView().then {
        $0.image = UIImage(named: "alarmRight")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(alarmImage)
        addSubview(title)
        addSubview(alarmRightImage)
        
        alarmImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(25)
            $0.left.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0))
        }
        
        title.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(alarmImage.snp.right).offset(20)
            $0.right.equalTo(alarmRightImage.snp.left).offset(20)
        }
        
        alarmRightImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(15)
            $0.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 26))
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
