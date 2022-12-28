//
//  MovieMainViewController.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RealmSwift

private let reuseIdentifier = "MovieViewCell"

// 여기서 영화 정보를 다가져오고 뿌려준다.
class MovieMainViewController: UIViewController {

    private let emptyMovieView = EmptyMovieView()
    private let movieMainViewModel = MovieMainViewModel()
    private var disposeBag = DisposeBag()
    let cellMarginSize: CGFloat = 10.0
    
    private lazy var realmMoive: [RealmMoive] = [] { // 전체 배열을 가져온다.
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private let collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurUI()
        registerCell()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurUI()
    }

    func configurUI() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(18)
        }
        
        view.addSubview(emptyMovieView)
        emptyMovieView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        if realmMoive.isEmpty {
            emptyMovieView.isHidden = false
        } else {
            emptyMovieView.isHidden = true
        }
        
        configureNaviBar()
    }
    
    func configureNaviBar() {
        self.title = "영화"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "leftArrow"), style: .plain, target: self, action: #selector(moviePop))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(movieAddButton))
    }

    func registerCell() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // register cell 등록
        collectionView.register(MovieViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func bindUI() {
        movieMainViewModel.fullRealmMoiveObservable
            .map { Array($0) }
            .subscribe (onNext: { [weak self] in
                guard let self = self else { return }
                self.realmMoive = $0
            }).disposed(by: disposeBag)
    }
    
    
    // 영화 더하는 VC으로 이동하는 버튼
    @objc func movieAddButton() {
        let movieSearchViewController = MovieSearchViewController()
        movieSearchViewController.realmMoive = self.realmMoive
        movieSearchViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(movieSearchViewController, animated: true)
    }
    
    @objc func moviePop() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MovieMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realmMoive.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieViewCell
        
        if let image: UIImage = ImageFileManager.shared.getSavedImage(named: realmMoive[indexPath.row].movieImage ) {
            DispatchQueue.main.async {
                cell.moviePosterImage.image = image
            }
        }
        
        let movieDate = String(realmMoive[indexPath.row].movieDate.prefix(13))
        
        cell.moviePosterLabel.text = realmMoive[indexPath.row].movieTitle
        cell.movieDateLabel.text = movieDate
        cell.moviePosterRating.text = String(realmMoive[indexPath.row].movieCosmos)
        
        return cell
    }
    
    // 셀 크기 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 3
        let spacing: CGFloat = self.cellMarginSize
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)

        return CGSize(width: itemDimension, height: 230)
    }
    
    // 그리드의 항목 줄 사이에 사용할 최소 간격 위아래
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.cellMarginSize
    }

    // 같은 행에 있는 항목 사이에 사용할 최소 간격 옆간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
}

extension MovieMainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieViewController = MovieViewController()
        movieViewController.realmMovie = [realmMoive[indexPath.row]]
        movieViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(movieViewController, animated: true)
    }
}
