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
    private var emptyView = EmptyView()
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
        makeyearMonthDC()
    }
    
    func configurUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        if diary.isEmpty {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
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
    
    func makeyearMonthDC() {
        let yearMonth = Dictionary(grouping: diary, by: { diary in
            let yearMonthFix = String(diary.date.prefix(6))
            return yearMonthFix
        }).mapValues { $0.sorted(by: {$0.date > $1.date}) }
        self.yearMonthDC = yearMonth
        
//        원래 내코드
//        let yearMonth = Dictionary(grouping: diary, by: { diary in
//            let yearMonthFix = String(diary.date.prefix(6))
//            if sectionArray.contains(yearMonthFix) {
//                return yearMonthFix
//            } else {
//                return ""
//            }
//        })
//        self.yearMonthDC = yearMonth.mapValues { $0.sorted(by: {$0.date > $1.date})}
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
}

extension FullDiaryViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        let yearMonthDCKey = sectionArray[indexPath.section]
        let indexNumber = yearMonthDC[yearMonthDCKey]![indexPath.row]
        let fulldate = indexNumber.date
        
        // cell에 들어갈 내용들
        let moodImage = mood.moodImageString[indexNumber.mood]
        let moodLabel = mood.moodLabel[indexNumber.mood]
        let day = fulldate[fulldate.index(fulldate.endIndex, offsetBy: -2)...]
        
        // cell에 데이터 넣어주기
        cell.moodImage.image = UIImage(named: moodImage)
        cell.moodLabel.text = moodLabel
        cell.contentsLabel.text = indexNumber.contents
        cell.dateLabel.text = String(day)
        cell.selectionStyle = .none
        
        return cell
    }
    
    // cell을 클릭했을때, 실행될 메서드정의할곳
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let yearMonthDCKey = sectionArray[indexPath.section]
        let indexNumber = yearMonthDC[yearMonthDCKey]![indexPath.row]
        
        let diaryViewController = DiaryViewController()
        diaryViewController.delegate = self
        diaryViewController.date = indexNumber.date
        self.diaryViewPresentationController(diaryViewController)
        self.present(diaryViewController, animated: true)
    }
}

extension FullDiaryViewController: UISheetPresentationControllerDelegate {
    fileprivate func diaryViewPresentationController(_ diaryViewController: DiaryViewController) {
        if let sheet = diaryViewController.sheetPresentationController {
            //크기 변하는거 감지
            sheet.delegate = self
            sheet.detents = [
                .custom { context in
                    return context.maximumDetentValue * 0.85
                }
            ]
            sheet.preferredCornerRadius = 20
            
            //시트 상단에 그래버 표시 (기본 값은 false)
            sheet.prefersGrabberVisible = true
        }
    }
}

extension FullDiaryViewController: DiaryVCDelegate {
    func buttonTapped() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
