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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(18)
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
        
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func bindUI() {
        movieService.movieList.subscribe(onNext: {
            self.movies = $0
        }).disposed(by: disposeBag)
    }
}

extension MovieSearchViewController: UITextFieldDelegate {
    
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
        
        let titleResult = movies[indexPath.row].title.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
        
        if movies[indexPath.row].image == "" {
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
        cell.moviePosterYear.text = movies[indexPath.row].pubDate + "년"
        cell.moviePosterRating.text = movies[indexPath.row].userRating
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 3
        let spacing: CGFloat = self.cellMarginSize
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)

        return CGSize(width: itemDimension, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.cellMarginSize
    }

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
