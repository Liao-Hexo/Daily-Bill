//
//  BillingDetails_BottomView.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

class BillingDetails_BottomView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

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

        let editBtn: UIButton = UIButton.init(type: UIButton.ButtonType.system)
        editBtn.tintColor = UIColor.init(red: 80 / 255.0, green: 80 / 255.0, blue: 80 / 255.0, alpha: 1)
        editBtn.setTitle("编辑项目", for: UIControl.State.normal)
        editBtn.addTarget(self, action: #selector(editBtnAction(aBtn:)), for: UIControl.Event.touchUpInside)
        editBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        editBtn.backgroundColor = UIColor.init(red: 167 / 255.0, green: 167 / 255.0, blue: 167 / 255.0, alpha: 0.3)
        editBtn.layer.cornerRadius = 8
        self.addSubview(editBtn)

        let delBtn: UIButton = UIButton.init(type: UIButton.ButtonType.system)
        delBtn.tintColor = UIColor.init(red: 80 / 255.0, green: 80 / 255.0, blue: 80 / 255.0, alpha: 1)
        delBtn.setTitle("删除项目", for: UIControl.State.normal)
        delBtn.addTarget(self, action: #selector(delBtnAction(aBtn:)), for: UIControl.Event.touchUpInside)
        delBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        delBtn.backgroundColor = UIColor.init(red: 167 / 255.0, green: 167 / 255.0, blue: 167 / 255.0, alpha: 0.3)
        delBtn.layer.cornerRadius = 8
        self.addSubview(delBtn)

        editBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(44)
        }
        delBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(editBtn.snp.bottom).offset(15)
            make.height.equalTo(44)
        }
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

