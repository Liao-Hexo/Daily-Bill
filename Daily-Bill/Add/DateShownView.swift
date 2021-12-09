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
        
        var backView: UIView = UIView()
        let imageView = UIImageView(image: UIImage(named: "背景6"))
        imageView.frame = backView.frame
        backView = imageView
        self.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let view: UIView = UIView()
        view.backgroundColor = .clear
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.overrideUserInterfaceStyle = .dark
        datePicker.locale = Locale.init(identifier: "Chinese")
        datePicker.datePickerMode = UIDatePicker.Mode.date
        view.addSubview(datePicker)
        datePicker.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        self.datePicker = datePicker
        
        let cancelBtn: UIButton = UIButton.init(type: UIButton.ButtonType.system)
        cancelBtn.setTitle("取消选择", for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction(aBtn:)), for: UIControl.Event.touchUpInside)
        cancelBtn.tintColor = .white
        view.addSubview(cancelBtn)
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
        view.addSubview(okBtn)
        okBtn.snp.makeConstraints { (make) in
            make.width.equalTo(90)
            make.height.equalTo(25)
            make.right.equalTo(-10)
            make.top.equalTo(10)
        }
        
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
