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

        self.backgroundColor = themeColor

        /*
        for name in UIFont.familyNames {
            print("familyNames: \(name)")
            for fontName in UIFont.fontNames(forFamilyName: name){
                print(fontName)
            }
        }
        */

        let oneView: UIView = UIView.init()
        oneView.backgroundColor = themeColor
        oneView.layer.cornerRadius = 8
        self.addSubview(oneView)
        oneView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(kStatusBarHeight - 10)
            make.width.equalTo(110)
            make.height.equalTo(50)
        }

        let twoView: UIView = UIView.init()
        twoView.backgroundColor = cellColor
        twoView.layer.cornerRadius = 8
        self.addSubview(twoView)
        twoView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalTo(0)
            make.width.equalTo(171)
            make.height.equalTo(55)
        }
        
        let threeView: UIView = UIView.init()
        threeView.backgroundColor = cellColor
        threeView.layer.cornerRadius = 8
        self.addSubview(threeView)
        threeView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalTo(0)
            make.width.equalTo(171)
            make.height.equalTo(55)
        }

        let yearLabel: UILabel = UILabel.init()
        yearLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        yearLabel.textColor = .white
        yearLabel.text = "2019"
        oneView.addSubview(yearLabel)
        yearLabel.snp.makeConstraints { (make) in
            make.left.equalTo(-5)
            make.centerY.equalToSuperview()
        }
        self.yearLabel = yearLabel

        let spendingTitleLabel: UILabel = UILabel.init()
        spendingTitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        spendingTitleLabel.textColor = .white
        spendingTitleLabel.text = "本月支出"
        twoView.addSubview(spendingTitleLabel)
        spendingTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-5)
        }

        let incomeTitleLabel: UILabel = UILabel.init()
        incomeTitleLabel.textColor = .white
        incomeTitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        incomeTitleLabel.text = "本月收入"
        threeView.addSubview(incomeTitleLabel)
        incomeTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-5)
        }

        let spendingAmountLabel: UILabel = UILabel.init()
        spendingAmountLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        spendingAmountLabel.text = "0.00"
        spendingAmountLabel.textColor = spendingColor
        twoView.addSubview(spendingAmountLabel)
        spendingAmountLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(5)
        }
        self.spendingAmountLabel = spendingAmountLabel

        let incomeAmountLabel: UILabel = UILabel.init()
        incomeAmountLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        incomeAmountLabel.text = "0.00"
        incomeAmountLabel.textColor = incomeColor
        threeView.addSubview(incomeAmountLabel)
        incomeAmountLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(5)
        }
        self.incomeAmountLabel = incomeAmountLabel

        let dateLabel = DetailsTopView_DateShowView.init()
        oneView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(yearLabel.snp.right)
            make.centerY.equalToSuperview()
        }
        self.dateLabel = dateLabel

        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGesAction(tap:)))
        oneView.addGestureRecognizer(tap)

    }

     // MARK: - LoadData

    func loadData(date: String, spending: String?, income: String?) -> Void {

        _date = date

        if date.count == 6 {
            let index = date.index(date.startIndex, offsetBy: 4)
            let year: String = String("☞ " + date[date.startIndex ..< index] + ".")
            let month: String = String(date[index ..< date.endIndex] + " ☜")
            self.yearLabel?.text = year
            self.dateLabel?.title = month
        }

        if spending != nil{
            let att: NSMutableAttributedString = NSMutableAttributedString.init(string: spending ?? "0.00")
            att.addAttributes([NSAttributedString.Key.font : UIFont.init(name: "PingFangSC-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)], range: NSRange.init(location: (spending?.count ?? 2) - 2, length: 2))
            self.spendingAmountLabel?.attributedText = att
        }

        if income != nil{
            let att: NSMutableAttributedString = NSMutableAttributedString.init(string: income ?? "0.00")
            att.addAttributes([NSAttributedString.Key.font : UIFont.init(name: "PingFangSC-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)], range: NSRange.init(location: (income?.count ?? 2) - 2, length: 2))
            self.incomeAmountLabel?.attributedText = att
        }

    }

     // MARK: - Methods

    @objc func tapGesAction(tap: UITapGestureRecognizer) -> Void {
        self.delegate?.selectDateClicked()
    }

}

