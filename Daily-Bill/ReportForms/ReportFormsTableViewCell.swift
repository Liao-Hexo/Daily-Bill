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
                self.imageBackView?.backgroundColor = themeColor
                self.progress?.progressTintColor = UIColor.init(red: 243/255.0, green: 181/255.0, blue: 120/255.0, alpha: 1.0)
                self.amountLabel?.textColor = themeColor
                
            }else{
                self.imageBackView?.backgroundColor = incomeColor
                self.progress?.progressTintColor = UIColor.init(red: 161/255.0, green: 208/255.0, blue: 122/255.0, alpha: 1.0)
                self.amountLabel?.textColor = incomeColor
            }
            
            let imageName: String = newValue.title.appending("high")
            self.photoView?.image = UIImage.init(named: imageName)
            self.titleLabel?.text = String(format: "%@ %d%%", newValue.title, lroundf(Float(Double.init(newValue.scale * 100))))
            self.amountLabel?.text = "￥".appending(newValue.amount)
            self.countLabel?.text = String(format: "%d笔", newValue.count)
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
        
        let imageBackView_Width: CGFloat =  35
        let imageBackView: UIView = UIView.init()
        imageBackView.backgroundColor = themeColor
        imageBackView.layer.cornerRadius = imageBackView_Width / 2.0
        imageBackView.clipsToBounds = true
        self.contentView.addSubview(imageBackView)
        imageBackView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
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
        titleLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 15)
        titleLabel.text = "住房0.00%"
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageBackView.snp.right).offset(10)
            make.centerY.equalTo(self.contentView).offset(-10)
            make.height.equalTo(20)
        }
        
        
        let nextImageView: UIImageView = UIImageView.init(image: UIImage.init(named: "ic_next"))
        nextImageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.contentView.addSubview(nextImageView)
        nextImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.width.height.equalTo(15)
            make.centerY.equalTo(self.contentView)
        }
        
        let amountLabel: UILabel = UILabel.init()
        amountLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 15)
        amountLabel.textAlignment = NSTextAlignment.right
        amountLabel.text = "￥0.00"
        self.contentView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(nextImageView.snp.left).offset(-10)
            make.height.equalTo(titleLabel.snp.height)
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.centerY.equalTo(titleLabel)
        }
        
        let countLabel: UILabel = UILabel.init()
        countLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 13)
        countLabel.text = "0笔"
        countLabel.textColor = UIColor.init(red: 168 / 255.0, green: 168 / 255.0, blue: 168 / 255.0, alpha: 1.0)
        countLabel.textAlignment = NSTextAlignment.right
        self.contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { (make) in
            make.right.equalTo(amountLabel.snp.right)
            make.height.equalTo(20)
            make.top.equalTo(amountLabel.snp.bottom).offset(5)
            make.width.equalTo(120)
        }
        
        
        let progress: UIProgressView = UIProgressView.init(progressViewStyle: UIProgressView.Style.default)
        progress.trackTintColor = UIColor.init(red: 239 / 255.0, green: 239 / 255.0, blue: 239 / 255.0, alpha: 1.0)
        progress.progress = 0.1
        progress.layer.cornerRadius = 4
        progress.clipsToBounds = true
        progress.progressTintColor = incomeColor
        self.contentView.addSubview(progress)
        progress.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.right.equalTo(countLabel.snp.left).offset(10)
            make.height.equalTo(8)
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
