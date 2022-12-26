//
//  BookViewCell.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/26.
//

import UIKit
import SnapKit
import Then

class BookViewCell: UICollectionViewCell {
    
    // 책 이미지
    lazy var bookPosterImage = UIImageView().then {
        // 그때 그떄 정할 예정 일단 기본이미지.
        $0.image = UIImage(named: "noimage")
        $0.contentMode = .scaleAspectFit
    }
    
    // 포스터 제목
    lazy var bookPosterLabel = UILabel().then {
        $0.text = "책 제목"
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 13, weight: .bold)
    }
    
    // 본날짜.
    lazy var bookDateLabel = UILabel().then {
        $0.text = "2022년 12월 24일 토요일"
        $0.textColor = .black
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 11, weight: .medium)
    }
    
    // 평점 한글
    lazy var bookPosterRatingLabel = UILabel().then {
        $0.text = "내가 준 평점"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 11, weight: .medium)
    }
    
    // 평점 숫자
    lazy var bookPosterRating = UILabel().then {
        $0.text = "8.98"
        $0.textColor = .yearTextColor
        $0.font = .systemFont(ofSize: 11, weight: .medium)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bookPosterImage)
        bookPosterImage.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            $0.height.equalTo(158)
        }
        
        addSubview(bookPosterLabel)
        bookPosterLabel.snp.makeConstraints {
            $0.top.equalTo(bookPosterImage.snp.bottom)
            $0.left.equalToSuperview().inset(5)
            $0.right.equalToSuperview().inset(5)
        }
        
        addSubview(bookDateLabel)
        bookDateLabel.snp.makeConstraints {
            $0.top.equalTo(bookPosterLabel.snp.bottom).offset(2)
            $0.left.equalTo(bookPosterLabel.snp.left)
        }
        
        addSubview(bookPosterRatingLabel)
        bookPosterRatingLabel.snp.makeConstraints {
            $0.top.equalTo(bookDateLabel.snp.bottom).offset(2)
            $0.left.equalTo(bookPosterLabel.snp.left)
        }
        
        addSubview(bookPosterRating)
        bookPosterRating.snp.makeConstraints {
            $0.top.equalTo(bookDateLabel.snp.bottom).offset(2)
            $0.left.equalTo(bookPosterRatingLabel.snp.right).offset(2)
        }

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
