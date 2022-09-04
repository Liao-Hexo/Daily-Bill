//
//  Details_TopView.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/19.
//

import UIKit

protocol Details_TopViewDelegate: NSObjectProtocol {
    func selectDateClicked()
}

class Details_TopView: UIView {

    let margin = 15
    var titleLabel: UILabel?
    var lightDarkButton: UIButton?
    var yearLabel: UILabel?
    var dateLabel: DetailsTopView_DateShowView?
    var spendingAmountLabel: UILabel?
    var incomeAmountLabel: UILabel?
    weak var delegate: Details_TopViewDelegate?

    var _date: String = ""
    var date: String{
        set{
            _date = newValue
            if _date.count == 6 {

                let index = _date.index(_date.startIndex, offsetBy: 4)
                let year: String = String(_date[_date.startIndex ..< index])
                let month: String = String(_date[index ..< _date.endIndex])
                self.yearLabel?.text = year
                self.dateLabel?.title = month

            }

        }
        get{
            return _date
        }
    }

     // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

     // MARK: - SetupUI

    func setupUI() -> Void {

        self.backgroundColor = ThemeColor.blackWhiteThemeColor//themeColor

        /*
        for name in UIFont.familyNames {
            print("familyNames: \(name)")
            for fontName in UIFont.fontNames(forFamilyName: name){
                print(fontName)
            }
        }
        */
        
        let titleLabel: UILabel = UILabel.init()
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.textColor = ThemeColor.blackWhiteFontColor//.white
        titleLabel.text = "日常 · 账单"
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(kStatusBarHeight + 10)
        }
        self.titleLabel = titleLabel
        
        let oneView: UIView = UIView.init()
        oneView.backgroundColor = ThemeColor.blackWhiteDateColor//cellColor//UIColor(patternImage: UIImage(named: "1")!)
//        oneView.layer.contents = UIImage(named: "背景")?.cgImage
        oneView.layer.cornerRadius = 8
        self.addSubview(oneView)
        oneView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
        
        let threeView: UIView = UIView.init()
        threeView.layer.contents = UIImage(named: "蜗牛1")?.cgImage
        threeView.layer.cornerRadius = 8
        self.addSubview(threeView)
        threeView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(oneView.snp.top).offset(15)
            make.width.equalTo(45)
            make.height.equalTo(50)
        }
        
        let lightDarkButton: UIButton = UIButton.init()
        lightDarkButton.setTitle("日间/夜间", for: .normal)
        lightDarkButton.layer.cornerRadius = 8
        lightDarkButton.setTitleColor(ThemeColor.blackWhiteFontColor, for: .normal)
        lightDarkButton.backgroundColor = ThemeColor.blackWhiteThemeColor
        lightDarkButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        oneView.addSubview(lightDarkButton)
        lightDarkButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-18)
            make.width.equalTo(75)
            make.height.equalTo(35)
        }
        self.lightDarkButton = lightDarkButton
        
        let seleteButton: UIButton = UIButton()
        seleteButton.backgroundColor = ThemeColor.blackWhiteThemeColor//themeColor
        seleteButton.setTitleColor(ThemeColor.blackWhiteFontColor, for: .normal)
        seleteButton.setTitle("切换日期", for: .normal)
        seleteButton.layer.cornerRadius = 8
        seleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        oneView.addSubview(seleteButton)
        seleteButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-18)
            make.width.equalTo(75)
            make.height.equalTo(35)
        }
        
