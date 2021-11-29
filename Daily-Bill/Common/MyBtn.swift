//
//  MyBtn.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

class MyBtn: UIButton {

    typealias Handler = () -> Void
    
    
    var normalColor: UIColor = UIColor.init(red: 57 / 255.0, green: 69 / 255.0, blue: 85 / 255.0, alpha: 1.0)
    var highlightColor: UIColor = UIColor.init(red: 67 / 255.0, green: 79 / 255.0, blue: 95 / 255.0, alpha: 1.0)
    var block: Handler?
    
    
    func setNormalColor(color: UIColor) -> Void {
        self.normalColor = color
        self.backgroundColor = self.normalColor
    }
    
    
    func setHighlightColor(color: UIColor) -> Void {
        self.highlightColor = color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI(frame: frame, title: nil, imgName: nil)
    }
    
    init(frame:CGRect, title:String) {
        super.init(frame: frame)
        setupUI(frame: frame, title: title, imgName: nil)
        
    }
    
    init(frame: CGRect, imgName: String) {
        super.init(frame: frame)
        setupUI(frame: frame, title: nil, imgName: imgName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(frame:CGRect, title: String?, imgName: String?) -> Void {
        
        self.backgroundColor = self.normalColor
        self.frame = frame
        
        if title != nil {
            self.setTitle(title, for: UIControl.State.normal)
        }
        
        self.addTarget(self, action: #selector(btnAction), for: UIControl.Event.touchUpInside)
        self.addTarget(self, action: #selector(highlightAction), for: UIControl.Event.touchDown)
        self.addTarget(self, action: #selector(otherEventAction), for: UIControl.Event(rawValue: UIControl.Event.touchCancel.rawValue | UIControl.Event.touchDragOutside.rawValue))
        
    }
    
    @objc func btnAction() -> Void {
        
        
        if self.backgroundColor != self.normalColor {
            //间隔时长不能太短，也不能太长，太短会显示不了点击效果，太长会感觉点击效果太差
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.backgroundColor = self.normalColor
            }
        }
        
        self.block?()
        
    }
    
    @objc private func highlightAction() -> Void {
        
        self.backgroundColor = self.highlightColor
        
    }
    
    @objc private func otherEventAction() -> Void {
        
        if self.backgroundColor != self.normalColor {
            
            self.backgroundColor = self.normalColor
        }
        
    }
    
    func click(_ handler:@escaping Handler) -> Void {
        self.block = handler
    }

}
