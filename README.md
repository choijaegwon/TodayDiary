# 각없는 오늘(앱스토어 출시)

Github: https://github.com/choijaegwon/TodayDiary  
기간: 2022/11/28 → 2022/12/21  
사용기술: Alamofire, Cosmos, DLRadioButton, FSCalendar, IQKeyboardManagerSwift, MVVM, RealmSwift, RxAlamofire, RxCocoa, RxGesture, RxRealm, RxSwift, SnapKit, Then, Toast-Swift, UIKit, UITextView+Placeholder, userNotificationCenter, 네이버API사용

## 개요.

- 일기를 쓰며 하루, 한달을 돌아보는 앱

## 개발배경.

- 일기를 작성하는 앱들은 많은데, 한달을 모아서 어떤 한달이 되었는지 알려주는 앱들을 찾았는데 찾지못하였습니다. 시간에 맞춰서 알람을주고, 매월 1일이 되면 지난 한달을 어떻게 지냈는지 알려주는 앱이 있으면 좋겠다 생각을 하여 만들게 되었습니다.

## 앱스토어.

https://apps.apple.com/kr/app/%EA%B0%81%EC%97%86%EB%8A%94-%EC%98%A4%EB%8A%98/id1661072044

## 구현기능.

- 일기 쓰기
    - 날짜를 클릭하거나, 아래버튼을 클릭하면 일기를 쓸 수 있습니다.
- 일기 수정하기
    - 일기를 수정할 수 있습니다.
- 일기 한번에 보기
    - 일기를 한눈에 볼 수 있습니다.
- 알람 설정하기
    - 정한 시간에 알람소리가 울립니다.
- 지난 한달 보여주기
    - 매월 1일에 지난한달 어떻게 지냈는지 보여줍니다.
- 영화 후기 기능 추가
    - 영화 후기를 기록할 수 있습니다.
- 책 후기 기능 추가
    - 책 후기를 기록할 수 있습니다.

## 고민 & 구현 방법.

---

### Controller에 뷰를 그리니 Controller의 코드가 너무 커졌습니다.

- 해결방법: UIView로 뷰자체를 꺼내주고, MVVM패턴을 사용해서 코드를 분류 시켜 줬습니다.
    
![Untitled](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/3f7991f9-608f-4da1-a0a1-dbbbf32c1939)  
    

---

### 일기를 추가하면 해당날짜에 숫자대신, 일기에서 선택한 기분이 나타내는 걸 고민하였습니다.

- 해결방법: 날짜들을 String값으로 바꾸고, 일기에 해당하는 날짜가 포함되어있으면, 그 일기의 기분을
               이미지로 나타내 주었습니다. 또 동시에 그 날은 빈 문자열로 지정해주었습니다.
    
    ```swift
    // 특정 날짜에 이미지 세팅
        func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
            let dateStr = dateFormatter.string(from: date)
            for diary in diarys {
                if diary.date.contains(dateStr) == true  {
                    return UIImage(named: "\(diary.mood)")
                }
            }
            return nil
        }
        
        // 특정 날짜에 숫자 지우기
        func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
            let dateStr = dateFormatter.string(from: date)
            for diary in diarys {
                if diary.date.contains(dateStr) == true  {
                    return ""
                }
            }
            return nil
        }
    ```
    

---

### 하나의 Observable값의 결과값을 이용하여서, 결과값으로 다른 Observable에게 이벤트를 주고싶었습니다.

- 해결방법: 두개의 Observable을 flatMap으로 연결하여 사용하였습니다.
    
    ```swift
    // realm에서 가지고있는 배열가져오기
    lazy var diaryObservable = Observable.collection(from: diary).map { $0.sorted(byKeyPath: "date", ascending: true) }
    
    // 특정 달만 가져오는 Observable.
    lazy var sortedDiaryObservable = diaryObservable
        .flatMap { (filterDate: String) -> Observable<Results<Diary>> in
            return self.diaryObservable
                            .map { $0.sorted(byKeyPath: "date", ascending: true) // 오름차순 정렬
                            .filter(NSPredicate(format: "date like '\(filterDate)**'")) } // readRealmDateString이 가져온 값  
    		}
    ```
    
     readRealmDateString의 결과값으로 diaryObservable로 realm에서 가져온 일기의 데이터를 ma과 filter를 사용하여서 원하는 달만 모아주었습니다.
    

