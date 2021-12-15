//
//  BillingDetails_BottomView.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit
import SQLite

class BillingDetails_BottomView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    var detailLabel: UILabel?
    var cancleButton: UIButton?
    var dateLabel: UILabel?
    var imageView: UIImageView?
    var titleLabel: UILabel?
    var amountLabel: UILabel?
    var imageBackView: UIView?
    
    var editHandler: (()->Void)?
    var delHandler: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() -> Void {
        
        let detailLabel: UILabel = UILabel.init()
        detailLabel.text = "详情🔎"
        detailLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        detailLabel.textColor = .white
        self.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(15)
            make.height.equalTo(20)
        }
        self.detailLabel = detailLabel
        
        let dateLabel: UILabel = UILabel.init()
        dateLabel.text = "2019年03月28日 星期四"
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        dateLabel.textColor = .white
        self.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(detailLabel.snp.bottom).offset(15)
            make.height.equalTo(20)
        }
        self.dateLabel = dateLabel
        
        let imageBackView_Width: CGFloat =  44
        let imageBackView: UIView = UIView.init()
        imageBackView.backgroundColor = spendingColor
        imageBackView.layer.cornerRadius = imageBackView_Width / 2.0
        imageBackView.clipsToBounds = true
        self.addSubview(imageBackView)
        imageBackView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(dateLabel.snp.bottom).offset(15)
            make.width.height.equalTo(imageBackView_Width)
        }
        self.imageBackView = imageBackView
        
        let photoView: UIImageView = UIImageView.init()
        photoView.image = UIImage.init(named: "餐饮high")
        imageBackView.addSubview(photoView)
        photoView.snp.makeConstraints { (make) in
            make.left.top.equalTo(5)
            make.bottom.right.equalTo(-5)
        }
        self.imageView = photoView
        
        let titleLabel: UILabel = UILabel.init()
        titleLabel.text = "支付"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageBackView.snp.right).offset(15)
            make.height.equalTo(30)
            make.width.equalTo(60)
            make.centerY.equalTo(imageBackView)
        }
        self.titleLabel = titleLabel
        
        let amountLabel: UILabel = UILabel.init()
        amountLabel.text = "13.00"
        amountLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        amountLabel.textColor = .white
        amountLabel.textAlignment = NSTextAlignment.right
        self.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.right.equalTo(-20)
            make.height.equalTo(30)
            make.centerY.equalTo(imageBackView)
        }
        self.amountLabel = amountLabel
        
        let cancleButton: UIButton = UIButton()
        cancleButton.setTitle("取消编辑", for: .normal)
        cancleButton.tintColor = .white
        cancleButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        self.addSubview(cancleButton)
        cancleButton.addTarget(self, action: #selector(cancel), for: UIControl.Event.touchUpInside)
        cancleButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-5)
            make.width.equalTo(70)
            make.height.equalTo(25)
        }
        
        let editBtn: UIButton = UIButton.init(type: UIButton.ButtonType.system)
        editBtn.tintColor = .white
        editBtn.setTitle("编辑账单", for: UIControl.State.normal)
        editBtn.addTarget(self, action: #selector(editBtnAction(aBtn:)), for: UIControl.Event.touchUpInside)
        editBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        editBtn.backgroundColor = cellColor
        editBtn.layer.cornerRadius = 8
        self.addSubview(editBtn)
        
        let delBtn: UIButton = UIButton.init(type: UIButton.ButtonType.system)
        delBtn.tintColor = .white
        delBtn.setTitle("删除账单", for: UIControl.State.normal)
        delBtn.addTarget(self, action: #selector(delBtnAction(aBtn:)), for: UIControl.Event.touchUpInside)
        delBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        delBtn.backgroundColor = cellColor
        delBtn.layer.cornerRadius = 8
        self.addSubview(delBtn)
        
        editBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(44)
            make.top.equalTo(imageBackView.snp.bottom).offset(15)
        }
        delBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(editBtn.snp.bottom).offset(15)
            make.height.equalTo(44)
        }
        
    }
    
    @objc func cancel() {
        //        self.dismiss(animated: true, completion: nil)
        //        self.navigationController?.popViewController(animated: true)
        self.removeFromSuperview()
    }
    
    @objc func editBtnAction(aBtn: UIButton) -> Void {
        self.editHandler?()
    }
    
    @objc func delBtnAction(aBtn: UIButton) -> Void{
        self.delHandler?()
    }
    
    func editBtn(handler:@escaping (()->Void)) -> Void {
        self.editHandler = handler
    }
    
    func delBtn(handler:@escaping (()->Void)) -> Void {
        self.delHandler = handler
    }
    
}

