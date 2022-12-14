//
//  AlarmViewContoller.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/14.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxRealm
import RxCocoa

class AlarmViewContoller: UIViewController {
    
    private let alarmSettingView = AlarmSettingView()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurUI()
//        datePickerSetting()
        bundTap()
    }
    
    func configurUI() {
        view.backgroundColor = .white

        view.addSubview(alarmSettingView)
        alarmSettingView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.left.right.equalToSuperview()
        }
        
        configureNaviBar()
    }
    
    func configureNaviBar() {
        self.title = "알림"
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
//    func datePickerSetting() {
//        datePicker.datePickerMode = .time
//        datePicker.locale = Locale(identifier: "ko_KR")
//        datePicker.timeZone = .autoupdatingCurrent
//        datePicker.preferredDatePickerStyle = .wheels
//    }
    
    func bundTap() {
        self.alarmSettingView.timeBackView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                // 데이터피커가 아래서 숏을 ㅗ켜지고 그 날짜를 선택해서 적용을 누르면
                // 시간의 text가 와서 저장이 된다.
                let addAlertViewController = AddAlertViewController()
                addAlertViewController.delegate = self
                self.addAlertViewPresentationController(addAlertViewController, self)
                self.present(addAlertViewController, animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
}

extension AlarmViewContoller: AddAlertViewControllerDelegate {
    func sendDate(pickerDate: Date) {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .none
        dateformatter.timeStyle = .short
        let date = dateformatter.string(from: pickerDate)
        print(date)
        self.alarmSettingView.time.text = date
    }
}

extension AlarmViewContoller: UISheetPresentationControllerDelegate {
    fileprivate func addAlertViewPresentationController(_ addAlertViewController: AddAlertViewController, _ self: AlarmViewContoller) {
        if let sheet = addAlertViewController.sheetPresentationController {
            //크기 변하는거 감지
            sheet.delegate = self
            sheet.detents = [
                .custom { context in
                    return context.maximumDetentValue * 0.3
                }
            ]
            sheet.preferredCornerRadius = 20
            
            //시트 상단에 그래버 표시 (기본 값은 false)
            sheet.prefersGrabberVisible = true
        }
    }
}
