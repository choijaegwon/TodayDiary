//
//  FullDiaryViewController.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RealmSwift

class FullDiaryViewController: UIViewController {
    
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .red
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurUI()
    }
    
    func configurUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
        
        configureNaviBar()
    }
    
    func configureNaviBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
    }
}
