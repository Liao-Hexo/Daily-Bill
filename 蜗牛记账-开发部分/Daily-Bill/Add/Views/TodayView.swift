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
        view.backgroundColor = ThemeColor.blackWhiteDateColor//cellColor
        view.layer.cornerRadius = 8
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.width.equalTo(135)
            make.height.equalTo(32)
            make.left.equalToSuperview().offset(12)
            make.centerY.equalTo(self)
        }
        
        let aImageLabel = UILabel()
        aImageLabel.text = "📆"
        aImageLabel.isUserInteractionEnabled = true
        view.addSubview(aImageLabel)
        aImageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.centerY.equalTo(view)
        }
        
        let titleLabel: UILabel = UILabel.init()
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = ThemeColor.blackWhiteFontColor//.white
        titleLabel.text = nowDateString//"今天"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(aImageLabel.snp.right).offset(6)
        }
        self.titleLabel = titleLabel
        
        let downLabel = UILabel()
        downLabel.text = "∨"
        downLabel.textColor = ThemeColor.blackWhiteFontColor
        downLabel.isUserInteractionEnabled = true
        view.addSubview(downLabel)
        downLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(3)
            make.centerY.equalTo(view)
        }
        
    }
    
    func setTitleLabelText(_ text: String) -> Void {
        self.titleLabel?.text = text
    }
    
    
}
