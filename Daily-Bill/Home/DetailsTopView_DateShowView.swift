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

            _title = _title.appending("")
            let att: NSMutableAttributedString = NSMutableAttributedString.init(string: _title )
            att.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .bold)], range: NSRange.init(location: (_title.count) - 1, length: 1))
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
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.titleLabel?.textColor = .white
        self.titleLabel?.isUserInteractionEnabled = true
        self.addSubview(self.titleLabel ?? UIView.init())
        self.titleLabel?.snp.makeConstraints({ (make) in
            make.height.equalTo(30)
            make.centerY.equalTo(self)
            make.left.equalToSuperview()
        })
    }

}