---

### 보고있는 달력이 바뀌면, 그달의 기분의 합과 달력들이 바뀌는걸 실시간으로 보여주는걸 어떻게 보여줄까 고민하였습니다.

- 해결방법: RxSwift를 적용하여 데이터 바인딩을하여 해결하였습니다.
    
    ```swift
    // 달이 바뀔때마다 불러오는 메서드
        func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            let currentPage = calendar.currentPage // 현재의 달 Date값.
            
            let currentYear = mainViewModel.headerYearDateFormatter.string(from: currentPage)
            let currentMonth = mainViewModel.monthDateFormatter.string(from: currentPage)
            let currentFilterDate = mainViewModel.filterDateDateFormatter.string(from: currentPage)
    
            mainViewModel.headerYearLabel.accept(currentYear)
            mainViewModel.headerMonthLabel.accept(currentMonth)
            mainViewModel.readRealmDateString.accept(currentFilterDate)
        }
    ```
    
    특정 달이 바뀔때 마다 headerYearLabel, headerMonthLabel, readRealmDateString라는
    
    BehaviorRelay에 accept하여 데이터를 보내주었습니다.
    
    ```swift
    mainViewModel.headerYearLabel
    		.asDriver(onErrorJustReturn: "")
        .drive(mainView.headerYearLabel.rx.text)
        .disposed(by: disposeBag)
            
    mainViewModel.headerMonthLabel
         .asDriver(onErrorJustReturn: "")
         .drive(mainView.headerMonthLabel.rx.text)
         .disposed(by: disposeBag)
            
    mainViewModel.headerMonthLabel
         .asDriver(onErrorJustReturn: "")
         .drive(mainView.monthLabel.rx.text)
         .disposed(by: disposeBag)
    ```
    
    데이터를 받아서 바로 화면에 뿌려주도록 바인딩 하였고, 
    
    UI는 에러가 나면 안되기 때문에 방지하고자 onErrorJustReturn로 빈스트링을 return해주었습니다.
    

---

### 오늘의 일기가 없으면 버튼을 생성해주고, 오늘의 일기가 있으면 버튼을 없애주고 싶었습니다.

- 해결방법: 일기를 관찰하다가, 데이터가 들어오면 뷰를 처리해주었습니다. 이때도 화면이 바뀌기때문에, 
MainScheduler.instance를 사용하였고, 메모리 릭이 발생하지 않게, 약한 참조로 바꾸어 주었습니다.
    
    ```swift
    // 오늘 일기 배열
    mainViewModel. 
    		.map { Array($0) }
        //여기서 메인으로 바꿔주고,
        .observe(on: MainScheduler.instance)
        .subscribe (onNext: { [weak self] in
    		    guard let self = self else { return }
            if $0.isEmpty == true { // 오늘 일기가 비어있으면
    		        self.mainView.todayBackgorund.isHidden = true
            } else { // 오늘 일기가 있으면 데이터 채워주기
                self.mainView.todayBackgorund.isHidden = false
                self.mainView.mainquestionbutton.isHidden = true
                $0.map { diary in
    		            self.mainView.todayMoodImage.image = UIImage(named: "\(diary.mood)")
                    self.mainView.todayMoodLabel.text = self.mood.moodLabel[diary.mood]
                    self.mainView.todayContentsLabel.text = diary.contents
    				            }
         }
    }).disposed(by: disposeBag)
    ```
    

---

### 년도와 달을 기준으로 정보를 가져와 최신순으로 배치하고 싶었습니다.

