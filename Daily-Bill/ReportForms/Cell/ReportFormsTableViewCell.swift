//
//  ReportFormsTableViewCell.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

class ReportFormsTableViewCell: UITableViewCell {

    //MARK: - Property
    
    var imageBackView: UIView?
    var photoView: UIImageView?
    var titleLabel: UILabel?
    var countLabel: UILabel?
    var progress: UIProgressView?
    var amountLabel: UILabel?

    var _reportFormsModel: ReportFormsModel?
    var reportFormsModel: ReportFormsModel{
        set{
            _reportFormsModel = newValue
            
            if newValue.type == 1{
                self.imageBackView?.backgroundColor = UIColor.init(red: CGFloat(arc4random() % 256) / 255.0, green: CGFloat(arc4random() % 256) / 255.0, blue: CGFloat(arc4random() % 256) / 255.0, alpha: 1)//spendingColor
                self.progress?.progressTintColor = UIColor.init(red: 255/255.0, green: 165/255.0, blue: 0/255.0, alpha: 1.0)//self.imageBackView?.backgroundColor
                self.amountLabel?.textColor = spendingColor
                self.titleLabel?.textColor = ThemeColor.blackWhiteFontColor//.white//spendingColor
                self.amountLabel?.text = "-".appending(newValue.amount)
                
            }else{
                self.imageBackView?.backgroundColor = UIColor.init(red: CGFloat(arc4random() % 256) / 255.0, green: CGFloat(arc4random() % 256) / 255.0, blue: CGFloat(arc4random() % 256) / 255.0, alpha: 1)//incomeColor
                self.progress?.progressTintColor = UIColor.init(red: 102/255.0, green: 205/255.0, blue: 170/255.0, alpha: 1.0)//self.imageBackView?.backgroundColor
                self.amountLabel?.textColor = incomeColor
                self.titleLabel?.textColor = ThemeColor.blackWhiteFontColor//.white//incomeColor
                self.amountLabel?.text = "+".appending(newValue.amount)
            }
            
            let imageName: String = newValue.title.appending("high")
            self.photoView?.image = UIImage.init(named: imageName)
            self.titleLabel?.text = String(format: "%@「%d%%」", newValue.title, lroundf(Float(Double.init(newValue.scale * 100))))
            self.countLabel?.text = String(format: "总共%d笔", newValue.count)
            self.progress?.progress = Float(CGFloat(newValue.scale))
            
        }
        get{
            return _reportFormsModel ?? ReportFormsModel.init()
        }
    }
    
    //MARK: - Instance
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = ThemeColor.blackWhiteThemeColor//themeColor
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let view: UIView = UIView.init()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = ThemeColor.blackWhiteDateColor//cellColor
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
        
        let imageBackView_Width: CGFloat =  30
        let imageBackView: UIView = UIView.init()
        imageBackView.backgroundColor = spendingColor
        imageBackView.layer.cornerRadius = imageBackView_Width / 2.0
        imageBackView.clipsToBounds = true
        view.addSubview(imageBackView)
        imageBackView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.height.equalTo(imageBackView_Width)
            make.centerY.equalTo(self)
        }
        
        let photoView: UIImageView = UIImageView.init()
        photoView.image = UIImage.init(named: "餐饮high")
        imageBackView.addSubview(photoView)
        photoView.snp.makeConstraints { (make) in
            make.left.top.equalTo(5)
            make.bottom.right.equalTo(-5)
        }
        
        let titleLabel: UILabel = UILabel.init()
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.text = "住房0.00%"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageBackView.snp.right).offset(10)
            make.centerY.equalTo(self.contentView).offset(-8)
            make.height.equalTo(20)
        }
        
        let nextLabel = UILabel()
        nextLabel.text = ">"
        nextLabel.textColor = ThemeColor.blackWhiteFontColor
        view.addSubview(nextLabel)
        nextLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.width.height.equalTo(15)
            make.centerY.equalTo(self.contentView)
        }
        
        let amountLabel: UILabel = UILabel.init()
        amountLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        amountLabel.textAlignment = NSTextAlignment.right
        amountLabel.text = "￥0.00"
        view.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(nextLabel.snp.left).offset(-10)
            make.height.equalTo(titleLabel.snp.height)
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.centerY.equalTo(titleLabel)
        }
        
        let countLabel: UILabel = UILabel.init()
        countLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        countLabel.text = "0笔"
        countLabel.textColor = .systemGray
//        countLabel.backgroundColor = .red
        countLabel.textAlignment = NSTextAlignment.right
        view.addSubview(countLabel)
        countLabel.snp.makeConstraints { (make) in
            make.right.equalTo(amountLabel.snp.right)
            make.height.equalTo(20)
            make.top.equalTo(amountLabel.snp.bottom).offset(3)
            make.width.equalTo(50)
        }
        
        
        let progress: UIProgressView = UIProgressView.init(progressViewStyle: UIProgressView.Style.default)
        progress.trackTintColor = UIColor.init(red: 239 / 255.0, green: 239 / 255.0, blue: 239 / 255.0, alpha: 1.0)
        progress.progress = 0.1
        progress.layer.cornerRadius = 3
        progress.clipsToBounds = true
        progress.progressTintColor = incomeColor
        view.addSubview(progress)
        progress.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.right.equalTo(countLabel.snp.left).offset(-20)
            make.height.equalTo(8)
        }
        
        let lineView: UIView = UIView()
        lineView.backgroundColor = .gray
        view.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self.imageBackView = imageBackView
        self.photoView = photoView
        self.titleLabel = titleLabel
        self.amountLabel = amountLabel
        self.countLabel = countLabel
        self.progress = progress

            
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
}
