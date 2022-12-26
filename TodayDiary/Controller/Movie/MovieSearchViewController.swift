//
//  MovieSearchViewController.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import SnapKit

private let reuseIdentifier = "MovieCell"

// 여기서 영화검색을 하고, 데이터를 받아온후, 컬렉션 뷰에 나타내 주어야한다.
class MovieSearchViewController: UIViewController {

    private let movieService = MovieService()
    private let disposeBag = DisposeBag()
    let cellMarginSize: CGFloat = 10.0
    lazy var realmMoive: [RealmMoive] = []
    private lazy var movies = [Movie]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.size.width)!, height: 30)
        tf.borderStyle = .roundedRect
        tf.placeholder = "영화 검색"
        tf.clearButtonMode = .always
        tf.returnKeyType = .done
        return tf
    }()
    
    private let collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        cv.showsVerticalScrollIndicator = false
//        cv.backgroundColor = .red
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurUI()
        registerCell()
        bindUI()
        
        self.textField.delegate = self
        textField.becomeFirstResponder()
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(18)
        }
    }

    func configurUI() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.titleView = textField
    }
    
    func registerCell() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // register cell 등록
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func bindUI() {
        movieService.movieList.subscribe(onNext: {
            self.movies = $0
        }).disposed(by: disposeBag)
    }
}

extension MovieSearchViewController: UITextFieldDelegate {
    
    // 완료 버튼을 누르면 키보드가 내려가기만들기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        movieService.fetchMovies(movieName: self.textField.text!)
        return true
    }
}

extension MovieSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCell
        
        // 검색결과가 자꾸 <b> </b>가 포함된 결과가 나와서 제거해줌.
        let titleResult = movies[indexPath.row].title.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
        
        if movies[indexPath.row].image == "" {
            // 형한테 추후 이미지가 없다는거 간단하게 만들어달라하고 넣자.
            cell.moviePosterImage.image = UIImage(named: "noimage")
        } else {
            let url = URL(string: movies[indexPath.row].image)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.moviePosterImage.image = UIImage(data: data!)
                }
            }
        }

        cell.moviePosterLabel.text = titleResult
        cell.moviePosterYear.text = movies[indexPath.row].pubDate
        cell.moviePosterRating.text = movies[indexPath.row].userRating
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

extension MovieSearchViewController: MovieCreateVCDelegate {
    func saveButtonTapped() {
        self.navigationController?.popViewController(animated: false)
    }
}


extension MovieSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let titleResult = movies[indexPath.row].title.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
        if self.realmMoive.map({$0.movieTitle}).contains(titleResult) {
            let alert = UIAlertController(title: "이미 영화 후기가 있어요.", message: "", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
        } else {
            let movieCreateViewController = MovieCreateViewController()
            movieCreateViewController.modalPresentationStyle = .fullScreen
            movieCreateViewController.delegate = self
            var e = [movies[indexPath.row]]
            movieCreateViewController.movie = e
            navigationController?.pushViewController(movieCreateViewController, animated: true)
        }
    }
}
