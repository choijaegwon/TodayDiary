//
//  CreateDiaryViewController.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/11.
//

import UIKit
import RxCocoa
import RxSwift
import RealmSwift

protocol CreateDiaryVCDelegate: AnyObject {
    func saveButtonTapped()
}

class CreateDiaryViewController: UIViewController {
    
    var createDiaryView = CreateDiaryView()
    var disposeBag = DisposeBag()
    let realm = try! Realm()
    weak var delegate: CreateDiaryVCDelegate?
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configurUI()
        bindTap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disposeBag = DisposeBag()
    }
    
    func configurUI() {
        view.backgroundColor = .white
        
        view.addSubview(createDiaryView)
        createDiaryView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        createDiaryView.mood0Button.isSelected = true
    }
    
    func bindTap() {
        createDiaryView.saveButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            // 데이터 저장하는 코드
            let diary = Diary()
            diary.date = self.date!
            diary.mood = self.createDiaryView.tagNumber
            diary.contents = self.createDiaryView.textView.text
            
            try! self.realm.write {
                self.realm.add(diary)
            }
            self.delegate?.saveButtonTapped()
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
}
