//
//  TallyList.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/21.
//

import UIKit

class TallyList: NSObject {

    var id: Int64 = 0
    var userid: String?
    var date: String?
    var amount: String?
    var remark: String?
    var consumeType: String?
    var tallyType: Int = 0  //1: 支出， 2： 收入
    
    init(tally: TallyModel) {
       super.init()
        self.userid = "00000000"
        self.date = tally.date
        self.amount = tally.amount
        self.remark = tally.remark
        self.consumeType = tally.consumeType?.name
        if tally.consumeType?.tallyType == TallyModel.TalleyType.spending{
            self.tallyType = 1
        }else{
            self.tallyType = 2
        }
    }
    
    override init() {
        super.init()
    }
    
   
}
