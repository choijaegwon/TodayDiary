//
//  StaryViewController.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class StartViewController: UIViewController {
    
    private var startView = StartView()
    private var startViewModel = StartViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurUI()
        lastMonthDate()
        bindUI()
        bindTap()
    }
    
    func configurUI() {
        view.backgroundColor = .white
        
        view.addSubview(startView)
        startView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func lastMonthDate() {
        // 하루 전날 값을 대입해준다. 그이유는 매월1일만 이뷰가 보일거기때문이다.
        let currentFilterDate = startViewModel.filterDateDateFormatter.string(from: Date(timeIntervalSinceNow: -86400))
        startViewModel.readRealmDateString.accept(currentFilterDate)
    }
    
    func bindUI() {
        startViewModel.headerMonthLabel
            .asDriver(onErrorJustReturn: "")
            .drive(startView.headerMonthLabel.rx.text)
            .disposed(by: disposeBag)
        
        startViewModel.lastSumMood
            .asDriver(onErrorJustReturn: "")
            .drive(startView.headerSumLabel.rx.text)
            .disposed(by: disposeBag)
        
        startViewModel.lastSumMood
            .asDriver(onErrorJustReturn: "")
            .drive(startView.sumLabel1.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindTap() {
        // 뷰 내리기
        startView.dismissbutton.rx.tap.bind{ [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
            print(#function)
        }.disposed(by: disposeBag)
    }
    
}
