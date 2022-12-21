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
    var sectionArray: [String] = []{ // ["202212", "202211", "202210", "202209", "202208", "202207", "202206"]
        didSet {
            // 데이터가들어오면
            changeyearMonth()
        }
    }
    var sectionTitles: [String] = [] // ["2022년 12월", "2022년 11월", "2022년 10월"]
    var yearMonthDC: [String : [Diary]] = [:]
    
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurUI()
        registerCell()
        bindUI()
    }
    
    // ["202212", "202211", "202210", "202209", "202208", "202207", "202206"] 를
    // ["2022년 12월", "2022년 11월", "2022년 10월", "2022년 08월", "2022년 06월"] 이런 형태로 바꾸기
    func changeyearMonth() {
        for dateString in sectionArray {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMM"
            let date = formatter.date(from: dateString)!
            formatter.dateFormat = "yyyy년 MM월"
            sectionTitles.append(formatter.string(from: date))
        }
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
        let yearMonth = Dictionary(grouping: diary, by: { diary in
            let yearMonthFix = String(diary.date.prefix(6))
            if sectionArray.contains(yearMonthFix) {
                return yearMonthFix
            } else {
                return ""
            }
        })
        self.yearMonthDC = yearMonth.mapValues { $0.sorted(by: {$0.date > $1.date})}
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
        return sectionTitles[section]
    }
    
    // 헤더의 색과 컬러
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .cellHeaderBGColor
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = .todayContentsColor
    }
    
    // cell의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let haha = sectionArray[section] // 앞에6자리숫자
        return yearMonthDC[self.sectionArray[section]]!.count
    }
    
    // cell안에 들어갈 내용들
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DiaryCell
        
        // 순서가 반대로 되어있다 해결해야함.
        let haha = sectionArray[indexPath.section]
        print("roroo")
        print(yearMonthDC[haha]![indexPath.row])
        
        
        // diary[indexPath.row].mood 숫자
        let moodImage = mood.moodImageString[yearMonthDC[haha]![indexPath.row].mood]
        let moodLabel = mood.moodLabel[yearMonthDC[haha]![indexPath.row].mood]
        // date에서 일자만 가져오기
        let fulldate = yearMonthDC[haha]![indexPath.row].date
        let day = fulldate[fulldate.index(fulldate.endIndex, offsetBy: -2)...]
        
        cell.moodImage.image = UIImage(named: moodImage)
        cell.moodLabel.text = moodLabel
        cell.contentsLabel.text = yearMonthDC[haha]![indexPath.row].contents
        cell.dateLabel.text = String(day)

        cell.selectionStyle = .none
        return cell
    }
    
    // cell을 클릭했을때, 실행될 메서드정의할곳
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
