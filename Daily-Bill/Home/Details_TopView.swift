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

        let titleLabel: UILabel = UILabel.init()
        titleLabel.font = UIFont.init(name: "HYi2gj", size: 24)
        titleLabel.textAlignment = NSTextAlignment.center
//        titleLabel.textColor = UIColor.white
        titleLabel.text = "月账单"
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(kStatusBarHeight)
            make.width.equalTo(200)
            make.centerX.equalTo(self)
            make.height.equalTo(40)
        }


        /*
        for name in UIFont.familyNames {
            print("familyNames: \(name)")
            for fontName in UIFont.fontNames(forFamilyName: name){
                print(fontName)
            }
        }
        */

        let oneView: UIView = UIView.init()
//        oneView.backgroundColor = UIColor.red
        self.addSubview(oneView)
        oneView.snp.makeConstraints { (make) in
            make.left.equalTo(margin)
            make.top.equalTo(titleLabel.snp.bottom).offset(margin)
            make.width.equalTo(self.snp.width).multipliedBy(2 / 9.0)
            make.bottom.equalTo(0)
        }

        let twoView: UIView = UIView.init()
        self.addSubview(twoView)
        twoView.snp.makeConstraints { (make) in
            make.left.equalTo(oneView.snp.right).offset(margin * 2)
            make.right.bottom.equalTo(0)
            make.top.equalTo(oneView.snp.top)
        }

        let titleColor: UIColor = UIColor.init(red: 71 / 255.0, green: 71/255.0, blue: 71/255.0, alpha: 1.0)

        let yearLabel: UILabel = UILabel.init()
        yearLabel.font = UIFont.systemFont(ofSize: 12)
        yearLabel.textColor = titleColor
        yearLabel.text = "2019"
        oneView.addSubview(yearLabel)
        yearLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(15)
        }
        self.yearLabel = yearLabel

        let spendingTitleLabel: UILabel = UILabel.init()
        spendingTitleLabel.font = UIFont.systemFont(ofSize: 12)
        spendingTitleLabel.textColor = titleColor
        spendingTitleLabel.text = "支出"
        twoView.addSubview(spendingTitleLabel)
        spendingTitleLabel.snp.makeConstraints { (make) in
            make.top.right.equalTo(0)
            make.height.equalTo(15)
            make.width.equalTo(twoView.snp.width).multipliedBy(0.5)
        }

        let incomeTitleLabel: UILabel = UILabel.init()
        incomeTitleLabel.textColor = titleColor
        incomeTitleLabel.font = UIFont.systemFont(ofSize: 12)
        incomeTitleLabel.text = "收入"
        twoView.addSubview(incomeTitleLabel)
        incomeTitleLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(0)
            make.height.equalTo(15)
            make.right.equalTo(spendingTitleLabel.snp.left)
        }

        let spendingAmountLabel: UILabel = UILabel.init()
        spendingAmountLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 21)
        spendingAmountLabel.text = "0.00"
        spendingAmountLabel.textColor = UIColor.init(red: 31 / 255.0, green: 31 / 255.0, blue: 31 / 255.0, alpha: 1.0)
//        spendingAmountLabel.textColor = UIColor.white;
        twoView.addSubview(spendingAmountLabel)
        spendingAmountLabel.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(0)
            make.top.equalTo(spendingTitleLabel.snp.bottom)
            make.width.equalTo(spendingTitleLabel.snp.width)
        }
        self.spendingAmountLabel = spendingAmountLabel

        let incomeAmountLabel: UILabel = UILabel.init()
        incomeAmountLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 21)
        incomeAmountLabel.text = "0.00"
        incomeAmountLabel.textColor = UIColor.init(red: 31 / 255.0, green: 31 / 255.0, blue: 31 / 255.0, alpha: 1.0)
//        incomeAmountLabel.textColor = UIColor.white
        twoView.addSubview(incomeAmountLabel)
        incomeAmountLabel.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(0)
            make.top.equalTo(incomeTitleLabel.snp.bottom)
            make.width.equalTo(incomeTitleLabel.snp.width)
        }
        self.incomeAmountLabel = incomeAmountLabel

        let dateLabel = DetailsTopView_DateShowView.init()
//        dateLabel.tintColor = .green
        oneView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(yearLabel.snp.bottom)
        }
        self.dateLabel = dateLabel

        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGesAction(tap:)))
        dateLabel.addGestureRecognizer(tap)

    }



     // MARK: - LoadData

    func loadData(date: String, spending: String?, income: String?) -> Void {

        _date = date

        if date.count == 6 {
            let index = date.index(date.startIndex, offsetBy: 4)
            let year: String = String(date[date.startIndex ..< index])
            let month: String = String(date[index ..< date.endIndex])
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

