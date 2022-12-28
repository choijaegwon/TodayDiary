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
import RxGesture
import Then

class MainViewController: UIViewController, UISheetPresentationControllerDelegate {

    private var mainView = MainView()
    private var mainViewModel = MainViewModel()
    private var disposeBag = DisposeBag()
    private var mood = Mood()
    private let dateFormatter = DateFormatter()
    private var todayStrig: String?
    private var dateSet: [String] = []
    private var yearMonths: [String] = [] // ["202212", "202211", "202210", "202209", "202208", "202207", "202206"]
    private lazy var diarys:[Diary] = [] { // 몇년몇월 이렇게 필터링 된 값만 가져오는 배열
        didSet {
            // 만약 배열안에 오늘이 들어있으면 mainview안에 calnder의 둥근거 없애버리기
            self.mainView.calendar.reloadData()
        }
    }
    private lazy var fullDiary: [Diary] = [] { // 전체 배열을 가져온다.
        didSet {
            self.reloadyearMonths()
            self.mainView.calendar.reloadData()
        }
    }
    
    private lazy var todayDiary: [Diary] = [] {
        didSet {
            self.mainView.calendar.reloadData()
        }
    }
    
    // 메뉴 버튼
    private let menuButtonUI = UIView().then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .labelBackgroundColor
    }
    
    private let diaryLabel = UILabel().then {
        $0.text = "일기"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
    }
    
    private let movieLabel = UILabel().then {
        $0.text = "영화"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
    }
    
    private let bookLabel = UILabel().then {
        $0.text = "책"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "YYYYMMdd"
        mainView.calendar.delegate = self
        mainView.calendar.dataSource = self
        self.todayStrig = dateFormatter.string(from: Date())
        print(#function)
        configurUI()
        bindUI()
        bindTap()
        day01() // 오늘이 01이면 지난달 뷰 보여주기
    }
    
    func configurUI() {
        view.backgroundColor = .white
        view.addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.right.left.bottom.equalToSuperview()
        }
        configureNaviBar()
        
        view.addSubview(menuButtonUI)
        menuButtonUI.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalToSuperview().offset(16)
        }
        
        let menuStack = UIStackView(arrangedSubviews: [diaryLabel, movieLabel, bookLabel])
        menuStack.axis = .vertical
        menuStack.spacing = 20
        
        menuButtonUI.addSubview(menuStack)
        menuStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
            $0.center.equalToSuperview()
        }
        
        menuButtonUI.isHidden = true
    }
    
    func configureNaviBar() {
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting"), style: .plain, target: self, action: #selector(handleSetting))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "diary"), style: .plain, target: self, action: #selector(handleSetting2))
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
//         전체 일기를 가져온다. -> 이걸로 cell 화면 부분 만들기.
        mainViewModel.fullDiaryObservable
            .map { Array($0) }
            .subscribe (onNext: { [weak self] in
                guard let self = self else { return }
                self.fullDiary = $0
            }).disposed(by: disposeBag)
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
            // 넘어갈 현재날짜.
            let nowDate = self.dateFormatter.string(from: Date())
            
            // 만약 데이터가 있으면 View를 보여주는 화면으로 옮기고
            // 오늘 데이터가 없으면, 새로 만드는 화면으로 옮겨줘야한다.
            if self.diarys.map({ $0.date }).contains(nowDate) {
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
        
        // 이뷰가 보인다는건 today가 있다는 소리니까 바로 다이어리뷰를 보여주면 된다.
        mainView.todayBackgorund.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let diaryViewController = DiaryViewController()
                diaryViewController.date = self.todayStrig
                self.diaryViewPresentationController(diaryViewController)
                self.present(diaryViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        diaryLabel.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let fullDiaryViewController = FullDiaryViewController()
                fullDiaryViewController.diary = self.fullDiary
                fullDiaryViewController.sectionArray = self.yearMonths
                fullDiaryViewController.modalPresentationStyle = .fullScreen
                self.menuButtonUI.isHidden = true
                self.navigationController?.pushViewController(fullDiaryViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        movieLabel.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let movieMainViewController = MovieMainViewController()
                movieMainViewController.modalPresentationStyle = .fullScreen
                self.menuButtonUI.isHidden = true
                self.navigationController?.pushViewController(movieMainViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        bookLabel.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let bookMainViewController = BookMainViewController()
                bookMainViewController.modalPresentationStyle = .fullScreen
                self.menuButtonUI.isHidden = true
                self.navigationController?.pushViewController(bookMainViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func day01() {
        let day01 = todayStrig![todayStrig!.index(todayStrig!.endIndex, offsetBy: -2)...]
        if day01 == "01" {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: StartViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false, completion: nil)
            }
        }
    }
    
    func reloadyearMonths() {
        fullDiary.map { $0.date }.map {
            self.dateSet.append(String($0.prefix(6)))
        } // [202212, 202212, 202211] 등 년과월들이 다담겨있다.
        // 중복제거
        self.yearMonths = Array(Set(self.dateSet)).sorted(by: >)
    }
    

    
    @objc func handleSetting() {
        let settingViewController = SettingViewController()
        settingViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    @objc func handleSetting2() {
        
        if menuButtonUI.isHidden == true {
            menuButtonUI.isHidden = false
        } else {
            menuButtonUI.isHidden = true
        }
        
//        만약에 이버튼이 눌렀으면 menuButtonUI 버튼을 보여주고 다시 눌리면 menuButtonUI버튼을 숨긴다.
//        menuButtonUI
        
//        let bookMainViewController = BookMainViewController()
//        bookMainViewController.modalPresentationStyle = .fullScreen
//        navigationController?.pushViewController(bookMainViewController, animated: true)
        
//        let movieMainViewController = MovieMainViewController()
//        movieMainViewController.modalPresentationStyle = .fullScreen
//        navigationController?.pushViewController(movieMainViewController, animated: true)
        
//        원래 코드
//        let fullDiaryViewController = FullDiaryViewController()
//        fullDiaryViewController.diary = self.fullDiary
//        fullDiaryViewController.sectionArray = self.yearMonths
//        fullDiaryViewController.modalPresentationStyle = .fullScreen
//        navigationController?.pushViewController(fullDiaryViewController, animated: true)
        
    }
    
//    @objc func notiReload() {
//        print(#function)
//        configurUI()
//        bindUI()
//        bindTap()
//        day01()
//    }
}

extension MainViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    // 날이 선택되었을떄 메서드
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let seletedDate = dateFormatter.string(from: date)
        // 만약 데이터가 있으면 View를 보여주는 화면으로 옮기고
        // 오늘 데이터가 없으면, 새로 만드는 화면으로 옮겨줘야한다.
        if self.diarys.map({ $0.date }).contains(seletedDate) {
            let diaryViewController = DiaryViewController()
            diaryViewController.date = seletedDate
            self.diaryViewPresentationController(diaryViewController)
            self.present(diaryViewController, animated: true)
        } else {
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
