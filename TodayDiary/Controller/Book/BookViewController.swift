//
//  BookViewController.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/27.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RealmSwift

class BookViewController: UIViewController {
    
    private let bookView = BookView()
    private let disposeBag = DisposeBag()
    private let realm = try! Realm()
    lazy var realmBook = [RealmBook]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurUI()
        bindUI()
        bookView.textView.isUserInteractionEnabled = false
        bindTap()
        bookView.cosmos.settings.updateOnTouch = false
    }
    
    func configurUI() {
        view.backgroundColor = .white
        
        view.addSubview(bookView)
        bookView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
        
        configureNaviBar()
    }
    
    func configureNaviBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "leftArrow"), style: .plain, target: self, action: #selector(bookPop))
        let rightBarButtonItem = UIBarButtonItem(title: "삭제하기", style: .plain, target: self, action: #selector(bookDelete))
        rightBarButtonItem.tintColor = UIColor.red
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func bindUI() {
        if let image: UIImage = ImageFileManager.shared.getSavedImage(named: realmBook.first!.bookImage ) {
            DispatchQueue.main.async {
                self.bookView.bookPosterImage.image = image
            }
        }
        
        bookView.bookPosterLabel.text = realmBook.first!.bookTitle
        bookView.cosmos.rating = realmBook.first!.bookCosmos
        bookView.bookPosterAuthor.text = realmBook.first!.bookAuthor
        bookView.bookPosterPublisher.text = realmBook.first?.bookPublisher
        bookView.bookDateLabel.text = realmBook.first!.bookDate
        bookView.textView.text = realmBook.first?.bookContents
    }
    
    func bindTap() {
        self.bookView.upDateButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let updateBookViewController = UpdateBookViewController()
            updateBookViewController.bookTitle = self.bookView.bookPosterLabel.text
            updateBookViewController.delegate = self
            updateBookViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(updateBookViewController, animated: true)
        }.disposed(by: disposeBag)
    }
    
    @objc func bookDelete() {
        ImageFileManager.shared.deleteImage(named: self.bookView.bookPosterLabel.text!) { onSuccess in
          print("delete = \(onSuccess)")
        }
        
        try! realm.write {
            realm.delete(realm.objects(RealmBook.self).filter("bookTitle = '\(self.bookView.bookPosterLabel.text!)'"))
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func bookPop() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension BookViewController: UpdateBookVCDelegate {
    func popButtonTapped() {
        self.navigationController?.popViewController(animated: false)
    }
    
    func updateButtonTapped() {
        self.navigationController?.popViewController(animated: false)
    }
}
