//
//  TallyModel.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/21.
//

import UIKit

class TallyModel: NSObject {

    enum TalleyType {
        case spending
        case income
    }

    var consumeType: ConsumeTypeModel?
    var amount: String?
    var date: String?
    var remark: String?
    
    override init() {
        super.init()
    }
    
    init(tallList: TallyList){
    
        self.amount = tallList.amount
        self.date = tallList.date
        self.remark = tallList.remark
        
       let consumeType = ConsumeTypeModel.init()
        consumeType.name = tallList.consumeType
        if tallList.tallyType == 1{
            consumeType.tallyType = .spending
        }else{
            consumeType.tallyType = .income
        }
        self.consumeType = consumeType
    }
    
}
