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
        
        let topView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: 48))
        topView.backgroundColor = UIColor.white
        self.addSubview(topView)
        setTopViewSubViews(topView: topView)

        let datePicker: UIDatePicker = UIDatePicker.init(frame: CGRect.init(x: 0, y: topView.frame.maxY, width: frame.width, height: frame.height - topView.frame.maxY))
        datePicker.backgroundColor = UIColor.init(red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1.0)
        datePicker.locale = Locale.init(identifier: "Chinese")
        datePicker.datePickerMode = UIDatePicker.Mode.date
        self.addSubview(datePicker)
        self.datePicker = datePicker
        
    }
    
    func setTopViewSubViews(topView: UIView) -> Void {
        
        let cancelBtn: UIButton = UIButton.init(type: UIButton.ButtonType.system)
        cancelBtn.setImage(UIImage.init(named: "下箭头"), for: UIControl.State.normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction(aBtn:)), for: UIControl.Event.touchUpInside)
        cancelBtn.tintColor = UIColor.init(red: 24 / 255.0, green: 24 / 255.0, blue: 24 / 255.0, alpha: 1.0)
        topView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
            make.left.equalTo(15)
            make.centerY.equalTo(topView)
        }
        
        let okBtn: UIButton = UIButton.init(type: UIButton.ButtonType.system)
        okBtn.setImage(UIImage.init(named: "对号"), for: UIControl.State.normal)
        okBtn.addTarget(self, action: #selector(okBtnAction(aBtn:)), for: UIControl.Event.touchUpInside)
        okBtn.tintColor = UIColor.init(red: 24 / 255.0, green: 24 / 255.0, blue: 24 / 255.0, alpha: 1.0)
        topView.addSubview(okBtn)
        okBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
            make.right.equalTo(-15)
            make.centerY.equalTo(topView)
        }
        
        let lineColor: UIColor = UIColor.init(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        
        let topLine: UIView = UIView.init()
        topLine.backgroundColor = lineColor
        topView.addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        let bottomLine: UIView = UIView.init()
        bottomLine.backgroundColor = lineColor
        topView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.5)
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