- 해결방법: 전체 일기를 가져온후, map을 사용해 6자리(년도와달)을 자르고, 배열에 넣어준후, Set을 사용해 중복을 제거하여 주었습니다.
    
    ```swift
    func reloadyearMonths() {
        fullDiary.map { $0.date }.map {
            self.dateSet.append(String($0.prefix(6)))
        } // [202212, 202212, 202211] 등 년과월들이 다담겨있다.
        // 중복제거
        self.yearMonths = Array(Set(self.dateSet)).sorted(by: >)
    }
    ```
    
    그 값을 넘겨준후, Dictionary을 사용하여, 키와 벨류 값으로 묶은후, 최신순으로 정렬해주었다.
    
    ```swift
    func makeyearMonthDC() {
        let yearMonth = Dictionary(grouping: diary, by: { diary in
            let yearMonthFix = String(diary.date.prefix(6))
            return yearMonthFix
        }).mapValues { $0.sorted(by: {$0.date > $1.date}) }
        self.yearMonthDC = yearMonth
    }
    ```
    
    6자리 숫자를 “키”값으로 사용하여 데이터를 모아주어서 년도와 달별로 모아주었다.
    
    ```swift
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
    ```
    

---

### 알람 설정을 하고, 껐다가 켜도 그 상태를 유지하고싶었고, 또 껐을때는 시간 설정을 할수 없게 만들고 싶었습니다.

- 해결방법: 우선, realm에서 데이터를 가져와 알람이 저장되어있는지 확인후, BehaviorRelay<Bool>에 넣어주고, 바인딩 해주었습니다.
    
    ```swift
    self.alarmSettingViewModel.buttonState
            .asDriver(onErrorJustReturn: false)
            .drive(self.alarmSettingView.alarmSwitch.rx.isOn)
            .disposed(by: disposeBag)
    ```
    
    스위치가 켜지면, 버튼의 상태를 보내주고, 밝기 조절을 해주고 클릭할수있게 만들어주었습니다.
    
    동시에 realm에 현재시간을 알람으로 적용해주고, notification으로 알람을 주었습니다.
    
    스위치가 꺼지면, 버튼의 상태를 보내주고, 클릭이 안되게 만들었습니다. 또한,
    
    realm에 저장해두었던 알람을 삭제하고, notification 또한, 같이 삭제해주었습니다.
    
    ```swift
    self.alarmSettingView.alarmSwitch.rx.isOn
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: {
                // 스위치가 켜져있다면?
                if $0 == true {
                    self.alarmSettingViewModel.buttonState.accept($0) // 버튼 상태 넣어주기
                    self.alarmSettingView.timeBackView.layer.opacity = 1.0
                        
                    let dateString = self.alarmSettingViewModel.timeLabel.value
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .none
                    dateFormatter.timeStyle = .short
                    let dateDate = dateFormatter.date(from: dateString)!
                        
                    // 현재시간을 알람으로 넣어놓기
                    let alert = Alert()
                    alert.date = dateDate
                    alert.id = "1"
                    try! self.realm.write {
                        self.realm.add(alert, update: .modified)
                    }
                    self.userNotificationCenter.addNotificationRequest(by: alert)
                } else {
                    // realm에 데이터 삭제하고
                    self.alarmSettingViewModel.buttonState.accept($0) // 버튼 상태 넣어주기
                    self.alarmSettingView.timeBackView.layer.opacity = 0.2
                    self.userNotificationCenter.removePendingNotificationRequests(withIdentifiers: ["1"] )
                    try? self.realm.write{
                        self.realm.delete(self.alert)
                    }
                }
            })
            .disposed(by: disposeBag)
    ```
    

---

### 매월 1일 뷰를 새로 띄우고 싶었습니다.

- 해결방법: 앱을 실행할떄, 날짜를 확인후, 오늘 날짜가 01일이면, 새로운 뷰를 띄워주게 만들었습니다.
    
    ```swift
    func day01() {
        let day01 = todayStrig![todayStrig!.index(todayStrig!.endIndex, offsetBy: -2)...]
        if day01 == "01" {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: StartViewController())
                nav.modalPresentationStyle = .fullScreen
    		        self.present(nav, animated: false, completion: nil)
            }
        }
    }
    ```
    
    Date값을 String으로 바꾼후, 맨 마지막 2자리가 01 일경우, 메인뷰컨트롤러 위에 새로운 뷰가 나타나게 만들었습니다.
    

---

### 현재의 달이아닌 지난달을 모두 모아서, 데이터를 보여줘야하는 문제

