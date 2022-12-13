//
//  ViewController.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/10.
//

import UIKit
import SnapKit
import FSCalendar
import RxSwift
import RxCocoa
import RealmSwift
import Toast_Swift

class MainViewController: UIViewController, UISheetPresentationControllerDelegate {

    private var mainView = MainView()
    private var mainViewModel = MainViewModel()
    private var disposeBag = DisposeBag()
    private var mood = Mood()
    private let dateFormatter = DateFormatter()
    private lazy var diarys:[Diary] = [] { // 몇년몇월 이렇게 필터링 된 값만 가져오는 배열
        didSet {
            // 만약 배열안에 오늘이 들어있으면 mainview안에 calnder의 둥근거 없애버리기
            self.mainView.calendar.reloadData()
        }
    }
    private lazy var fullDiary: [Diary] = [] { // 전체 배열을 가져온다.
        didSet {
            self.mainView.calendar.reloadData()
        }
    }
    
    private lazy var todayDiary: [Diary] = [] {
        didSet {
            self.mainView.calendar.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "YYYYMMdd"
        mainView.calendar.delegate = self
        mainView.calendar.dataSource = self
        
        configurUI()
        bindUI()
        bindTap()
        
    }
    
    func configurUI() {
        view.backgroundColor = .white
        view.addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.right.left.bottom.equalToSuperview()
        }
        configureNaviBar()
    }
    
