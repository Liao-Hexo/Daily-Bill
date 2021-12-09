//
//  SelectDateView.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

@objc protocol SelectDateViewDelegate: NSObjectProtocol{
    @objc optional func clicked(_ selectDateView: SelectDateView)
}

class SelectDateView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
     // MARK: - Lazy
    
     // MARK: - Property
  
    var todayView: TodayView?
    weak var delegate: SelectDateViewDelegate?

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
        
        self.backgroundColor = themeColor
        
        self.todayView = TodayView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height - 0.5))
        self.addSubview(self.todayView ?? UIView.init())
        
//        let line: UIView = UIView.init(frame: CGRect.init(x: 0, y: frame.height - 0.5, width: frame.width, height: 0.5))
//        line.backgroundColor = .red//UIColor.init(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0)
//        self.addSubview(line)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGesAction(tap:)))
        self.addGestureRecognizer(tap)
        
    }
    
    @objc func tapGesAction(tap: UITapGestureRecognizer) -> Void {
        self.delegate?.clicked!(self)
    }
    
    func setTitle(title: String) -> Void {
        self.todayView?.setTitleLabelText(title)
    }
}
