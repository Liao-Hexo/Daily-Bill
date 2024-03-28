//
//  AddTopView.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit
import SnapKit

class AddTopView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    typealias SegmentCallbackBlock = (_ index: Int) -> Void

    
    var backBtnHandler: CommonBlock!
    var segmentHandler: SegmentCallbackBlock!
    var aBackBtn: UIButton!
    var segment: UISegmentedControl?

    
    // MARK: - 初始化
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setupUI
    
    private func setupUI(frame:CGRect) -> Void {
        
        self.backgroundColor = ThemeColor.blackWhiteThemeColor//themeColor
        self.layoutIfNeeded()
        
        let backBtn: UIButton = UIButton.init(type: UIButton.ButtonType.system)
        backBtn.setImage(UIImage.init(named: "取消"), for: UIControl.State.normal)
        backBtn.tintColor = ThemeColor.blackWhiteFontColor//.white
        backBtn.addTarget(self, action: #selector(backBtnAction), for: UIControl.Event.touchUpInside)
        self.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.top.equalTo((kNavigationHeight - kStatusBarHeight - 20) / 2.0 + kStatusBarHeight)
            make.width.height.equalTo(20)
        }
        
        let items = ["支出", "收入"]
        let segment: UISegmentedControl = UISegmentedControl.init(items: items)
        segment.selectedSegmentIndex = 0
        segment.tintColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
//        segment.overrideUserInterfaceStyle = .dark
        segment.backgroundColor = ThemeColor.blackWhiteThemeColor
        segment.addTarget(self, action: #selector(segmentBtnAction(aSegment:)), for: UIControl.Event.valueChanged)
        self.addSubview(segment)
        segment.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(backBtn)
            make.width.equalTo(140)
            make.height.equalTo(25)
        }
        self.segment = segment
        
//        let bottomLine: UIView = UIView.init()
//        bottomLine.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.6)
//        self.addSubview(bottomLine)
//        bottomLine.snp.makeConstraints { (make) in
//            make.left.right.equalTo(0)
//            make.bottom.equalTo(0)
//            make.height.equalTo(0.5)
//        }
        
        self.aBackBtn = backBtn
        
        
    }
    
     // MARK: - Actions
    
    @objc private func backBtnAction() -> Void {
        if self.backBtnHandler != nil {
            self.backBtnHandler()
        }
    }
    
    func backBtnCallback(handler:@escaping CommonBlock) -> Void {
        self.backBtnHandler = handler
    }
    
    @objc private func segmentBtnAction(aSegment: UISegmentedControl) -> Void {
        if self.segmentHandler != nil {
            self.segmentHandler(aSegment.selectedSegmentIndex)
        }
    }
    
    func segmentCallback(handler: @escaping SegmentCallbackBlock) -> Void {
        self.segmentHandler = handler
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if CGRect.init(x: 0, y: kStatusBarHeight, width: 100, height: kNavigationHeight - kStatusBarHeight).contains(point){
            return self.aBackBtn
        }
        
        return super.hitTest(point, with: event)
    }
    
    func setSegmentIndex(index: Int) -> Void {
        if index < self.segment?.numberOfSegments ?? 2 {
            self.segment?.selectedSegmentIndex = index
        }
    }
    
}
