//
//  BookMainViewController.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RealmSwift

private let reuseIdentifier = "BookViewCell"

// 여기서 책 정보를 다가져오고 뿌려준다.
class BookMainViewController: UIViewController {

    private let emptyBookView = EmptyBookView()
    private let bookMainViewModel = BookMainViewModel()
    private var disposeBag = DisposeBag()
    let cellMarginSize: CGFloat = 10.0
    
    private lazy var realmBook: [RealmBook] = [] { // 전체 배열을 가져온다.
        didSet {
            if realmBook.isEmpty {
                emptyBookView.isHidden = false
            } else {
                emptyBookView.isHidden = true
            }
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
        
        view.addSubview(emptyBookView)
        emptyBookView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        configureNaviBar()
    }
    
    func configureNaviBar() {
        self.title = "책"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "leftArrow"), style: .plain, target: self, action: #selector(bookPop))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(bookAddButton))
    }

    func registerCell() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // register cell 등록
        collectionView.register(BookViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func bindUI() {
        bookMainViewModel.fullRealmBookObservable
            .map { Array($0) }
            .subscribe (onNext: { [weak self] in
                guard let self = self else { return }
                self.realmBook = $0
            }).disposed(by: disposeBag)
    }
    
    
    // 영화 더하는 VC으로 이동하는 버튼
    @objc func bookAddButton() {
        print(#function)
        let bookSearchViewController = BookSearchViewController()
        bookSearchViewController.realmBook = self.realmBook
        bookSearchViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(bookSearchViewController, animated: true)
    }
    
    @objc func bookPop() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension BookMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realmBook.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookViewCell
        
        if let image: UIImage = ImageFileManager.shared.getSavedImage(named: realmBook[indexPath.row].bookImage ) {
            DispatchQueue.main.async {
                cell.bookPosterImage.image = image
            }
        }
        
        let bookDate = String(realmBook[indexPath.row].bookDate.prefix(13))
        
        cell.bookPosterLabel.text = realmBook[indexPath.row].bookTitle
        cell.bookDateLabel.text = bookDate
        cell.bookPosterRating.text = String(realmBook[indexPath.row].bookCosmos)
        
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

extension BookMainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(realmMoive[indexPath.row])
        let bookViewController = BookViewController()
        bookViewController.realmBook = [realmBook[indexPath.row]]
        bookViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(bookViewController, animated: true)
    }
}
