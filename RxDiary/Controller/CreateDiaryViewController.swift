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

class CreateDiaryViewController: UIViewController {
    
    var createDiaryView = CreateDiaryView()
    var disposeBag = DisposeBag()
    let realm = try! Realm()
    
    // 사용할때 언래핑해줘야한다.
    // MainVC에서 날짜데이터를 받는 변수
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(date!)
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
        createDiaryView.saveButton.rx.tap.bind {
            // 데이터 저장하는 코드
            let diary = Diary()
            diary.date = self.date!
            diary.mood = self.createDiaryView.tagNumber
            diary.contents = self.createDiaryView.textView.text
            
            try! self.realm.write {
                self.realm.add(diary)
            }
            
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
}
