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
    
    private lazy var updateDiaryView = CreateUpdateDiaryView()
    private var disposeBag = DisposeBag()
    private var mood = Mood()
    private let realm = try! Realm()
    var diary: Results<Diary>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hh")

        configurUI()
        diaryUI()
        bindTap()
        bindUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disposeBag = DisposeBag()
    }
    
    func bindUI() {
        // 옵져버블 인트값을 만들고
        // 옵져버블 인트값을 넣어주고
        // 옵져버블 인트를 구독한다.
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
        let seletedMood = self.diary.first!.mood
        let seletedContents = self.diary.first!.contents
        
        updateDiaryView.buttonArray[seletedMood].isSelected = true
        updateDiaryView.selectedButtonLable.text = mood.moodLabel[seletedMood]
        updateDiaryView.textView.text = seletedContents
    }
    
    func bindTap() {
        updateDiaryView.saveButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let diary = Diary()
            diary.date = self.diary.first!.date
            // 기분은 그대로하고싶은데, 선택을 안하면 그냥 인덱스0이 넘어가버린다.
            diary.mood = self.updateDiaryView.tagNumber
            diary.contents = self.updateDiaryView.textView.text
            
            try? self.realm.write {
                self.realm.add(diary, update: .modified)
            }
            self.presentingViewController?.presentingViewController?.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
}
