//
//  BookSearchViewController.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/26.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import SnapKit

private let reuseIdentifier = "MovieCell"

// 여기서 영화검색을 하고, 데이터를 받아온후, 컬렉션 뷰에 나타내 주어야한다.
class BookSearchViewController: UIViewController {

    private let bookService = BookService()
    private let disposeBag = DisposeBag()
    let cellMarginSize: CGFloat = 10.0
    
    private lazy var books = [Book]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.size.width)!, height: 30)
        tf.borderStyle = .roundedRect
        tf.placeholder = "책 검색"
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
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func bindUI() {
        bookService.bookList.subscribe(onNext: {
            print("test")
            print($0)
            self.books = $0
            print("test")
        }).disposed(by: disposeBag)
    }
}

extension BookSearchViewController: UITextFieldDelegate {
    
    // 완료 버튼을 누르면 키보드가 내려가기만들기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        bookService.fetchBooks(bookName: "엑시트")
        return true
    }
}

extension BookSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookCell
        
        let authorResult = books[indexPath.row].author.replacingOccurrences(of: "^", with: ", ")
        let titleResult = books[indexPath.row].title.components(separatedBy: "(")[0]
        
        if books[indexPath.row].image == "" {
            // 형한테 추후 이미지가 없다는거 간단하게 만들어달라하고 넣자.
            cell.bookPosterImage.image = UIImage(named: "noimage")
        } else {
            let url = URL(string: books[indexPath.row].image)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.bookPosterImage.image = UIImage(data: data!)
                }
            }
        }
        
        cell.bookPosterLabel.text = titleResult
        cell.bookPosterAuthorLabel.text = authorResult
        
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

extension BookSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
}
