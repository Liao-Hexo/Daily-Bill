//
//  Key.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

@objc protocol KeyDelegate: NSObjectProtocol{
    func clickHandler(key: Key)
}


class Key: MyBtn {
    
   public enum KeyNumber: Int {
        case none = 0
        case zero
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case point
        case add
        case reduce
        case equal
        case done
        case delete
    }
    
    var keyNumber: KeyNumber?
    weak var delegate: KeyDelegate?
    
    override func btnAction() -> Void{
        super.btnAction()
        
        if let delegate = self.delegate{
            delegate.clickHandler(key: self)
        }
        
        
    }
    
    
    
    
    
}
