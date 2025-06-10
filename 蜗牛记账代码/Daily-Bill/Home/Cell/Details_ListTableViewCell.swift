//
//  Details_ListTableViewCell.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/21.
//

import UIKit

class Details_ListTableViewCell: UITableViewCell {

    
    var _tallyModel: TallyList?
    var tallyModel: TallyList{
        set{
            _tallyModel = newValue

            let imageName: String = (_tallyModel?.consumeType ?? "餐饮").appending("high")
            self.photoView?.image = UIImage.init(named: imageName)
            self.titleLabel?.text = _tallyModel?.consumeType
            if _tallyModel?.tallyType == 1{
                self.amountLabel?.text = "-".appending(_tallyModel?.amount ?? "0.00")
                self.imageBackView?.backgroundColor = UIColor.init(red: CGFloat(arc4random() % 256) / 255.0, green: CGFloat(arc4random() % 256) / 255.0, blue: CGFloat(arc4random() % 256) / 255.0, alpha: 1)//spendingColor
                self.titleLabel?.textColor = ThemeColor.blackWhiteFontColor//.white//spendingColor
                self.amountLabel?.textColor = spendingColor
            }else{
                self.amountLabel?.text = "+".appending(_tallyModel?.amount ?? "0.00")
                self.imageBackView?.backgroundColor = UIColor.init(red: CGFloat(arc4random() % 256) / 255.0, green: CGFloat(arc4random() % 256) / 255.0, blue: CGFloat(arc4random() % 256) / 255.0, alpha: 1)//incomeColor
                self.titleLabel?.textColor = ThemeColor.blackWhiteFontColor//.white//incomeColor
                self.amountLabel?.textColor = incomeColor

            }

        }
        get{
            return _tallyModel ?? TallyList.init()
        }
    }

    var view: UIView?
    var imageBackView: UIView?
    var photoView: UIImageView?
    var titleLabel: UILabel?
    var amountLabel: UILabel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() -> Void {
        
        self.backgroundColor = ThemeColor.blackWhiteThemeColor//themeColor
        self.selectionStyle = UITableViewCell.SelectionStyle.none  //去掉UITableview的点击效果

        let view: UIView = UIView.init()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = ThemeColor.blackWhiteDateColor//cellColor
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
        self.view = view

        let imageBackView_Width: CGFloat =  30//35
        let imageBackView: UIView = UIView.init()
//        imageBackView.backgroundColor = themeColor
        imageBackView.layer.cornerRadius = imageBackView_Width / 2.0
        imageBackView.clipsToBounds = true
        view.addSubview(imageBackView)
//        imageBackView.backgroundColor = .red
        imageBackView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.height.equalTo(imageBackView_Width)
            make.centerY.equalTo(self)
        }
        self.imageBackView = imageBackView

        let photoView: UIImageView = UIImageView.init()
        photoView.image = UIImage.init(named: "餐饮high")
        imageBackView.addSubview(photoView)
        photoView.snp.makeConstraints { (make) in
            make.left.top.equalTo(5)
            make.bottom.right.equalTo(-5)
        }
        self.photoView = photoView

        let titleLabel: UILabel = UILabel.init()
        titleLabel.textColor = UIColor.init(red: 62 / 255.0, green: 62 / 255.0, blue: 62 / 255.0, alpha: 1.0)
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.text = "餐饮"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageBackView.snp.right).offset(15)
            make.height.equalTo(30)
            make.width.equalTo(60)
            make.centerY.equalTo(self)
        }
        self.titleLabel = titleLabel


        let amountLabel: UILabel = UILabel.init()
        amountLabel.text = "0.00"
        amountLabel.textColor = UIColor.init(red: 129 / 255.0, green: 129 / 255.0, blue: 129 / 255.0, alpha: 1.0)
        amountLabel.textAlignment = NSTextAlignment.right
//        amountLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 15)
        amountLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        view.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.height.equalTo(30)
            make.centerY.equalTo(self)
        }

        self.amountLabel = amountLabel
        
        let lineView: UIView = UIView()
        lineView.backgroundColor = ThemeColor.blackWhiteThemeColor
        view.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.17)
        }

    }

}

