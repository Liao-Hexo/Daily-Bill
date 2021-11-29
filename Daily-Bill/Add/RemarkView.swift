//
//  RemarkView.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

@objc protocol RemarkViewDelegate: NSObjectProtocol{
    @objc optional func remarkTV(beginEditing textView: UITextView)
    @objc optional func remarkTV(endEditing textView: UITextView)
    @objc optional func remarkTV(editingComplete: UITextView)
}


class RemarkView: UIView, UITextViewDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var line: UIView?
    weak var delegate: RemarkViewDelegate?

    
    lazy var remarkTV: UITextView = {
        let aRemarkTV: UITextView = UITextView.init()
        aRemarkTV.font = UIFont.systemFont(ofSize: 12)
        aRemarkTV.text = "请输入备注信息"
        aRemarkTV.textColor = UIColor.lightGray
        aRemarkTV.delegate = self
        aRemarkTV.returnKeyType = UIReturnKeyType.done
        return aRemarkTV
    }()
    


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
        
        self.addSubview(self.remarkTV)
        self.remarkTV.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height - 0.5)
        
        let line: UIView = UIView.init(frame: CGRect.init(x: 0, y: frame.height - 0.5, width: frame.width, height: 0.5))
        line.backgroundColor = UIColor.init(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0)
        self.addSubview(line)
        self.line = line
        
    }
    
     // MARK: - Methods
    
    func inputSetHostView() -> UIView {
        return self.remarkTV.inputView?.superview ?? UIView.init()
    }
    
    func tvIsFirstResponder() -> Bool {
        return self.remarkTV.isFirstResponder
    }
    
    func tvBecomeFirstResponder() -> Void {
        self.remarkTV.becomeFirstResponder()
    }
    
    func setText(text: String) -> Void {
        self.remarkTV.text = text
        changeFrame(textView: self.remarkTV)
    }
    
    func changeFrame(textView: UITextView) -> Void {
        
        var frame: CGRect = textView.frame
        frame.size.height = textView.contentSize.height
        textView.frame = frame
        
        var lineFrame: CGRect = self.line?.frame ?? CGRect.zero
        lineFrame.origin.y = textView.frame.maxY
        self.line?.frame = lineFrame
        
        var superViewFrame: CGRect = textView.superview?.frame ?? CGRect.zero
        superViewFrame.size.height = frame.height + lineFrame.height
        textView.superview?.frame = superViewFrame
        
    }
    
     // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "请输入备注信息" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        
        self.delegate?.remarkTV!(beginEditing: textView)
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.count < 1{
            textView.text = "请输入备注信息"
            textView.textColor = UIColor.lightGray
        }
        
        self.delegate?.remarkTV!(endEditing: textView)

    }
    
    func textViewDidChange(_ textView: UITextView) {
        
//        let rect: CGRect = (textView.text as NSString).boundingRect(with: CGSize.init(width: textView.frame.width, height: 0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : textView.font ?? UIFont.systemFont(ofSize: 12)], context: nil)
        
       changeFrame(textView: textView)
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.delegate?.remarkTV!(editingComplete: textView)
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
}
