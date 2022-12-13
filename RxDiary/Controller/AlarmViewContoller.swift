//
//  AlarmViewContoller.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/14.
//

import UIKit
import SnapKit
import Then

class AlarmViewContoller: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurUI()
        registerCell()
    }
    
    func configurUI() {
        view.backgroundColor = .white
        
        configureNaviBar()
    }
    
    func configureNaviBar() {
        self.title = "알림"
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func registerCell() {
        
    }
}
