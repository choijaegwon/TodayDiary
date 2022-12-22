//
//  AddAlertViewController.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/14.
//

import UIKit
import Then
import SnapKit

protocol AddAlertViewControllerDelegate: AnyObject {
    func sendDate(pickerDate: Date)
}

class AddAlertViewController: UIViewController {

    var picker = UIDatePicker()
    weak var delegate: AddAlertViewControllerDelegate?
    
    lazy var sendButton = UIButton().then {
        $0.setTitle("적용", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurUI()
        datePickerUI()
        
    }
    
    func configurUI() {
        view.backgroundColor = .white
        
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints {
//            $0.center.equalToSuperview()
            $0.right.equalToSuperview().inset(30)
            $0.top.equalToSuperview().inset(24)
        }
        
        view.addSubview(picker)
        picker.snp.makeConstraints {
            $0.top.equalTo(sendButton.snp.bottom).offset(10)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(200)
            $0.bottom.equalToSuperview()
        }
        
    }
    
    func datePickerUI() {
        self.picker.datePickerMode = .time
        self.picker.preferredDatePickerStyle = .wheels
        self.picker.locale = Locale(identifier: "ko_KR")
        self.picker.timeZone = .autoupdatingCurrent
    }
    
    @objc func sendButtonTapped() {
        self.delegate?.sendDate(pickerDate: self.picker.date)
        self.dismiss(animated: true)
    }
}
