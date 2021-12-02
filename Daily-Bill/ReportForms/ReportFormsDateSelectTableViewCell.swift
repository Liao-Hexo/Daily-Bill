//
//  ReportFormsDateSelectTableViewCell.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

class ReportFormsDateSelectTableViewCell: UITableViewCell {

    
    var label: UILabel?
    var bottomLine: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.selectedBackgroundView = UIView.init()
        self.backgroundColor = UIColor.clear
//        self.bottomLine?.backgroundColor = UIColor.white

        
        if selected{
            self.label?.textColor = UIColor.init(red: 253 / 255.0, green: 198 / 255.0, blue: 199 / 255.0, alpha: 1.0)
            self.bottomLine?.isHidden = false
        }else{
            self.label?.textColor = .white
            self.bottomLine?.isHidden = true
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
//        self.selectedBackgroundView = nil
        
        let transformView: UIView = UIView.init()
        transformView.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi * -0.5))
        self.contentView.addSubview(transformView)
        transformView.snp.makeConstraints { (make) in
            make.width.equalTo(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        self.label = UILabel.init()
        self.label?.text = "1月"
        self.label?.textColor = UIColor.init(red: 253, green: 198, blue: 199, alpha: 1.0)
        self.label?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.label?.textAlignment = NSTextAlignment.center
//        self.label?.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi * -0.5))
        transformView.addSubview(self.label ?? UIView.init())
        self.label?.snp.makeConstraints({ (make) in
            make.left.equalTo(0)
            make.centerY.equalTo(transformView)
        })
        
        self.bottomLine = UIView.init()
        self.bottomLine?.backgroundColor = UIColor.init(red: 253 / 255.0, green: 198 / 255.0, blue: 199 / 255.0, alpha: 1.0)
        self.bottomLine?.layer.cornerRadius = 1
        transformView.addSubview(self.bottomLine ?? UIView.init())
        self.bottomLine?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.label?.snp.bottom ?? 0)
            make.centerX.equalTo(self.label ?? UIView.init())
            make.width.equalTo(25)
            make.height.equalTo(2)
        })
        
        
        
        
    }
    
}
