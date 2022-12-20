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
    
    private var mainViewModel = MainViewModel()
    private var disposeBag = DisposeBag()
    private var mood = Mood()
    var diary: [Diary] = []
    
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
//        $0.backgroundColor = .red
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurUI()
        registerCell()
        bindUI()
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
    
    func bindUI() {
        // 전체 일기를 가져온다. -> 이걸로 cell 화면 부분 만들기.
        mainViewModel.fullDiaryObservable
            .map { $0.sorted(byKeyPath: "date", ascending: false) } // 최신순으로 정렬
            .map { Array($0) } // Diary배열로 만들기
            .subscribe (onNext: { [weak self] in
                guard let self = self else { return }
                self.diary = $0
            }).disposed(by: disposeBag)
    }
}

extension FullDiaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 전체 []에서 202212,202211과 같이 달까지 끊어서 배열을 분리한다음, 각가 그달에 맞춰서 날짜를 넣어줘야한다.
    
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
        return diary.count
    }
    
    // cell안에 들어갈 내용들
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DiaryCell
        // diary[indexPath.row].mood 숫자
        let moodImage = mood.moodImageString[diary[indexPath.row].mood]
        let moodLabel = mood.moodLabel[diary[indexPath.row].mood]
        // date에서 일자만 가져오기
        let fulldate = diary[indexPath.row].date
        let day = fulldate[fulldate.index(fulldate.endIndex, offsetBy: -2)...]
        
        cell.moodImage.image = UIImage(named: moodImage)
        cell.moodLabel.text = moodLabel
        cell.contentsLabel.text = diary[indexPath.row].contents
        cell.dateLabel.text = String(day)

        cell.selectionStyle = .none
        return cell
    }
    
    // cell을 클릭했을때, 실행될 메서드정의할곳
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}