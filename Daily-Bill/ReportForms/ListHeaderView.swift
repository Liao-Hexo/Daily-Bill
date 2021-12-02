//
//  ListHeaderView.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

class ListHeaderView: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var contentLabel: UILabel?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() -> Void {
        
        self.backgroundColor = themeColor
        
        let view: UIView = UIView.init()
        view.backgroundColor = UIColor.init(red: 131 / 255.0, green: 111 / 255.0, blue: 255 / 255.0, alpha: 1)
        view.layer.cornerRadius = 5
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(0)
//            make.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(20)
        }
        
        let label: UILabel = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.text = "03月08日 周一"
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
//            make.left.equalTo(15)
//            make.centerY.equalTo(self)
//            make.height.equalTo(20)
//            make.right.equalTo(-15)
            make.height.equalTo(20)
            make.centerX.centerY.equalToSuperview()
        }
        self.contentLabel = label
    }
}
