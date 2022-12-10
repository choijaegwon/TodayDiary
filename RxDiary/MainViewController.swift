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

class MainViewController: UIViewController {

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
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.headerYearLabel.rx.text)
            .disposed(by: disposeBag)
        
        mainViewModel.headerMonthLabel
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.headerMonthLabel.rx.text)
            .disposed(by: disposeBag)
        
        mainViewModel.headerMonthLabel
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        mainViewModel.mainSumMood
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.sumMood.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindTap() {
        mainView.leftButton.rx.tap.bind {
            self.mainView.calendar.setCurrentPage(self.mainViewModel.getPreviousMonth(date: self.mainView.calendar.currentPage), animated: true)
        }.disposed(by: disposeBag)
        
        mainView.rightButton.rx.tap.bind {
            self.mainView.calendar.setCurrentPage(self.mainViewModel.getNextMonth(date: self.mainView.calendar.currentPage), animated: true)
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
        
        mainViewModel.headerYearLabel.onNext(currentYear)
        mainViewModel.headerMonthLabel.onNext(currentMonth)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(#function)
    }
    
    // 오늘 날짜 이후로는 클릭이 안된다.(미래시불가능)
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}
