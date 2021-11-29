//
//  Details_ListTableViewHeader.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/21.
//

import UIKit

class Details_ListTableViewHeader: UITableViewCell {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var oneLabel: UILabel?
    var twoLabel: UILabel?
    var _headerModel: TallyListHeaderModel?
    var headrModel: TallyListHeaderModel{
        set{
            _headerModel = newValue
            oneLabel?.text = _headerModel?.date
            twoLabel?.text = String(format: "净收入 %@", _headerModel?.amount ?? "0.00")
        }
        get{
            return _headerModel ?? TallyListHeaderModel.init()
        }
    }


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() -> Void {
        
        let view: UIView = UIView.init()
//        view.backgroundColor = UIColor.init(red: 237 / 255.0, green: 237 / 255.0, blue: 237 / 255.0, alpha: 1)
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(20)
        }

        self.oneLabel = UILabel.init()
        self.oneLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        self.oneLabel?.textColor = UIColor.init(red: 167 / 255.0, green: 167 / 255.0, blue: 167 / 255.0, alpha: 1.0)
        self.oneLabel?.text = "03月08日 周一"
        view.addSubview(self.oneLabel ?? UILabel.init())
        self.oneLabel?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview()
            make.height.equalTo(20)
            make.centerY.equalTo(self)
        })

        self.twoLabel = UILabel.init()
        self.twoLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        self.twoLabel?.textColor = UIColor.init(red: 167 / 255.0, green: 167 / 255.0, blue: 167 / 255.0, alpha: 1.0)
        self.twoLabel?.text = "支出：155"
//        self.twoLabel?.textAlignment = NSTextAlignment.right
        view.addSubview(self.twoLabel ?? UILabel.init())
        self.twoLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.oneLabel?.snp.right ?? 0)
            make.height.equalTo(20)
            make.centerY.equalTo(self)
        })
    }
}