    func configureNaviBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting"), style: .plain, target: self, action: #selector(handleSetting))
    }
    
    func bindUI() {
        mainViewModel.headerYearLabel
            .asDriver(onErrorJustReturn: "")
            .drive(mainView.headerYearLabel.rx.text)
            .disposed(by: disposeBag)
        
        mainViewModel.headerMonthLabel
            .asDriver(onErrorJustReturn: "")
            .drive(mainView.headerMonthLabel.rx.text)
            .disposed(by: disposeBag)
        
        mainViewModel.headerMonthLabel
            .asDriver(onErrorJustReturn: "")
            .drive(mainView.monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 해당하는 배열의 합을 가져오게함.
        mainViewModel.sumMood
            .asDriver(onErrorJustReturn: "")
            .drive(mainView.sumMood.rx.text)
            .disposed(by: disposeBag)
        
        // readRealmDateString의 결과값으로 diaryObservable의 값을 필터링해서 해당 달에 해당하는 배열만 가져오도록함.
        mainViewModel.sortedDiaryObservable
            .map { Array($0) } // [Diary]로 바꿔준다.
            .subscribe (onNext: { [weak self] in
                guard let self = self else { return }
                self.diarys = $0
            }).disposed(by: disposeBag)
        
        // 오늘 일기 배열
        mainViewModel.todayDiaryObservable
            .map { Array($0) }
            //여기서 메인으로 바꿔주고,
            .observe(on: MainScheduler.instance)
            .subscribe (onNext: { [weak self] in
                guard let self = self else { return }
                if $0.isEmpty == true { // 오늘 일기가 비어있으면
                    self.mainView.todayBackgorund.isHidden = true
                } else { // 오늘 일기가 있으면 데이터 채워주기
                    self.mainView.todayBackgorund.isHidden = false
                    self.mainView.mainquestionbutton.isHidden = true
                    $0.map { diary in
                        self.mainView.todayMoodImage.image = UIImage(named: "\(diary.mood)")
                        self.mainView.todayMoodLabel.text = self.mood.moodLabel[diary.mood]
                        self.mainView.todayContentsLabel.text = diary.contents
                    }
                }
            }).disposed(by: disposeBag)
        
//        diarys.map({ $0.date }).contains(nowDate)
        // 전체 일기를 가져온다. -> 이걸로 cell 화면 부분 만들기.
//        mainViewModel.fullDiaryObservable
//            .map { Array($0) }
//            .subscribe (onNext: { [weak self] in
//                guard let self = self else { return }
//                // 이 배열에 오늘 값이 있으면
//
//            }).disposed(by: disposeBag)
    }
    
    func bindTap() {
        mainView.leftButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind {
                self.mainView.calendar.setCurrentPage(self.mainViewModel.getPreviousMonth(date: self.mainView.calendar.currentPage), animated: true)
            }.disposed(by: disposeBag)
        
        mainView.rightButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind {
                self.mainView.calendar.setCurrentPage(self.mainViewModel.getNextMonth(date: self.mainView.calendar.currentPage), animated: true)
            }.disposed(by: disposeBag)
        
        mainView.mainquestionbutton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            print(#function)
            // 넘어갈 현재날짜.
            let nowDate = self.dateFormatter.string(from: Date())
            
            // 만약 데이터가 있으면 View를 보여주는 화면으로 옮기고
            // 오늘 데이터가 없으면, 새로 만드는 화면으로 옮겨줘야한다.
            if self.diarys.map({ $0.date }).contains(nowDate) {
                print("대충 뷰보여주는화면")
                let diaryViewController = DiaryViewController()
                diaryViewController.date = nowDate
                self.diaryViewPresentationController(diaryViewController)
                self.present(diaryViewController, animated: true)
            } else {
                let createDiaryViewController = CreateDiaryViewController()
                createDiaryViewController.delegate = self
                createDiaryViewController.date = nowDate
                self.createDiaryPresentationController(createDiaryViewController)
                self.present(createDiaryViewController, animated: true)
            }
            
        }.disposed(by: disposeBag)
    }
    
    @objc func handleSetting() {
        print(#function)
    }
}

extension MainViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    // 날이 선택되었을떄 메서드
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let seletedDate = dateFormatter.string(from: date)
        // 만약 데이터가 있으면 View를 보여주는 화면으로 옮기고
        // 오늘 데이터가 없으면, 새로 만드는 화면으로 옮겨줘야한다.
        if self.diarys.map({ $0.date }).contains(seletedDate) {
            print("대충 뷰보여주는화면select")
            let diaryViewController = DiaryViewController()
            diaryViewController.date = seletedDate
            self.diaryViewPresentationController(diaryViewController)
            self.present(diaryViewController, animated: true)
        } else {
            print("이것도그러나")
            let createDiaryViewController = CreateDiaryViewController()
            createDiaryViewController.delegate = self
            createDiaryViewController.date = seletedDate
            self.createDiaryPresentationController(createDiaryViewController)
            self.present(createDiaryViewController, animated: true)
        }
    }
    
    // 주말 요일색 변경
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        
        if Calendar.current.shortWeekdaySymbols[day] == "일" {
            return .systemRed
        } else if Calendar.current.shortWeekdaySymbols[day] == "토" {
            return .systemBlue
        } else {
            return .black
        }
    }
    
    // 달이 바뀔때마다 불러오는 메서드
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = calendar.currentPage // 현재의 달 Date값.
        
        let currentYear = mainViewModel.headerYearDateFormatter.string(from: currentPage)
        let currentMonth = mainViewModel.monthDateFormatter.string(from: currentPage)
        let currentFilterDate = mainViewModel.filterDateDateFormatter.string(from: currentPage)
        
        mainViewModel.headerYearLabel.accept(currentYear)
        mainViewModel.headerMonthLabel.accept(currentMonth)
        mainViewModel.readRealmDateString.accept(currentFilterDate)
    }
    
    // 오늘 날짜 이후로는 클릭이 안된다.(미래시불가능)
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    // 특정 날짜에 이미지 세팅
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let dateStr = dateFormatter.string(from: date)
        for diary in diarys {
            if diary.date.contains(dateStr) == true  {
                return UIImage(named: "\(diary.mood)")
            }
        }
        return nil
    }
    
    // 특정 날짜에 숫자 지우기
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        let dateStr = dateFormatter.string(from: date)
        for diary in diarys {
            if diary.date.contains(dateStr) == true  {
                return ""
            }
        }
        return nil
    }
}

extension MainViewController {
    fileprivate func createDiaryPresentationController(_ createDiaryViewController: CreateDiaryViewController) {
        if let sheet = createDiaryViewController.sheetPresentationController {
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
    
    fileprivate func diaryViewPresentationController(_ diaryViewController: DiaryViewController) {
        if let sheet = diaryViewController.sheetPresentationController {
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

extension MainViewController: CreateDiaryVCDelegate {
    func saveButtonTapped() {
        self.view.makeToast("오늘의 기분을 등록 완료했어요.", duration: 3.0, position: .bottom, image: UIImage(named: "success"), style: .init())
    }
}
