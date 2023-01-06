//
//  DiaryCell.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/20.
//

import UIKit
import SnapKit
import Then

class DiaryCell: UITableViewCell {
    
    lazy var dateLabel = UILabel().then {
        $0.textColor = .yearTextColor
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.text = "24" 
    }
    
    lazy var cellBackgorund = UIView().then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .labelBackgroundColor
    }
    
    lazy var moodImage = UIImageView().then {
        $0.image = UIImage(named: "0")
    }
    
    lazy var moodLabel = UILabel().then {
        $0.text = "테스트용 라벨 "
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    lazy var contentsLabel = UILabel().then {
        $0.text = "테스트용 컨텐츠 라벨테스트용 컨텐츠 라벨테스트용 컨텐츠 라벨테스트용 컨텐츠 라벨테스트용 컨텐츠 라벨"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 13, weight: .medium)
        $0.textColor = .todayContentsColor
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(dateLabel)
        addSubview(cellBackgorund)
        cellBackgorund.addSubview(moodImage)
        
        let cellStack = UIStackView(arrangedSubviews: [moodLabel, contentsLabel])
        cellStack.axis = .vertical
        cellStack.spacing = 4
        
        cellBackgorund.addSubview(cellStack)
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(20)
        }
        
        // cellBackgorund의 크기는 cellStack이 결정해준다이걸 이용해야한다.
        cellBackgorund.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.greaterThanOrEqualTo(295)
            $0.height.equalTo(68)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.equalTo(dateLabel.snp.right).offset(16)
            $0.right.equalToSuperview().inset(16)
        }
        
        moodImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(40)
            $0.left.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 0))
        }
        
        cellStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(moodImage.snp.right).offset(13)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
