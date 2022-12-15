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
    private let alarmSettingViewModel = AlarmSettingViewModel()
    private var disposeBag = DisposeBag()
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurUI()
        bindUI()
        bindTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
    
    func bindUI() {
        self.alarmSettingViewModel.timeLabel
            .asDriver(onErrorJustReturn: "오후 10:00")
            .drive(self.alarmSettingView.time.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindTap() {
        
        self.alarmSettingView.alarmSwitch.rx.isOn
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: {
                if $0 == true {
                    self.alarmSettingView.timeBackView.layer.opacity = 1.0
                    print("realm에 데이터 넣어주기")
                    
                } else {
                    // realm에 데이터 삭제하고
                    self.alarmSettingView.timeBackView.layer.opacity = 0.2
                    print("터치안되게")
                    print("삭제기능")
                }
            })
            .disposed(by: disposeBag)
        
        self.alarmSettingView.timeBackView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                if self.alarmSettingView.alarmSwitch.isOn {
                    let addAlertViewController = AddAlertViewController()
                    addAlertViewController.delegate = self
                    self.addAlertViewPresentationController(addAlertViewController, self)
                    self.present(addAlertViewController, animated: false, completion: nil)
                } else {
                    return
                }
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
        self.alarmSettingViewModel.timeLabel.accept(date)
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
