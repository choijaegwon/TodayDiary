//
//  updateMovieViewController.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RealmSwift

protocol UpdateMovieVCDelegate: AnyObject {
    func updateButtonTapped()
}

// 데이터피커 되게 바꿔야함
class UpdateMovieViewController: UIViewController {
    
    private let updateMovieView = UpdateMovieView()
    private var disposeBag = DisposeBag()
    private let realm = try! Realm()
    private lazy var realmMovie = self.realm.objects(RealmMoive.self)
    var movieTitle: String?
    
    weak var delegate: UpdateMovieVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurUI()
        bindUI()
        bindTap()
    }
    
    func configurUI() {
        view.backgroundColor = .white
        
        view.addSubview(updateMovieView)
        updateMovieView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.right.left.bottom.equalToSuperview()
        }
    }
    
    func bindUI() {
        let movie = realmMovie.filter("movieTitle = '\(self.movieTitle!)'")
    
        if let image: UIImage = ImageFileManager.shared.getSavedImage(named: movie.first!.movieImage ) {
            DispatchQueue.main.async {
                self.updateMovieView.moviePosterImage.image = image
            }
        }
        
        updateMovieView.moviePosterLabel.text = movie.first!.movieTitle
        updateMovieView.cosmos.rating = movie.first!.movieCosmos
        updateMovieView.moviePosterPubDate.text = movie.first!.moviePubDate
        updateMovieView.moviePosterDirector.text = movie.first!.movieDirector
        updateMovieView.moviePosterActor.text = movie.first!.movieActor
        updateMovieView.movieDateLabel.text = movie.first!.movieDate
        updateMovieView.textView.text = movie.first!.movieContents
    }
    
    func bindTap() {
        updateMovieView.upDateButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let moviefilter = self.realmMovie.filter("movieTitle = '\(self.movieTitle!)'")
            
            let realmMovie = RealmMoive()
            realmMovie.movieImage = self.updateMovieView.moviePosterLabel.text! + ".jpeg"
            realmMovie.movieTitle = moviefilter.first!.movieTitle
            realmMovie.movieCosmos = self.updateMovieView.cosmos.rating
            realmMovie.moviePubDate = self.updateMovieView.moviePosterPubDate.text!
            realmMovie.movieDirector = self.updateMovieView.moviePosterDirector.text!
            realmMovie.movieActor = self.updateMovieView.moviePosterActor.text!
            realmMovie.movieDate = self.updateMovieView.movieDateLabel.text!
            realmMovie.movieContents = self.updateMovieView.textView.text!
            
            try? self.realm.write {
                self.realm.add(realmMovie, update: .modified)
            }
            
            self.navigationController?.popViewController(animated: false)
            self.delegate?.updateButtonTapped()
            // full이라 Dismiss가 아니다.
            
        }.disposed(by: disposeBag)
        
        self.updateMovieView.movieDateLabel.rx
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

extension UpdateMovieViewController: AddMovieDateVCDelegate {
    func sendDate(pickerDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 E요일" // 2020.08.13 오후 04시 30분
        DispatchQueue.main.async {
            self.updateMovieView.movieDateLabel.text = dateFormatter.string(from: pickerDate)
        }
    }
}

extension UpdateMovieViewController: UISheetPresentationControllerDelegate {
    fileprivate func addMovieDatePresentationController(_ addMovieDateViewController: AddMovieDateViewController, _ self: UpdateMovieViewController) {
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
