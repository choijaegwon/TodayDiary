//
//  CreateDiaryViewController.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/11.
//

import UIKit
import RxCocoa
import RxSwift

class CreateDiaryViewController: UIViewController {
    
    var createDiaryView = CreateDiaryView()
    var disposeBag = DisposeBag()
    // 사용할때 언래핑해줘야한다.
    // MainVC에서 날짜데이터를 받는 변수
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(date!)
        configurUI()
        bindTap()
    }
    
    func configurUI() {
        view.backgroundColor = .white
        
        view.addSubview(createDiaryView)
        createDiaryView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        createDiaryView.mood0Button.isSelected = true
    }
    
    func bindTap() {
        createDiaryView.saveButton.rx.tap.bind {
            print(#function)
        }.disposed(by: disposeBag)
    }
}
