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

private let reuseIdentifier = "DiaryCell"

class FullDiaryViewController: UIViewController {
    
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
//        $0.backgroundColor = .red
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
            $0.left.right.bottom.equalToSuperview()
        }
        
        configureNaviBar()
    }
    
    func configureNaviBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func registerCell() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // register cell 등록
        tableView.register(DiaryCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}

extension FullDiaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // 섹션의 타이틀
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "2022년 12월" //header의 타이틀을 여기서 정해줘야한다.
    }
    
    // 헤더의 색과 컬러
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .cellHeaderBGColor
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = .todayContentsColor
    }
    
    // cell의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    // cell안에 들어갈 내용들
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DiaryCell
        cell.selectionStyle = .none
        return cell
    }
    
    // cell을 클릭했을때, 실행될 메서드정의할곳
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
