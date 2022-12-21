//
//  UpdateDiaryViewController.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/13.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class UpdateDiaryViewController: UIViewController {
    
    private lazy var updateDiaryView = UpdateDiaryView()
    private var disposeBag = DisposeBag()
    private var mood = Mood()
    private let realm = try! Realm()
    private lazy var diary = self.realm.objects(Diary.self)
    var date: String?
    lazy var seletedNumber = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("=update 뷰컨=")
        print("\(date!) 업데이트")
        configurUI()
        diaryUI()
        bindTap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disposeBag = DisposeBag()
    }
    
    func configurUI() {
        view.backgroundColor = .white
        
        view.addSubview(updateDiaryView)
        updateDiaryView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        updateDiaryView.saveButton.setTitle("수정", for: .normal)
    }
    
    func diaryUI() {
        let diary = diary.filter("date == '\(self.date!)'")
        let seletedMood = diary.first!.mood
        self.seletedNumber = seletedMood // DB에 있는 원래값
        self.updateDiaryView.tagNumber = seletedMood
        let seletedContents = diary.first!.contents
        
        updateDiaryView.buttonArray[seletedMood].isSelected = true
        updateDiaryView.selectedButtonLable.text = mood.moodLabel[seletedMood]
        updateDiaryView.textView.text = seletedContents
    }
    
    func bindTap() {
        updateDiaryView.saveButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let diaryfilter = self.diary.filter("date == '\(self.date!)'")
            
            let diary = Diary()
            diary.date = diaryfilter.first!.date
            diary.mood = self.updateDiaryView.tagNumber
            diary.contents = self.updateDiaryView.textView.text
            
            try? self.realm.write {
                self.realm.add(diary, update: .modified)
            }
            self.presentingViewController?.presentingViewController?.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
}
