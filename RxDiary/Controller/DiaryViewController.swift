//
//  DiaryViewController.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/13.
//

import UIKit
import SnapKit
import UITextView_Placeholder
import RxCocoa
import RxSwift
import RealmSwift

class DiaryViewController: UIViewController {
    
    private lazy var diaryView = DiaryView()
    private var mood = Mood()
    private let disposeBag = DisposeBag()
    private let realm = try! Realm()
    private lazy var diary = self.realm.objects(Diary.self)
    private let date: String
    
    init(date: String) {
        self.date = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurUI()
        diaryUI()
        bindTap()
        
    }
    
    func configurUI() {
        view.backgroundColor = .white
        
        view.addSubview(diaryView)
        diaryView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        // 텍스트 뷰 보기만 하게하는 메서드
        diaryView.textView.isUserInteractionEnabled = false
    }
    
    func diaryUI() {
        let diary = diary.filter("date == '\(self.date)'")
        let seletedMood = diary.first!.mood
        let seletedContents = diary.first!.contents
        
        self.diaryView.moodImageView.image = UIImage(named: self.mood.moodSeletedImageString[seletedMood])
        self.diaryView.selectedButtonLable.text = mood.moodLabel[seletedMood]
        self.diaryView.textView.text = seletedContents
    }
    
    func bindTap() {
        diaryView.upDateButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let diary = self.diary.filter("date == '\(self.date)'")
            // 수정 가능한 뷰컨으로 가기
            let updateDiaryViewController = UpdateDiaryViewController()
            updateDiaryViewController.diary = diary
            self.updateDiaryPresentationController(updateDiaryViewController)
            self.present(updateDiaryViewController, animated: false, completion: nil)
        }.disposed(by: disposeBag)
    }
}

extension DiaryViewController: UISheetPresentationControllerDelegate {
    fileprivate func updateDiaryPresentationController(_ updateDiaryViewController: UpdateDiaryViewController) {
        if let sheet = updateDiaryViewController.sheetPresentationController {
            //크기 변하는거 감지
            sheet.delegate = self
            sheet.detents = [
                .custom { context in
                    return context.maximumDetentValue * 0.85
                }
            ]
            sheet.preferredCornerRadius = 20
            
            //시트 상단에 그래버 표시 (기본 값은 false)
            sheet.prefersGrabberVisible = true
        }
    }
}
