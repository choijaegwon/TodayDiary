//
//  BookCell.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/26.
//

import UIKit
import SnapKit
import Then

// 검색했을때, 뜨는 cell
class BookCell: UICollectionViewCell {
    
    // 포스터 이미지
    lazy var bookPosterImage = UIImageView().then {
        $0.image = UIImage(named: "noimage")
        $0.contentMode = .scaleAspectFit
    }
    
    // 책 제목
    lazy var bookPosterLabel = UILabel().then {
        $0.text = "책 제목"
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 13, weight: .bold)
    }
    
    // 책 저자
    lazy var bookPosterAuthorLabel = UILabel().then {
        $0.text = "저자"
        $0.numberOfLines = 2
        $0.textColor = .black
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
            $0.top.equalTo(bookPosterImage.snp.bottom).offset(2)
            $0.left.equalToSuperview().inset(5)
            $0.right.equalToSuperview()
        }
        
        addSubview(bookPosterAuthorLabel)
        bookPosterAuthorLabel.snp.makeConstraints {
            $0.top.equalTo(bookPosterLabel.snp.bottom).offset(2)
            $0.left.equalTo(bookPosterLabel.snp.left)
            $0.right.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
