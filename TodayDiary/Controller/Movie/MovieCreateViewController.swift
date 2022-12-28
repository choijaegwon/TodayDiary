//
//  MovieCreateViewController.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/25.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import RxGesture
import RealmSwift

protocol MovieCreateVCDelegate: AnyObject {
    func saveButtonTapped()
}

class MovieCreateViewController: UIViewController {
    
    private let movieCreateView = MovieCreateView()
    private var disposeBag = DisposeBag()
    private let realm = try! Realm()
    private let dateFormatter = DateFormatter()
    private var cosmosDouble: Double = 3.0
    private var nowDate = Date()
    private var dateString: String = "" // 오늘날짜
    weak var delegate: MovieCreateVCDelegate?
    var movie = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 E요일" // 2020.08.13 오후 04시 30분
        self.dateString = dateFormatter.string(from: nowDate)
        
        configurUI()
        bindUI()
        bindTap()
    }
    
    func configurUI() {
        view.backgroundColor = .white
        
        view.addSubview(movieCreateView)
        movieCreateView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    func bindUI() {
        // 제목에 <b>로 되어있는걸 없애준다.
        let titleResult = movie.first!.title.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
        // 감독이름에 |가 있는걸 없애준다.
        let directorResult = movie.first!.director.replacingOccurrences(of: "|", with: "")
        // "|"가 붙은 형태로 나와서 마지막을 제거해주고
        let actor = String(movie.first!.actor.dropLast())
        // 전체결과에서 | 있는걸 다 ,로 바꿔준다.
        let actorResult = actor.replacingOccurrences(of: "|", with: ", ")
        
        if movie.first!.image == "" {
            // 형한테 추후 이미지가 없다는거 간단하게 만들어달라하고 넣자.
            movieCreateView.moviePosterImage.image = UIImage(named: "noimage")
        } else {
            let url = URL(string: movie.first!.image)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.movieCreateView.moviePosterImage.image = UIImage(data: data!)
                }
            }
        }

        movieCreateView.moviePosterLabel.text = titleResult
        movieCreateView.moviePosterPubDate.text = movie.first!.pubDate + "년"
        movieCreateView.moviePosterDirector.text = directorResult
        if actorResult == "" {
            self.movieCreateView.moviePosterActor.text = "배우 정보가 없습니다."
        } else {
            self.movieCreateView.moviePosterActor.text = actorResult
        }
        movieCreateView.movieDateLabel.text = self.dateString
    }
    
    func bindTap() {
        // 평점 조절하고 저장하는 메서드
        movieCreateView.cosmos.didFinishTouchingCosmos = {
            self.cosmosDouble = $0
        }
        
        // 저장하기 버튼
        movieCreateView.saveButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            // UniqueName.jpeg
            let uniqueFileName: String = "\(self.movieCreateView.moviePosterLabel.text!)"+".jpeg"
            ImageFileManager.shared
                .saveImage(image: self.movieCreateView.moviePosterImage.image!,
                           name: uniqueFileName) { [weak self] onSuccess in
                    print("saveImage onSuccess: \(onSuccess)")
                }
            let realmMovie = RealmMoive()
            realmMovie.movieImage = uniqueFileName
            realmMovie.movieTitle = self.movieCreateView.moviePosterLabel.text!
            realmMovie.movieCosmos = self.cosmosDouble
            realmMovie.moviePubDate = self.movieCreateView.moviePosterPubDate.text!
            realmMovie.movieDirector = self.movieCreateView.moviePosterDirector.text!
            realmMovie.movieActor = self.movieCreateView.moviePosterActor.text ?? "배우정보가 없습니다."
            realmMovie.movieDate = self.movieCreateView.movieDateLabel.text!
            realmMovie.movieContents = self.movieCreateView.textView.text!
            
            try! self.realm.write {
                self.realm.add(realmMovie)
            }
            // 저장하기전에 이미 있는 영화제목이번 알렛을 띄여줘야한다.
            // 팝이 두번되어야한다.
            self.navigationController?.popViewController(animated: false)
            self.delegate?.saveButtonTapped()
        }.disposed(by: disposeBag)
        
        movieCreateView.movieDateLabel.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                print(#function)
                let addMovieDateViewController = AddMovieDateViewController()
                addMovieDateViewController.delegate = self
                self.addMovieDatePresentationController(addMovieDateViewController, self)
                self.present(addMovieDateViewController, animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - 시간 정하는 메서드들

extension MovieCreateViewController: AddMovieDateVCDelegate {
    func sendDate(pickerDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 E요일" // 2020.08.13 오후 04시 30분
        DispatchQueue.main.async {
            self.movieCreateView.movieDateLabel.text = dateFormatter.string(from: pickerDate)
        }
    }
}

extension MovieCreateViewController: UISheetPresentationControllerDelegate {
    fileprivate func addMovieDatePresentationController(_ addMovieDateViewController: AddMovieDateViewController, _ self: MovieCreateViewController) {
        if let sheet = addMovieDateViewController.sheetPresentationController {
            //크기 변하는거 감지
            sheet.delegate = self
            sheet.detents = [
                .custom { context in
                    return context.maximumDetentValue * 0.3
                }
            ]
            sheet.preferredCornerRadius = 20
            
            //시트 상단에 그래버 표시 (기본 값은 false)
            sheet.prefersGrabberVisible = true
        }
    }
}

