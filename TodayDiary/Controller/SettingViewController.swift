//
//  SettingViewController.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/14.
//

import UIKit
//import Then
//import SnapKit

private let reuseIdentifier = "SettingCell"

class SettingViewController: UIViewController {
    
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
    }
    
//    추후, 리뷰기능 추가
//    lazy var reviewbutton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("앱 리뷰 쓰러 가기", for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
//        button.setTitleColor(.black, for: .normal)
//        button.layer.cornerRadius = 8
//        button.layer.masksToBounds = true
//        button.backgroundColor = UIColor.rgb(red: 255, green: 225, blue: 177)
//        button.addTarget(self, action: #selector(reviewButtonTapped), for: .touchUpInside)
//        return button
//    }()
    
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
        
//        view.addSubview(reviewbutton)
//        reviewbutton.snp.makeConstraints {
//            $0.top.equalTo(250)
//            $0.left.right.equalToSuperview().inset(16)
//            $0.height.equalTo(68)
//        }
        
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
    
//    @objc func reviewButtonTapped() {
//        if let appstoreURL = URL(string: "https://apps.apple.com/kr/app/%EA%B0%81%EC%97%86%EB%8A%94-%EC%98%A4%EB%8A%98/id1661072044") {
//            var components = URLComponents(url: appstoreURL, resolvingAgainstBaseURL: false)
//            components?.queryItems = [
//              URLQueryItem(name: "action", value: "write-review")
//            ]
//            guard let writeReviewURL = components?.url else {
//                return
//            }
//            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
//        }
//    }
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
