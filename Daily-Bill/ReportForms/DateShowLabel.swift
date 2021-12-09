//
//  DateShowLabel.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

class DateShowLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var handler: (()->Void)!
    
    override var text: String?{
        set{
            self.content = newValue ?? ""
        }
        get{
            return self.content
        }
    }
    private var _selected: Bool = false
    var selected: Bool {
        set{
            
            if self.canClicked{
                _selected = newValue
                if _selected == true {
                    self.contentLabel.backgroundColor = spendingColor
                    self.contentLabel.textColor = .white
                }else{
                    self.contentLabel.backgroundColor = UIColor.clear
                    self.contentLabel.textColor = .white
                }
            }
          
        }
        get{
            return _selected
        }
    }
    var canClicked: Bool{
        set{
            if newValue{
                self.isUserInteractionEnabled = true
                self.contentLabel.textColor = .white
            }else{
                self.isUserInteractionEnabled = false
                self.contentLabel.textColor = .white
            }
        }
        get{
            return self.isUserInteractionEnabled
        }
    }
    
    private var content: String{
        set{
            self.contentLabel.text = newValue
            
            var width: CGFloat = self.width(of: newValue)
            if width < 30 {
                width = 30
            }else{
                width = 40
            }
            
            self.contentLabel.snp.remakeConstraints { (make) in
                make.centerX.centerY.equalTo(self)
                make.height.equalTo(30)
                make.width.equalTo(width)
            }
            self.contentLabel.layer.cornerRadius = 30 / 2.0
            self.contentLabel.clipsToBounds = true
        }
        get{
            return self.contentLabel.text ?? ""
        }
    }
    private var contentLabel: UILabel = UILabel.init()



    override func awakeFromNib() {
        self.setupUI()
    }
  
    
    func setupUI() -> Void {
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = themeColor
        
        self.contentLabel = UILabel.init()
        self.contentLabel.textAlignment = NSTextAlignment.center
        self.contentLabel.font = UIFont.systemFont(ofSize: 14)
        self.contentLabel.text = "2019"
        self.contentLabel.adjustsFontSizeToFitWidth = true
        self.contentLabel.minimumScaleFactor = 2.0
        self.contentLabel.isUserInteractionEnabled = true
        self.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGesture(tap:)))
        self.addGestureRecognizer(tap)
        
    }
    
    func width(of string: String) -> CGFloat {
        return (string as NSString).boundingRect(with: CGSize.init(width: 0, height: 20), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil).size.width + 5
    }
    
    @objc func tapGesture(tap: UITapGestureRecognizer) -> Void {
        if self.handler != nil {
            self.handler()
        }
    }
    
    func clicked(handler: @escaping(()->Void)) -> Void {
        self.handler = handler
    }
    
}
