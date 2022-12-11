//
//  CreateDiaryView.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/11.
//

import UIKit
import Then
import SnapKit
import DLRadioButton
import UITextView_Placeholder

class CreateDiaryView: UIView {
    
    private let dLRadioButton = DLRadioButton()
    private let mood = Mood()
    lazy var buttonArray = [mood0Button, mood1Button, mood2Button, mood3Button, mood4Button, mood5Button, mood6Button, mood7Button]
    var tagNumber = 0
    
    private let questionLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.text = "오늘은 어떤 하루를 보내셨나요?"
    }
    
    private let buttonScrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
    }
    
    lazy var mood0Button = dLRadioButton.moodButton(icon: "icon0", iconSelected: "iconSelected0")
    lazy var mood1Button = dLRadioButton.moodButton(icon: "icon1", iconSelected: "iconSelected1")
    lazy var mood2Button = dLRadioButton.moodButton(icon: "icon2", iconSelected: "iconSelected2")
    lazy var mood3Button = dLRadioButton.moodButton(icon: "icon3", iconSelected: "iconSelected3")
    lazy var mood4Button = dLRadioButton.moodButton(icon: "icon4", iconSelected: "iconSelected4")
    lazy var mood5Button = dLRadioButton.moodButton(icon: "icon5", iconSelected: "iconSelected5")
    lazy var mood6Button = dLRadioButton.moodButton(icon: "icon6", iconSelected: "iconSelected6")
    lazy var mood7Button = dLRadioButton.moodButton(icon: "icon7", iconSelected: "iconSelected7")
    
    private lazy var labelBackgorund = UIView().then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .labelBackgroundColor
    }
    
    var selectedButtonLable = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.text = "좋은 일만 있었어요"
    }
    
    var textView = UITextView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.tintColor = .black
        $0.textColor = .black
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.black.cgColor
        $0.placeholder = "상세한 내용을 적어보세요"
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    
    lazy var saveButton = UIButton().then {
        $0.setTitle("등록", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configurUI()
        buttonSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurUI() {
        addSubview(questionLabel)
        addSubview(buttonScrollView)
        
        let moodButtonAarry = UIStackView(arrangedSubviews: [mood0Button, mood1Button, mood2Button, mood3Button, mood4Button, mood5Button, mood6Button, mood7Button])
        moodButtonAarry.axis = .horizontal
        moodButtonAarry.spacing = 10
        
        buttonScrollView.addSubview(moodButtonAarry)
        addSubview(labelBackgorund)
        labelBackgorund.addSubview(selectedButtonLable)
        addSubview(textView)
        addSubview(saveButton)
        
        
        questionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(34)
        }
        
        buttonScrollView.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(30)
            $0.height.equalTo(100)
            $0.width.equalToSuperview()
        }
        
        moodButtonAarry.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
        }
        
        labelBackgorund.snp.makeConstraints {
            $0.top.equalTo(buttonScrollView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(selectedButtonLable.snp.width).offset(20)
            $0.height.equalTo(selectedButtonLable.snp.height).offset(14)
        }
        
        selectedButtonLable.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(labelBackgorund.snp.bottom).offset(25)
            $0.width.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
            $0.centerX.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(40)
            $0.bottom.equalToSuperview().inset(100)
            $0.width.equalTo(textView.snp.width)
            $0.height.equalTo(52)
            $0.centerX.equalToSuperview()
        }
    }
    
    func buttonSetting() {
        let otherButtonArray = [mood1Button, mood2Button, mood3Button, mood4Button, mood5Button, mood6Button, mood7Button]
        
        // 하나 누르면 다른 버튼 false되게 만들기
        for button in otherButtonArray {
            mood0Button.otherButtons.append(button)
        }
        
        // button 마다 tag와 action 달아주기
        for (index, button) in self.buttonArray.enumerated() {
            button.addTarget(self, action: #selector(moodButtonTapped(_:)), for: .touchUpInside)
            button.tag = index
        }
    }
    
    @objc func moodButtonTapped(_ sender: UIButton) {
        print(#function)
        print(sender.tag)
        self.tagNumber = sender.tag
        self.selectedButtonLable.text = self.mood.moodLabel[self.tagNumber]
    }
}
