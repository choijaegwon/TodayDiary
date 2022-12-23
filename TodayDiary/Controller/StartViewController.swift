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
    private var moodInt: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurUI()
        lastMonthDate()
        bindUI()
        bindTap()
        monthLabel()
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
        
        startViewModel.lastSumMood
            .subscribe(onNext: {
                self.moodInt = Int($0)!
            }).disposed(by: disposeBag)
    }
    
    func bindTap() {
        // 뷰 내리기
        startView.dismissbutton.rx.tap.bind{ [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
    
    func monthLabel() {
        if self.moodInt >= 0 && self.moodInt <= 9 {
            self.startView.monthLabel.text = "정말로 최고로 둥근"
            self.startView.monthLabel2.text = "한 달을 보내셨네요!"
        } else if self.moodInt >= 10 && self.moodInt <= 16 {
            self.startView.monthLabel.text = "좋은 일만 가득했던"
            self.startView.monthLabel2.text = "한 달을 보내셨네요!"
        } else {
            self.startView.monthLabel.text = "그래도 뒤돌아 보면 생각보다 둥근"
            self.startView.monthLabel2.text = "한 달을 보낸 거 같지 않나요?"
        }
        
        switch self.moodInt {
        case 0...2:
            return self.startView.monthImage.image = UIImage(named: "mood\(self.moodInt)")
        case 10...15:
            return self.startView.monthImage.image = UIImage(named: "mood10")
        default:
            return self.startView.monthImage.image = UIImage(named: "mood16")
        }
    }
}
