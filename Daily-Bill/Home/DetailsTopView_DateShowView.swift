//
//  DetailsTopView_DateShowView.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/20.
//

import UIKit

class DetailsTopView_DateShowView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var titleLabel: UILabel?
    private var _title: String = ""
    var title: String{
        set{
            _title = newValue

            _title = _title.appending("月")
            let att: NSMutableAttributedString = NSMutableAttributedString.init(string: _title )
            att.addAttributes([NSAttributedString.Key.font : UIFont.init(name: "PingFangSC-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)], range: NSRange.init(location: (_title.count) - 1, length: 1))
            self.titleLabel?.attributedText = att

        }
        get{
            return _title
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

     // MARK: - SetupUI

    func setupUI() -> Void {

        self.titleLabel = UILabel.init()
        self.titleLabel?.text = "03月"
        self.titleLabel?.font = UIFont.init(name: "PingFangSC-Regular", size: 21)
        self.titleLabel?.textColor = UIColor.init(red: 31 / 255.0, green: 31 / 255.0, blue: 31 / 255.0, alpha: 1.0)
//        self.titleLabel?.textColor = UIColor.white
        self.titleLabel?.isUserInteractionEnabled = true
        self.addSubview(self.titleLabel ?? UIView.init())
        self.titleLabel?.snp.makeConstraints({ (make) in
            make.height.equalTo(30)
            make.centerY.equalTo(self)
            make.left.equalTo(0)
        })

        let imageView: UIImageView = UIImageView.init()
        imageView.image = UIImage.init(named: "下箭头-1")
        imageView.isUserInteractionEnabled = true
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel?.snp.right ?? 0)
            make.width.height.equalTo(10)
            make.centerY.equalTo(self)
        }

        let line: UIView = UIView.init()
        line.backgroundColor = UIColor.black
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.height.equalTo(20)
            make.width.equalTo(0.5)
            make.centerY.equalTo(self)
        }
    }

}

