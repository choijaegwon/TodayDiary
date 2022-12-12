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


class MainViewController: UIViewController, UISheetPresentationControllerDelegate {

    private var mainView = MainView()
    private var mainViewModel = MainViewModel()
    private var disposeBag = DisposeBag()
    private let dateFormatter = DateFormatter()
    private lazy var diarys:[Diary] = [] {
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
        bindEvent()
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
        
        // rightBarButtonItem
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
        
        mainViewModel.mainSumMood
            .asDriver(onErrorJustReturn: "")
            .drive(mainView.sumMood.rx.text)
            .disposed(by: disposeBag)
        
        // readRealmDateString의 결과값으로 diaryObservable의 값을 필터링해서 해당 달에 해당하는 배열만 가져오도록함.
        mainViewModel.sortedDiaryObservable
            .map { Array($0) } // [Diary]로 바꿔준다.
            .subscribe (onNext: {
                self.diarys = $0
//                print($0)
            }).disposed(by: disposeBag)
        // 위에있는 값을 이미지와 스트링으로 각각만들어야하나?
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
        
        mainView.mainquestionbutton.rx.tap.bind {
            print(#function)
            // 넘어갈 현재날짜.
            let nowDate = self.dateFormatter.string(from: Date())
            // 만약 데이터가 있으면 View를 보여주는 화면으로 옮기고
            // 오늘 데이터가 없으면, 새로 만드는 화면으로 옮겨줘야한다.
            let createDiaryViewController = CreateDiaryViewController()
            createDiaryViewController.date = nowDate
            self.presentationController(createDiaryViewController)
            self.present(createDiaryViewController, animated: true)
        }.disposed(by: disposeBag)
    }
    
    func bindEvent() {
//        mainViewModel.diaryObservable
//                    .map { $0.sorted(byKeyPath: "date", ascending: true)
//                        .filter(NSPredicate(format: "date like '\(self.bb)**'")) }
//                    .subscribe {
//                        print($0)
//                    }.disposed(by: disposeBag)
    }
    
    @objc func handleSetting() {
        print(#function)
    }
}

extension MainViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(#function)
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
    fileprivate func presentationController(_ createDiaryViewController: CreateDiaryViewController) {
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
}
