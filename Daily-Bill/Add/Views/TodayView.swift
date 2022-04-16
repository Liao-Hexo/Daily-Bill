//
//  TodayView.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

class TodayView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
     // MARK: - Property

    var titleLabel: UILabel?

    
     // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(frame: CGRect) -> Void {
//        let date: Date = Date()
        let format: DateFormatter = DateFormatter.init()
        format.dateFormat = "yyyy/MM/dd"
//        let dateString: String = format.string(from: date)
        let nowDate: Date = Date.init()
        let nowDateString = format.string(from: nowDate)
        
        let view: UIView = UIView.init()
        view.backgroundColor = cellColor
        view.layer.cornerRadius = 8
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.width.equalTo(135)
            make.height.equalTo(32)
            make.left.equalToSuperview().offset(12)
            make.centerY.equalTo(self)
        }
        
        let aImageView: UIImageView = UIImageView.init(image: UIImage.init(named: "日历"))
        aImageView.isUserInteractionEnabled = true
        view.addSubview(aImageView)
        aImageView.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.centerY.equalTo(view)
        }
        
        let titleLabel: UILabel = UILabel.init()
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = .white
        titleLabel.text = nowDateString//"今天"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(aImageView.snp.right).offset(6)
        }
        self.titleLabel = titleLabel
        
        let downView: UIImageView = UIImageView.init(image: UIImage.init(named: "下箭头"))
        downView.isUserInteractionEnabled = true
        view.addSubview(downView)
        downView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(3)
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.centerY.equalTo(view)
        }
        
    }
    
    func setTitleLabelText(_ text: String) -> Void {
        self.titleLabel?.text = text
    }
    
    
}