//        let fiveView: UIView = UIView.init()
//        fiveView.layer.contents = UIImage(named: "蜗牛3")?.cgImage
//        fiveView.layer.cornerRadius = 8
//        oneView.addSubview(fiveView)
//        fiveView.snp.makeConstraints { (make) in
//            make.right.equalToSuperview().offset(-17)
//            make.bottom.equalTo(seleteButton.snp.top).offset(14)
//            make.width.equalTo(45)
//            make.height.equalTo(50)
//        }
//
//        let fourView: UIView = UIView.init()
//        fourView.layer.contents = UIImage(named: "蜗牛2")?.cgImage
//        fourView.layer.cornerRadius = 8
//        oneView.addSubview(fourView)
//        fourView.snp.makeConstraints { (make) in
//            make.right.equalTo(fiveView.snp.left).offset(10)
//            make.bottom.equalTo(seleteButton.snp.top).offset(14)
//            make.width.equalTo(45)
//            make.height.equalTo(50)
//        }
        
        let twoView: UIView = UIView.init()
        twoView.backgroundColor = .clear//cellColor//UIColor(patternImage: UIImage(named: "背景1")!)
        twoView.layer.cornerRadius = 8
        oneView.addSubview(twoView)
        twoView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(130)
            make.height.equalTo(50)
        }

        let yearLabel: UILabel = UILabel.init()
        yearLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        yearLabel.textColor = ThemeColor.blackWhiteFontColor//.white
        yearLabel.text = "xxxx年"
        twoView.addSubview(yearLabel)
        yearLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        self.yearLabel = yearLabel
        
        let spendingTitleLabel: UILabel = UILabel.init()
        spendingTitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        spendingTitleLabel.textColor = ThemeColor.blackWhiteFontColor//.white
        spendingTitleLabel.text = "💰本月支出："
        oneView.addSubview(spendingTitleLabel)
        spendingTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalTo(-35)
            
        }

        let spendingAmountLabel: UILabel = UILabel.init()
        spendingAmountLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        spendingAmountLabel.text = "¥ 0.00"
        spendingAmountLabel.textColor = spendingColor
        oneView.addSubview(spendingAmountLabel)
        spendingAmountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(spendingTitleLabel.snp.right).offset(2)
            make.bottom.equalTo(-33)
        }
        self.spendingAmountLabel = spendingAmountLabel
        
        let incomeTitleLabel: UILabel = UILabel.init()
        incomeTitleLabel.textColor = ThemeColor.blackWhiteFontColor//.white
        incomeTitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        incomeTitleLabel.text = "👏本月收入："
        oneView.addSubview(incomeTitleLabel)
        incomeTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalTo(-10)
        }
        
        let incomeAmountLabel: UILabel = UILabel.init()
        incomeAmountLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        incomeAmountLabel.text = "¥ 0.00"
        incomeAmountLabel.textColor = incomeColor
        oneView.addSubview(incomeAmountLabel)
        incomeAmountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(incomeTitleLabel.snp.right).offset(2)
            make.bottom.equalTo(-8)
        }
        self.incomeAmountLabel = incomeAmountLabel


        let dateLabel = DetailsTopView_DateShowView.init()
        twoView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(yearLabel.snp.right)
            make.centerY.equalToSuperview()
        }
        self.dateLabel = dateLabel

        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGesAction(tap:)))
        seleteButton.addGestureRecognizer(tap)
        
        let lightDarkButtonTap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(lightDarkButtonTapGesAction(tap:)))
        lightDarkButton.addGestureRecognizer(lightDarkButtonTap)

    }

     // MARK: - LoadData

    func loadData(date: String, spending: String?, income: String?) -> Void {

        _date = date

        if date.count == 6 {
            let index = date.index(date.startIndex, offsetBy: 4)
            let year: String = String(date[date.startIndex ..< index] + "年")
            let month: String = String(date[index ..< date.endIndex] + "月: ")
            self.yearLabel?.text = year
            self.dateLabel?.title = month
        }

        if spending != nil{
            let att: NSMutableAttributedString = NSMutableAttributedString.init(string: "¥ ".appending(spending ?? "0.00"))
//            att.addAttributes([NSAttributedString.Key.font : UIFont.init(name: "PingFangSC-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)], range: NSRange.init(location: (spending?.count ?? 2) - 2, length: 2))
            self.spendingAmountLabel?.attributedText = att
        }

        if income != nil{
            let att: NSMutableAttributedString = NSMutableAttributedString.init(string: "¥ ".appending(income ?? "0.00"))
//            att.addAttributes([NSAttributedString.Key.font : UIFont.init(name: "PingFangSC-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)], range: NSRange.init(location: (income?.count ?? 2) - 2, length: 2))
            self.incomeAmountLabel?.attributedText = att
        }
        
    }

     // MARK: - Methods

    @objc func tapGesAction(tap: UITapGestureRecognizer) -> Void {
        self.delegate?.selectDateClicked()
    }
    
    @objc func lightDarkButtonTapGesAction(tap: UITapGestureRecognizer) -> Void {
        //UIScreen.main.traitCollection.userInterfaceStyle == .dark
        if window?.overrideUserInterfaceStyle == .dark {
            self.lightDarkButton?.setTitleColor(ThemeColor.blackWhiteFontColor, for: .normal)
            self.lightDarkButton?.backgroundColor = ThemeColor.blackWhiteThemeColor
            self.lightDarkButton?.setTitle("夜间模式", for: .normal)
            window?.overrideUserInterfaceStyle = .light
        } else {
            self.lightDarkButton?.setTitleColor(ThemeColor.blackWhiteFontColor, for: .normal)
            self.lightDarkButton?.backgroundColor = ThemeColor.blackWhiteThemeColor
            self.lightDarkButton?.setTitle("日间模式", for: .normal)
            window?.overrideUserInterfaceStyle = .dark
        }
        
    }

}

