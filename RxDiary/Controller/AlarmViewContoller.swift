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
import RealmSwift
import RxCocoa

class AlarmViewContoller: UIViewController {
    
    private let alarmSettingView = AlarmSettingView()
    private let alarmSettingViewModel = AlarmSettingViewModel()
    private var disposeBag = DisposeBag()
    var date: String?
    let realm = try! Realm()
    private lazy var alert = self.realm.objects(Alert.self)
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurUI()
        bindUI()
        bindTap()
        
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
        
        self.alarmSettingViewModel.buttonState
            .asDriver(onErrorJustReturn: false)
            .drive(self.alarmSettingView.alarmSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    
    func bindTap() {
        
        self.alarmSettingView.alarmSwitch.rx.isOn
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: {
                // 스위치가 켜져있다면?
                if $0 == true {
                    self.alarmSettingViewModel.buttonState.accept($0) // 버튼 상태 넣어주기
                    self.alarmSettingView.timeBackView.layer.opacity = 1.0
                    
                    let dateString = self.alarmSettingViewModel.timeLabel.value
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .none
                    dateFormatter.timeStyle = .short
                    let dateDate = dateFormatter.date(from: dateString)!
                    
                    // 현재시간을 알람으로 넣어놓기
                    let alert = Alert()
                    alert.date = dateDate
                    alert.id = "1"
                    try! self.realm.write {
                        self.realm.add(alert, update: .modified)
                    }
                    self.userNotificationCenter.addNotificationRequest(by: alert)
                } else {
                    // realm에 데이터 삭제하고
                    self.alarmSettingViewModel.buttonState.accept($0) // 버튼 상태 넣어주기
                    self.alarmSettingView.timeBackView.layer.opacity = 0.2
                    self.userNotificationCenter.removePendingNotificationRequests(withIdentifiers: ["1"] )
                    try? self.realm.write{
                        self.realm.delete(self.alert)
                    }
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

        // 보낼 alarm 생성
        let alert = Alert()
        // 데이터피커에서 선택한 시간 넣어주는 코드
        alert.date = pickerDate
        alert.id = "1"
        // noti 예약
        // 오늘의 일기가있으면 오늘 알람 보내는걸 없애줘야하는 분기코드를 만들어줘야한다.
        self.userNotificationCenter.addNotificationRequest(by: alert)
        // noti 예약한거 realm에 보내기
        try! self.realm.write {
            self.realm.add(alert, update: .modified)
        }

        // 시간설정 뷰에 넣어주는 코드들
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
