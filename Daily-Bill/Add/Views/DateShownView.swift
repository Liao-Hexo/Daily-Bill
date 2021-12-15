//
//  DateShownView.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

@objc protocol DateShownViewDelegate: NSObjectProtocol{
    @objc optional func cancel(_ dateShown: DateShownView)
    @objc optional func ok(_ dateShown: DateShownView, date: Date)
}

class DateShownView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
     // MARK: - Property
    
    var datePicker: UIDatePicker?
    weak var delegate: DateShownViewDelegate?
    

     // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     // MARK: - SetupUI
    
    func setupUI(frame: CGRect) -> Void {
//        self.backgroundColor = UIColor(patternImage: UIImage(named: "背景5")!)
        
        let cancelBtn: UIButton = UIButton.init(type: UIButton.ButtonType.system)
        cancelBtn.setTitle("取消选择", for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction(aBtn:)), for: UIControl.Event.touchUpInside)
        cancelBtn.tintColor = .white
        self.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.width.equalTo(90)
            make.height.equalTo(25)
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        let okBtn: UIButton = UIButton.init(type: UIButton.ButtonType.system)
        okBtn.setTitle("确认选择", for: .normal)
        okBtn.addTarget(self, action: #selector(okBtnAction(aBtn:)), for: UIControl.Event.touchUpInside)
        okBtn.tintColor = .white
        self.addSubview(okBtn)
        okBtn.snp.makeConstraints { (make) in
            make.width.equalTo(90)
            make.height.equalTo(25)
            make.right.equalTo(-10)
            make.top.equalTo(10)
        }
        
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.overrideUserInterfaceStyle = .dark
        datePicker.locale = Locale.init(identifier: "Chinese")
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.preferredDatePickerStyle = .wheels
        self.addSubview(datePicker)
        datePicker.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(okBtn.snp.bottom).offset(20)
        }
        self.datePicker = datePicker
        
    }
    
     // MARK: - BtnActions
    
    @objc func cancelBtnAction(aBtn: UIButton) -> Void {
        
        if let delegate = self.delegate{
            delegate.cancel!(self)
        }
        
    }
    
    @objc func okBtnAction(aBtn: UIButton) -> Void {
        if let delegate = self.delegate {
            delegate.ok!(self, date: self.datePicker?.date ?? Date.init())
        }
    }

}
