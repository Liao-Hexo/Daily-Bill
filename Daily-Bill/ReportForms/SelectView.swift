//
//  SelectView.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

class SelectView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    enum SelectType {
        case spending
        case income
        case other
    }
    
    //MARK: - Property
    
    private var handler: ((Bool)->Void)?
    var isSelected: Bool{
        set{
            self.selectedBtn.isSelected = newValue
        }
        get{
            return self.selectedBtn.isSelected
        }
    }
    
    
    //MARK: - Set
    var _type: SelectType = SelectType.spending
    var type: SelectType{
        set {
            _type = newValue
            
            if _type == SelectType.spending{
                self.selectedBtn.setBackgroundImage(UIImage.init(named: "选中"), for: UIControl.State.selected)
                self.amountLabel.textColor = themeColor
            }
            
            if _type == SelectType.income {
                self.selectedBtn.setBackgroundImage(UIImage.init(named: "选中-1"), for: UIControl.State.selected)
                self.amountLabel.textColor = incomeColor
            }
            
        }
        get{
            return _type
        }
    }
    
    //MARK: - Lazy
    
    private lazy var selectedBtn: UIButton = {
        let aBtn: UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        aBtn.setBackgroundImage(UIImage.init(named: "选中"), for: UIControl.State.selected)
        aBtn.setBackgroundImage(UIImage.init(named: "未选中"), for: UIControl.State.normal)
        aBtn.addTarget(self, action: #selector(selectedBtnAction(aBtn:)), for: UIControl.Event.touchUpInside)
        return aBtn
    }()
    
    lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel.init()
        label.textColor = UIColor.init(red: 65 / 255.0, green: 64 / 255.0, blue: 67 / 255.0, alpha: 1.0)
        label.text = "label"
        label.font = UIFont.init(name: "PingFangSC-Regular", size: 12)
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label: UILabel = UILabel.init()
        label.text = "label"
        label.font = UIFont.init(name: "PingFangSC-Regular", size: 17)
        return label
    }()
    
    //MARK: - Instance
    
    init() {
        super.init(frame: CGRect.zero)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetupUI

    private func setupUI() -> Void {
        
//        self.backgroundColor = .darkText
        
        self.addSubview(self.selectedBtn)
        self.selectedBtn.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.top.equalTo(10)
            make.width.height.equalTo(15)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.selectedBtn.snp.right).offset(10)
            make.height.equalTo(15)
            make.centerY.equalTo(self.selectedBtn)
        }
        
        self.addSubview(self.amountLabel)
        self.amountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp.left)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
        
    }
    
    //MARK: - Methods
    
    @objc private func selectedBtnAction(aBtn: UIButton) -> Void {
        aBtn.isSelected = !aBtn.isSelected
        
        if self.handler != nil {
            self.handler?(aBtn.isSelected)
        }
        
    }
    
    public func selectedCallback(callback: @escaping (Bool)->Void) -> Void {
        self.handler = callback;
    }
    
    //MARK: - Responder
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) {
            return self.selectedBtn
        }
       return super.hitTest(point, with: event)
    }
    
}
