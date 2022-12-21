//
//  StaryViewController.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/21.
//

import UIKit
import SnapKit

class StartViewController: UIViewController {
    
    private var startView = StartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(startView)
        startView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        view.backgroundColor = .white
    }
    
}
