//
//  MovieViewCell.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/25.
//

import UIKit
import SnapKit
import Then

class MovieViewCell: UICollectionViewCell {
    
    // 포스터 이미지
    lazy var moviePosterImage = UIImageView().then {
        $0.image = UIImage(named: "noimage")
        $0.contentMode = .scaleAspectFit
    }
    
    // 포스터 제목
    lazy var moviePosterLabel = UILabel().then {
        $0.text = "영화 제목"
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 13, weight: .bold)
    }

    // 본날짜.
    lazy var movieDateLabel = UILabel().then {
        $0.text = "2022년 12월 24일 토요일"
        $0.textAlignment = .center
        $0.textColor = .black
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 11, weight: .medium)
    }
    
    // 평점 한글
    lazy var moviePosterRatingLabel = UILabel().then {
        $0.text = "내가 준 평점"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 11, weight: .medium)
    }
    
    // 평점 숫자
    lazy var moviePosterRating = UILabel().then {
        $0.text = "8.98"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 11, weight: .medium)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(moviePosterImage)
        
        let moviewLabelStack = UIStackView(arrangedSubviews: [moviePosterLabel, movieDateLabel])
        moviewLabelStack.axis = .vertical
        moviewLabelStack.spacing = 2
        addSubview(moviewLabelStack)
        
        moviePosterImage.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            $0.height.equalTo(158)
        }
        
        moviewLabelStack.snp.makeConstraints {
            $0.top.equalTo(moviePosterImage.snp.bottom)
            $0.left.equalToSuperview().inset(5)
            $0.right.equalToSuperview().inset(5)
        }
        
        addSubview(moviePosterRatingLabel)
        moviePosterRatingLabel.snp.makeConstraints {
            $0.top.equalTo(moviewLabelStack.snp.bottom).offset(2)
            $0.left.equalTo(moviewLabelStack.snp.left)
        }
        
        addSubview(moviePosterRating)
        moviePosterRating.snp.makeConstraints {
            $0.top.equalTo(moviewLabelStack.snp.bottom).offset(2)
            $0.right.equalTo(moviewLabelStack.snp.right)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
