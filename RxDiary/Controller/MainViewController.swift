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

class MainViewController: UIViewController, UISheetPresentationControllerDelegate {

    var mainView = MainView()
    var mainViewModel = MainViewModel()
    var disposeBag = DisposeBag()
    private let dateFormatter = DateFormatter()
    
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
            self.present(createDiaryViewController, animated: true)
        }.disposed(by: disposeBag)
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
        let currentMonth = mainViewModel.MonthDateFormatter.string(from: currentPage)
        
        mainViewModel.headerYearLabel.accept(currentYear)
        mainViewModel.headerMonthLabel.accept(currentMonth)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(#function)
    }
    
    // 오늘 날짜 이후로는 클릭이 안된다.(미래시불가능)
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}
