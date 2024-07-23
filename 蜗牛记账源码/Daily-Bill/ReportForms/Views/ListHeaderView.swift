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
        
        let label: UILabel = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = ThemeColor.blackWhiteFontColor//.white
        label.text = "03月08日 周一"
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(17)
            make.bottom.equalToSuperview()
        }
        self.contentLabel = label
    }
}