- 해결방법: 새로운뷰가 뜨는건 매일 01일인걸 이용하였습니다.
    
    ```swift
    func lastMonthDate() {
        // 하루 전날 값을 대입해준다. 그이유는 매월1일만 이뷰가 보일거기때문이다.
        let currentFilterDate = startViewModel.filterDateDateFormatter.string(from: Date(timeIntervalSinceNow: -86400))
        startViewModel.readRealmDateString.accept(currentFilterDate)
    }
    ```
    
    이런 방식으로, 하루전날값을 accept로 전달해준후, ViewModel은 그 정보를 받아서, 지난 달의 정보를 모아서 뷰에 바인딩 해주었습니다.
    
    ```swift
    func bindUI() {
        startViewModel.headerMonthLabel
            .asDriver(onErrorJustReturn: "")
            .drive(startView.headerMonthLabel.rx.text)
            .disposed(by: disposeBag)
            
        startViewModel.lastSumMood
            .asDriver(onErrorJustReturn: "")
            .drive(startView.headerSumLabel.rx.text)
            .disposed(by: disposeBag)
            
        startViewModel.lastSumMood
            .asDriver(onErrorJustReturn: "")
            .drive(startView.sumLabel1.rx.text)
            .disposed(by: disposeBag)
          
        startViewModel.lastSumMood
            .subscribe(onNext: {
                self.moodInt = Int($0)!
            }).disposed(by: disposeBag)
    }
    ```
    
    또한, 기분의 합에 따라 분기처리를 하여, 화면에 보여주는 뷰를 다르게 설정해주었습니다.
    

---

### ToastMessage가 원하는대로 뜨질 않은 문제

- 해결방법: ToastMessage 라이브러리를 직접 수정해 주었습니다.
    
    ```swift
    public struct ToastStyle {
        // 배경색상
        public var backgroundColor: UIColor = .toastColor
        // 토스트메세지 크기
        public var horizontalPadding: CGFloat = 55.0
        // 토스트메세지 높이
        public var verticalPadding: CGFloat = 22.0
        // 코너
        public var cornerRadius: CGFloat = 16.0;
    	  // 이미지 사이즈
        public var imageSize = CGSize(width: 20.0, height: 20.0)
    
    		if let imageView = imageView {
            // 이미지와 라벨의 간격
            imageRect.origin.x = 20
            imageRect.origin.y = style.verticalPadding
            imageRect.size.width = imageView.bounds.size.width
            imageRect.size.height = imageView.bounds.size.height
        }
    }
    
    public enum ToastPosition {
        case top
        case center
        case bottom
        
        // 포지션 사이즈
        fileprivate func centerPoint(forToast toast: UIView, inSuperview superview: UIView) -> CGPoint {
            let topPadding: CGFloat = ToastManager.shared.style.verticalPadding + superview.csSafeAreaInsets.top
            switch self {
            case .top:
                return CGPoint(x: superview.bounds.size.width / 2.0, y: (toast.frame.size.height / 2.0) + topPadding)
            case .center:
                return CGPoint(x: superview.bounds.size.width / 2.0, y: superview.bounds.size.height / 2.0)
            case .bottom:
                return CGPoint(x: superview.bounds.size.width / 2.0, y: (superview.bounds.size.height - (toast.frame.size.height / 2.0)) - 150)
            }
        }
    }
    ```
    

## 스크린샷

![SC_7](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/401b52e3-a903-42da-aa8d-9bece14ec1f5)  

![SC_8](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/b3a8c5c9-8999-4a43-981a-5bca77a9f351)  

![SC_9](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/6ff46226-bebd-44a0-8bb8-b24bb939b550)  

![SC_10](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/e41831d8-a8c9-44ab-acfe-e16de736c791)    

![SC_11](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/d7c49dc3-faf1-4853-a286-5583f4c05dfa)  

![SC_12](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/c7a9b561-c826-49c2-b27e-5bcfb010973e)  

### 매월 1일 화면

![Simulator_Screen_Shot_-_iPhone_12_-_2022-12-22_at_16 03 10](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/ab355587-5695-4165-979f-c9e161be7d37)  

![Simulator_Screen_Shot_-_iPhone_12_-_2022-12-22_at_16 03 40](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/3ccd6986-0a0a-4856-9908-0634fc4aa5da)  

