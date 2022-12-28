//
//  BookCreateViewController.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/27.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import RxGesture
import RealmSwift

protocol BookCreateVCDelegate: AnyObject {
    func saveButtonTapped()
}

class BookCreateViewController: UIViewController {
    
    private let bookCreateView = BookCreateView()
    private var disposeBag = DisposeBag()
    private let realm = try! Realm()
    private let dateFormatter = DateFormatter()
    private var cosmosDouble: Double = 3.0
    private var nowDate = Date()
    private var dateString: String = "" // 오늘날짜
    weak var delegate: BookCreateVCDelegate?
    var book = [Book]()
    
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
        
        view.addSubview(bookCreateView)
        bookCreateView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    func bindUI() {
        // 책이름
        let titleResult = book.first!.title.components(separatedBy: "(")[0]
        // 저자이름
        let authorResult = book.first!.author.replacingOccurrences(of: "^", with: ", ")
        
        if book.first!.image == "" {
            // 형한테 추후 이미지가 없다는거 간단하게 만들어달라하고 넣자.
            bookCreateView.bookPosterImage.image = UIImage(named: "noimage")
        } else {
            let url = URL(string: book.first!.image)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.bookCreateView.bookPosterImage.image = UIImage(data: data!)
                }
            }
        }
        
        if authorResult == "" {
            self.bookCreateView.bookPosterAuthor.text = "저자 정보가 없습니다."
        } else {
            self.bookCreateView.bookPosterAuthor.text = authorResult
        }
        
        bookCreateView.bookPosterLabel.text = titleResult
        bookCreateView.bookPosterPublisher.text = book.first!.publisher
        bookCreateView.bookDateLabel.text = self.dateString
        
        
    }
    
    func bindTap() {
        // 평점 조절하고 저장하는 메서드
        bookCreateView.cosmos.didFinishTouchingCosmos = {
            self.cosmosDouble = $0
        }
        
        bookCreateView.saveButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            
            let uniqueFileName: String = "\(self.bookCreateView.bookPosterLabel.text!)"+".jpeg"
            ImageFileManager.shared
                .saveImage(image: self.bookCreateView.bookPosterImage.image!,
                           name: uniqueFileName) { [weak self] onSuccess in
                    print("saveImage onSuccess: \(onSuccess)")
                }
            let realmBook = RealmBook()
            realmBook.bookImage = uniqueFileName
            realmBook.bookTitle = self.bookCreateView.bookPosterLabel.text!
            realmBook.bookCosmos = self.cosmosDouble
            realmBook.bookAuthor = self.bookCreateView.bookPosterAuthor.text!
            realmBook.bookPublisher = self.bookCreateView.bookPosterPublisher.text!
            realmBook.bookDate = self.bookCreateView.bookDateLabel.text!
            realmBook.bookContents = self.bookCreateView.textView.text!
            
            try! self.realm.write {
                self.realm.add(realmBook)
            }
            // 팝이 두번되어야한다.
            self.navigationController?.popViewController(animated: false)
            self.delegate?.saveButtonTapped()
        }.disposed(by: disposeBag)
        
        bookCreateView.bookDateLabel.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                print(#function)
                let addBookDateViewController = AddBookDateViewController()
                addBookDateViewController.delegate = self
                self.addBookDatePresentationController(addBookDateViewController, self)
                self.present(addBookDateViewController, animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - 시간 정하는 메서드들

extension BookCreateViewController: AddBookDateVCDelegate {
    func sendDate(pickerDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 E요일" // 2020.08.13 오후 04시 30분
        DispatchQueue.main.async {
            self.bookCreateView.bookDateLabel.text = dateFormatter.string(from: pickerDate)
        }
    }
}

extension BookCreateViewController: UISheetPresentationControllerDelegate {
    fileprivate func addBookDatePresentationController(_ addBookDateViewController: AddBookDateViewController, _ self: BookCreateViewController) {
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

