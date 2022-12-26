//
//  BookCreateView.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/27.
//

import UIKit
import Then
import SnapKit
import Cosmos

class BookCreateView: UIView {
    
    // 책 이미지
    lazy var bookPosterImage = UIImageView().then {
        // 그때 그떄 정할 예정 일단 기본이미지.
        $0.image = UIImage(named: "testbookimage")
        $0.contentMode = .scaleAspectFit
    }
    
    // 책 제목
    lazy var bookPosterLabel = UILabel().then {
        $0.text = "책 제목"
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 13, weight: .bold)
    }
    
    // 평점
    lazy var cosmos = CosmosView().then {
        $0.rating = 3
    }
    
    private let bookPosterAuthorLabel = UILabel().then {
        $0.text = "저자"
        $0.textColor = .yearTextColor
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 13, weight: .medium)
    }
    
    lazy var bookPosterAuthor = UILabel().then {
        $0.text = "저자 이름"
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 15, weight: .medium)
    }
    
    private let bookPosterPublisherLabel = UILabel().then {
        $0.text = "출판사"
        $0.textColor = .yearTextColor
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 13, weight: .medium)
    }
    
    lazy var bookPosterPublisher = UILabel().then {
        $0.text = "출판사 이름"
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 15, weight: .medium)
    }
    
    private let bookDayLabel = UILabel().then {
        $0.text = "책본 날짜"
        $0.textColor = .yearTextColor
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 13, weight: .medium)
    }
    
    // 본날짜.
    lazy var bookDateLabel = UILabel().then {
        $0.text = "2022년 12월 24일 토요일"
        $0.textColor = .black
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 13, weight: .medium)
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
    
    lazy var saveButton = UIButton().then {
        $0.setTitle("저장하기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.black
        $0.tintColor = UIColor.white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bookPosterImage)
        bookPosterImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(0)
            $0.width.equalTo(110)
            $0.height.equalTo(158)
        }
        
        addSubview(bookPosterLabel)
        bookPosterLabel.snp.makeConstraints {
            $0.top.equalTo(bookPosterImage.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(cosmos)
        cosmos.snp.makeConstraints {
            $0.top.equalTo(bookPosterLabel.snp.bottom).offset(10)
            $0.width.equalTo(bookPosterLabel.snp.width)
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
        }
        // 저자
        addSubview(bookPosterAuthorLabel)
        bookPosterAuthorLabel.snp.makeConstraints {
            $0.top.equalTo(bookPosterLabel.snp.bottom).offset(30)
            $0.left.equalToSuperview().inset(15)
        }
        
        // 저자이름
        addSubview(bookPosterAuthor)
        bookPosterAuthor.snp.makeConstraints {
            $0.top.equalTo(bookPosterLabel.snp.bottom).offset(30)
            $0.left.equalTo(bookPosterAuthorLabel.snp.right).offset(2)
            $0.right.equalToSuperview().inset(15)
        }
        
        // 출판사
        addSubview(bookPosterPublisherLabel)
        bookPosterPublisherLabel.snp.makeConstraints {
            $0.top.equalTo(bookPosterAuthor.snp.bottom).offset(10)
            $0.left.equalTo(bookPosterAuthorLabel)
        }
        
        // 출판사이름
        addSubview(bookPosterPublisher)
        bookPosterPublisher.snp.makeConstraints {
            $0.top.equalTo(bookPosterAuthor.snp.bottom).offset(10)
            $0.left.equalTo(bookPosterPublisherLabel.snp.right).offset(2)
            $0.right.equalToSuperview().inset(15)
        }
        
        // 본날짜
        addSubview(bookDayLabel)
        bookDayLabel.snp.makeConstraints {
            $0.top.equalTo(bookPosterPublisher.snp.bottom).offset(10)
            $0.left.equalTo(bookPosterPublisherLabel.snp.left)
        }
        
        // yyyy mm  ee eee
        addSubview(bookDateLabel)
        bookDateLabel.snp.makeConstraints {
            $0.top.equalTo(bookPosterPublisher.snp.bottom).offset(10)
            $0.left.equalTo(bookDayLabel.snp.right).offset(4)
        }
        
        addSubview(textView)
        addSubview(saveButton)
        
        textView.snp.makeConstraints {
            $0.top.equalTo(bookDateLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(15)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(52)
            $0.left.right.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

