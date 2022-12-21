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
    var sectionArray: [String] = [] // 202212 202211 202210
    var testDC: [String : [Diary]] = [:]
    
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurUI()
        registerCell()
        bindUI()
        
        var ee = Dictionary(grouping: diary, by: { d in
            var e = String(d.date.prefix(6))
            print(e)
            if sectionArray.contains(e) {
                return e
            } else {
                return "Other"
            }
        } )
        
//                var q = ee.sorted(by: {$0.key > $1.key })
        self.testDC = ee.mapValues { $0.sorted(by: {$0.date > $1.date})}
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
    
    // init할떄, 배열을 넣어준다면 view가 뜨기전에 배열을 알수있고, 그러면 섹션도 잘나오지 않을까?
    func bindUI() {
        // 전체 일기를 가져온다. -> 이걸로 cell 화면 부분 만들기.
//        mainViewModel.fullDiaryObservable
//            .map { $0.sorted(byKeyPath: "date", ascending: false) } // 최신순으로 정렬
//            .map { Array($0) } // Diary배열로 만들기
//            .subscribe (onNext: { [weak self] in
//                guard let self = self else { return }
//                self.diary = $0
//            }).disposed(by: disposeBag)
    }
}

extension FullDiaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 전체 []에서 202212,202211과 같이 달까지 끊어서 배열을 분리한다음, 각가 그달에 맞춰서 날짜를 넣어줘야한다.
    
    // 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    // 섹션의 타이틀
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray[section]
    }
    
    // 헤더의 색과 컬러
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .cellHeaderBGColor
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = .todayContentsColor
    }
    
    // cell의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let haha = sectionArray[section] // 앞에6자리숫자
        return testDC[self.sectionArray[section]]!.count
    }
    
    // cell안에 들어갈 내용들
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DiaryCell
        
        // 순서가 반대로 되어있다 해결해야함.
        let haha = sectionArray[indexPath.section]
        print("roroo")
        print(testDC[haha]![indexPath.row])
        
        
        // diary[indexPath.row].mood 숫자
        let moodImage = mood.moodImageString[testDC[haha]![indexPath.row].mood]
        let moodLabel = mood.moodLabel[testDC[haha]![indexPath.row].mood]
        // date에서 일자만 가져오기
        let fulldate = testDC[haha]![indexPath.row].date
        let day = fulldate[fulldate.index(fulldate.endIndex, offsetBy: -2)...]
        
        cell.moodImage.image = UIImage(named: moodImage)
        cell.moodLabel.text = moodLabel
        cell.contentsLabel.text = testDC[haha]![indexPath.row].contents
        cell.dateLabel.text = String(day)

        cell.selectionStyle = .none
        return cell
    }
    
    // cell을 클릭했을때, 실행될 메서드정의할곳
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
