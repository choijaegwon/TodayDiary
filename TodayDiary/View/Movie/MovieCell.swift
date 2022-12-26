//
//  MovieCell.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/24.
//

import UIKit
import SnapKit
import Then

class MovieCell: UICollectionViewCell {
    
    // 포스터 이미지
    lazy var moviePosterImage = UIImageView().then {
        // 그때 그떄 정할 예정 일단 기본이미지.
        $0.image = UIImage(named: "testImage")
        $0.contentMode = .scaleAspectFit
    }
    
    // 포스터 제목
    lazy var moviePosterLabel = UILabel().then {
        $0.text = "영화 제목"
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 13, weight: .bold)
    }
    
    // 출시년도
    lazy var moviePosterYear = UILabel().then {
        $0.text = "2022"
        $0.textColor = .yearTextColor
        $0.font = .systemFont(ofSize: 11, weight: .medium)
    }
    
    // 평점 한글
    lazy var moviePosterRatingLabel = UILabel().then {
        $0.text = "평점"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 11, weight: .medium)
    }
    
    // 평점 숫자
    lazy var moviePosterRating = UILabel().then {
        $0.text = "8.98"
        $0.textColor = .yearTextColor
        $0.font = .systemFont(ofSize: 11, weight: .medium)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(moviePosterImage)
        
        let posterRatingStack = UIStackView(arrangedSubviews: [moviePosterRatingLabel, moviePosterRating])
        posterRatingStack.axis = .horizontal
        posterRatingStack.spacing = 2
        
        let moviewLabelStack = UIStackView(arrangedSubviews: [moviePosterLabel, moviePosterYear, posterRatingStack])
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
            $0.right.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
