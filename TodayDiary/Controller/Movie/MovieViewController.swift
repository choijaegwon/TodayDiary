//
//  MovieViewController.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RealmSwift

class MovieViewController: UIViewController {
    
    private let movieView = MovieView()
    private let disposeBag = DisposeBag()
    private let realm = try! Realm()
    lazy var realmMovie = [RealmMoive]() {
        didSet {
            print("gga")
            print(self.realmMovie)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurUI()
        bindUI()
        movieView.textView.isUserInteractionEnabled = false
        bindTap()
        movieView.cosmos.settings.updateOnTouch = false
    }
    
    func configurUI() {
        view.backgroundColor = .white
        
        view.addSubview(movieView)
        movieView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
        
        configureNaviBar()
    }
    
    func configureNaviBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        let rightBarButtonItem = UIBarButtonItem(title: "삭제하기", style: .plain, target: self, action: #selector(movieDelete))
        rightBarButtonItem.tintColor = UIColor.red
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func bindUI() {
        if let image: UIImage = ImageFileManager.shared.getSavedImage(named: realmMovie.first!.movieImage ) {
            DispatchQueue.main.async {
                self.movieView.moviePosterImage.image = image
            }
        }
        
        movieView.moviePosterLabel.text = realmMovie.first?.movieTitle
        movieView.cosmos.rating = realmMovie.first!.movieCosmos
        movieView.moviePosterPubDate.text = realmMovie.first?.moviePubDate
        movieView.moviePosterDirector.text = realmMovie.first?.movieDirector
        movieView.moviePosterActor.text = realmMovie.first?.movieActor
        movieView.movieDateLabel.text = realmMovie.first?.movieDate
        movieView.textView.text = realmMovie.first?.movieContents
    }
    
    func bindTap() {
        self.movieView.upDateButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }            
            let updateMovieViewController = UpdateMovieViewController()
            updateMovieViewController.movieTitle = self.movieView.moviePosterLabel.text
            updateMovieViewController.delegate = self
            updateMovieViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(updateMovieViewController, animated: true)
        }.disposed(by: disposeBag)
    }
    
    @objc func movieDelete() {
        ImageFileManager.shared.deleteImage(named: self.movieView.moviePosterLabel.text!) { onSuccess in
          print("delete = \(onSuccess)")
        }
        
        try! realm.write {
            realm.delete(realm.objects(RealmMoive.self).filter("movieTitle = '\(self.movieView.moviePosterLabel.text!)'"))
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension MovieViewController: UpdateMovieVCDelegate {
    func updateButtonTapped() {
        self.navigationController?.popViewController(animated: false)
    }
}