![Simulator_Screen_Shot_-_iPhone_12_-_2022-12-22_at_16 03 57](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/8ddeba8b-2c95-46a4-a2b1-85d7a91b7e62)  

### 메인화면

![Simulator_Screen_Shot_-_iPhone_12_-_2022-12-22_at_16 00 04](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/4a7eaf04-8bfa-42e2-927a-97dbc92240ea)  

### 일기 모아보는 화면

![Simulator_Screen_Shot_-_iPhone_12_-_2022-12-22_at_16 00 44](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/cefdb160-59f2-420f-83cd-42c5a1cdcf2d)  

### 알람 설정 화면

![Simulator_Screen_Shot_-_iPhone_12_-_2022-12-22_at_16 00 51](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/4fc18ece-8982-4101-9548-021407ef4f25)  

![IMG_5899](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/3e544701-a3c6-4f9e-a2f7-6c934795b004)  

![Simulator_Screen_Shot_-_iPhone_12_-_2022-12-22_at_16 09 35](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/e4715220-f4e8-48e9-9e5c-43276b9abdbd)  

![Simulator_Screen_Shot_-_iPhone_12_-_2022-12-22_at_16 12 26](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/8d10d5c0-9743-4475-822e-bf8b40b23fca)  

![KakaoTalk_Photo_2022-12-23-22-49-06](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/8164c7d0-751a-4ab9-8acf-259900e6164b)  

![IMG_5900](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/7b96e01a-5945-4c05-ba1a-5fef0da87032)  

## 시연영상.

![KakaoTalk_Video_2022-12-22-23-47-01](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/f1fb5441-fc90-4806-a341-5b3a497f4fbd)  

## 배운 점&활용기술.

### 디자이너와 협엽하여 피그마 사용 방법을 배웠습니다.

- 기획 이미지
    
![Untitled 1](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/9618c9d0-4d8e-4099-bbf6-1b93b722d7ee)  
    

### MVVM패턴을 적용하였습니다.

### 데이터에따라 분기 처리하는 방법을 배웠습니다.

### 데이터 바인딩하는 방법을 배웠습니다.

### RxSwift를 처음으로 공부하며 사용하였습니다.

### [weak self]를 왜 사용하는지 직접 느끼며 깨달았습니다.

### 다양한 라이브러리 사용방법과 수정하는 방법을 배웠습니다.

### NotificationsCenter를 이용해 로컬 알림을 보내는걸 활용하였습니다.

### 앱스토어 앱을 출시해 보면서 다양한 경험을 해보았습니다.

![Untitled 2](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/ef59e56e-b399-4548-86c6-c6caa4116ffd)  

### 버전관리를 하여 버그를 수정하고 있습니다.

- Version 1.0.1 버그수정
    - 앱을 처음 실행할때, “각없는 오늘” “TodayDiary”에게 알람을 받겠습니까?라고 뜨는 버그 → 수정완료
    - (앱스토어에서)언어가 영어로  되어있음. →  수정완료
    - 안하는 라이브러리 삭제 → 삭제완료
    
![Untitled 3](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/2170804b-e246-4566-a671-c095ac1b4769)  
    
- Version 2.1 기능추가, 버그수정
    - 영화 후기 기능 추가
    - 책 후기 기능 추가
    - 버그수정( 23시에 저장후, 00시에 들어가보면 뷰가 리로드안됐던 버그수정)
    
![Untitled 4](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/cf26acf6-e038-4bcd-81d0-181b11e60e3e)  
    
- Version 2.1.1 버그수정
    - 일기화면에서 이모티콘이 생겨도 오늘표시의 원이 사리지지않던 버그 수정
    - 영화, 책 첫 후기작성시 Emtpy화면이 없어지지 않는버그 수정
    
![Untitled 5](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/fa00deb2-aa42-4e5a-98e1-3fea71f67d72)  
    
- Version 2.1.2 버그수정
    - 영화, 책 첫 후기작성시 Emtpy화면이 없어지지 않는버그 재수정
    
![Untitled 6](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/51214862-eafe-45e5-bf2d-44f9dfa6d9c7)  
    

![Untitled 7](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/883f0611-68bb-4069-8e51-6933a39a354a)  
