//
//  CustomTabBar.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/19.
//

import UIKit
import SnapKit

class CustomTabBar: UITabBar {
    
    typealias AddBtnBlock = ()->Void
    var block: AddBtnBlock!
    
    var addButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundImage = UIImage.init()
//        self.shadowImage = UIImage.init()
        
        self.backgroundColor = ThemeColor.blackWhiteThemeColor
        self.tintColor = .orange
        self.barTintColor = .white
        
        self.addButton = UIButton(type: UIButton.ButtonType.system)
        self.addButton.setBackgroundImage(UIImage.init(named: "添加"), for: UIControl.State.normal)
        self.addSubview(self.addButton)
        self.addButton.addTarget(self, action:#selector(addBtnAction), for: UIControl.Event.touchUpInside)
        self.addButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset((kScreenWidth-50) / 2)
            make.top.equalToSuperview().offset(-10)
            make.width.equalTo(55)
            make.height.equalTo(55)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addBtnAction() -> Void {
        
        if self.block != nil{
            self.block()
        }
    }
    
    func addBtnHandler(handler:@escaping AddBtnBlock) -> Void {
        
        self.block = handler
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if !self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01 {
            return nil
        }
        
        if self.addButton.frame.contains(point) {
            return addButton
        } else {
            return super.hitTest(point, with: event)
        }
    }
    
}
