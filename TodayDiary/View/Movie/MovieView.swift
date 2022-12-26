//
//  MovieView.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/25.
//

import UIKit
import Then
import SnapKit
import Cosmos

class MovieView: UIView {
    
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
    
    lazy var cosmos = CosmosView().then {
        $0.rating = 3
    }
    
    private let moviePosterPubDateLabel = UILabel().then {
        $0.text = "개봉년도"
        $0.textColor = .yearTextColor
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 13, weight: .medium)
    }
    
    lazy var moviePosterPubDate = UILabel().then {
        $0.text = "2020"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 15, weight: .medium)
    }
    
    private let moviePosterDirectorLabel = UILabel().then {
        $0.text = "감독"
        $0.textColor = .yearTextColor
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 13, weight: .medium)
    }
    
    lazy var moviePosterDirector = UILabel().then {
        $0.text = "감독 이름"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 15, weight: .medium)
    }
    
    private let moviePosterActorLabel = UILabel().then {
        $0.text = "배우"
        $0.textColor = .yearTextColor
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 13, weight: .medium)
    }
    
    lazy var moviePosterActor = UILabel().then {
        $0.text = "배우 이름들"
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 15, weight: .medium)
    }
    
    private let movieDayLabel = UILabel().then {
        $0.text = "영화본 날짜"
        $0.textColor = .yearTextColor
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 13, weight: .medium)
    }
    
    // 본날짜.
    lazy var movieDateLabel = UILabel().then {
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
    
    lazy var upDateButton = UIButton().then {
        $0.setTitle("수정하기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.black
        $0.tintColor = UIColor.white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(moviePosterImage)
        moviePosterImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(0)
            $0.width.equalTo(110)
            $0.height.equalTo(158)
        }
        
        addSubview(moviePosterLabel)
        moviePosterLabel.snp.makeConstraints {
            $0.top.equalTo(moviePosterImage.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(cosmos)
        cosmos.snp.makeConstraints {
            $0.top.equalTo(moviePosterLabel.snp.bottom).offset(10)
            $0.width.equalTo(moviePosterImage.snp.width)
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
        }
        
        let moviePosterPubDateStack = UIStackView(arrangedSubviews: [moviePosterPubDateLabel, moviePosterPubDate])
        moviePosterPubDateStack.axis = .horizontal
        moviePosterPubDateStack.spacing = 4
        addSubview(moviePosterPubDateStack)
        
        moviePosterPubDateStack.snp.makeConstraints {
            $0.top.equalTo(moviePosterLabel.snp.bottom).offset(30)
            $0.left.equalToSuperview().inset(15)
        }
        
        let moviePosterDirectorStack = UIStackView(arrangedSubviews: [moviePosterDirectorLabel, moviePosterDirector])
        moviePosterDirectorStack.axis = .horizontal
        moviePosterDirectorStack.spacing = 4
        addSubview(moviePosterDirectorStack)
        
        moviePosterDirectorStack.snp.makeConstraints {
            $0.top.equalTo(moviePosterPubDateStack.snp.bottom).offset(10)
            $0.left.equalToSuperview().inset(15)
        }
        
        addSubview(moviePosterActorLabel)
        moviePosterActorLabel.snp.makeConstraints {
            $0.top.equalTo(moviePosterDirectorStack.snp.bottom).offset(10)
            $0.left.equalTo(moviePosterPubDateStack.snp.left)
        }
        
        addSubview(moviePosterActor)
        moviePosterActor.snp.makeConstraints {
            $0.top.equalTo(moviePosterDirectorStack.snp.bottom).offset(10)
            $0.left.equalTo(moviePosterActorLabel.snp.right).offset(4)
            $0.right.equalToSuperview().inset(15)
        }
        
        addSubview(movieDayLabel)
        movieDayLabel.snp.makeConstraints {
            $0.top.equalTo(moviePosterActor.snp.bottom).offset(10)
            $0.left.equalTo(moviePosterActorLabel.snp.left)
        }
        
        addSubview(movieDateLabel)
        movieDateLabel.snp.makeConstraints {
            $0.top.equalTo(moviePosterActor.snp.bottom).offset(10)
            $0.left.equalTo(movieDayLabel.snp.right).offset(4)
        }
        
        addSubview(textView)
        addSubview(upDateButton)
        
        textView.snp.makeConstraints {
            $0.top.equalTo(movieDateLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(15)
        }
        
        // 저장하면 -> 이미지, 년도, 감독, 배우, textView내용 다 저장한후, 본날짜를 저장해준다.
        // 본날짜는 배우 아래에서 피커뷰로 클릭할수있게 만들어야한다.
        upDateButton.snp.makeConstraints {
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
