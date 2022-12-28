//
//  UpdateBookViewController.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RealmSwift

protocol UpdateBookVCDelegate: AnyObject {
    func updateButtonTapped()
    func popButtonTapped()
}

// 데이터피커 되게 바꿔야함
class UpdateBookViewController: UIViewController {
    
    private let updateBookView = UpdateBookView()
    private var disposeBag = DisposeBag()
    private let realm = try! Realm()
    private lazy var realmBook = self.realm.objects(RealmBook.self)
    var bookTitle: String?
    
    weak var delegate: UpdateBookVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurUI()
        bindUI()
        bindTap()
    }
    
    func configurUI() {
        view.backgroundColor = .white
        
        view.addSubview(updateBookView)
        updateBookView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.right.left.bottom.equalToSuperview()
        }
        configureNaviBar()
    }
    
    func configureNaviBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "leftArrow"), style: .plain, target: self, action: #selector(movieBack))
    }
    
    func bindUI() {
        let book = realmBook.filter("bookTitle = '\(self.bookTitle!)'")
    
        if let image: UIImage = ImageFileManager.shared.getSavedImage(named: book.first!.bookImage ) {
            DispatchQueue.main.async {
                self.updateBookView.bookPosterImage.image = image
            }
        }
        
        updateBookView.bookPosterLabel.text = book.first!.bookTitle
        updateBookView.cosmos.rating = book.first!.bookCosmos
        updateBookView.bookPosterAuthor.text = book.first?.bookAuthor
        updateBookView.bookPosterPublisher.text = book.first?.bookPublisher
        updateBookView.bookDateLabel.text = book.first?.bookDate
        updateBookView.textView.text = book.first?.bookContents
        
    }
    
    func bindTap() {
        updateBookView.upDateButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let bookfilter = self.realmBook.filter("bookTitle = '\(self.bookTitle!)'")
            
            let realmBook = RealmBook()
            realmBook.bookImage = self.updateBookView.bookPosterLabel.text! + ".jpeg"
            realmBook.bookTitle = bookfilter.first!.bookTitle
            realmBook.bookCosmos = self.updateBookView.cosmos.rating
            realmBook.bookAuthor = self.updateBookView.bookPosterAuthor.text!
            realmBook.bookPublisher = self.updateBookView.bookPosterPublisher.text!
            realmBook.bookDate = self.updateBookView.bookDateLabel.text!
            realmBook.bookContents = self.updateBookView.textView.text!
            
            try? self.realm.write {
                self.realm.add(realmBook, update: .modified)
            }
            
            self.navigationController?.popViewController(animated: false)
            self.delegate?.updateButtonTapped()
            // full이라 Dismiss가 아니다.
            
        }.disposed(by: disposeBag)
        
        self.updateBookView.bookDateLabel.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let addBookDateViewController = AddBookDateViewController()
                addBookDateViewController.delegate = self
                self.addBookDatePresentationController(addBookDateViewController, self)
                self.present(addBookDateViewController, animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    @objc func movieBack() {
        self.navigationController?.popViewController(animated: false)
        self.delegate?.popButtonTapped()
    }
    
}

extension UpdateBookViewController: AddBookDateVCDelegate {
    func sendDate(pickerDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 E요일" // 2020.08.13 오후 04시 30분
        DispatchQueue.main.async {
            self.updateBookView.bookDateLabel.text = dateFormatter.string(from: pickerDate)
        }
    }
}

extension UpdateBookViewController: UISheetPresentationControllerDelegate {
    fileprivate func addBookDatePresentationController(_ addBookDateViewController: AddBookDateViewController, _ self: UpdateBookViewController) {
        if let sheet = addBookDateViewController.sheetPresentationController {
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
