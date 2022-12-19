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
        
//        이거 이용해서 버튼이 isOn인지 아닌지 해주기 noti를 만들어야한다.
//        처음 킬때, Realm에서 객체를 꺼내와서 true인지 false인지 확인해주고 값을 넣어줘야한다.
//        위에 값은 VM에서 적용을해야한다.
//        self.alarmSettingViewModel.buttonState
//            .asDriver(onErrorJustReturn: false)
//            .drive(self.alarmSettingView.alarmSwitch.rx.isOn)
//            .disposed(by: disposeBag)
    }
    
    func bindTap() {
        
        // 여기서 isOn했는지 안했는지 값을 어떻게 저장하고 불러올것인가?
        self.alarmSettingView.alarmSwitch.rx.isOn
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: {
                if $0 == true {
                    self.alarmSettingViewModel.buttonState.accept($0) // 버튼 상태 넣어주기
                    self.alarmSettingView.timeBackView.layer.opacity = 1.0
                    print("realm에 데이터 넣어주기")
                    
                } else {
                    // realm에 데이터 삭제하고
                    self.alarmSettingViewModel.buttonState.accept($0) // 버튼 상태 넣어주기
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
        print(#function)
        print("여기서 데이터를 받고 relam에 객체 추가시키기.")
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
