//
//  AddMovieDateViewController.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/25.
//

import UIKit
import Then
import SnapKit

protocol AddMovieDateVCDelegate: AnyObject {
    func sendDate(pickerDate: Date)
}

class AddMovieDateViewController: UIViewController {

    var picker = UIDatePicker()
    weak var delegate: AddMovieDateVCDelegate?
    
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
        self.picker.datePickerMode = .date
        self.picker.timeZone = TimeZone(identifier: "KST")
        self.picker.preferredDatePickerStyle = .wheels
        self.picker.locale = Locale(identifier: "ko_KR")
    }
    
    @objc func sendButtonTapped() {
        self.delegate?.sendDate(pickerDate: self.picker.date)
        self.dismiss(animated: true)
    }
}
