//
//  AlarmViewContoller.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/14.
//

import UIKit
import SnapKit
import Then

private let reuseIdentifier = "AlarmCell"

class AlarmViewContoller: UIViewController {
    
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurUI()
        registerCell()
    }
    
    func configurUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(68)
        }
        
        configureNaviBar()
    }
    
    func configureNaviBar() {
        self.title = "알림"
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func registerCell() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // register cell 등록
        tableView.register(AlarmCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}

// MARK: - UITableViewDataSource

extension AlarmViewContoller: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AlarmCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
}

extension AlarmViewContoller: UITableViewDelegate {
    
}
