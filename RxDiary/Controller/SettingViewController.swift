//
//  SettingViewController.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/14.
//

import UIKit

private let reuseIdentifier = "SettingCell"

class SettingViewController: UIViewController {
    
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
    }
    
    // 모델 풀스크린으로 화면이 넘어와야한다.
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configurUI()
        registerCell()
    }
    
    func configurUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        configureNaviBar()
    }
    
    func configureNaviBar() {
        self.title = "설정"
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func registerCell() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // register cell 등록
        tableView.register(SettingCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    @objc func pop() {
        // 나중에
    }
}

// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alarmViewContoller = AlarmViewContoller()
        alarmViewContoller.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(alarmViewContoller, animated: true)
    }
}
