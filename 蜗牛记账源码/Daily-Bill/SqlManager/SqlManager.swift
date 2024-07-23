//
//  SqlManager.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/21.
//

import UIKit

class SqlManager: NSObject {
 
    enum SummaryType {
        case add
        case reduce
    }
    
    
    static let shareInstance: SqlManager = {
        let instance = SqlManager()
        return instance
    }()
    
    let tally_tb: TallyTable = TallyTable.init()
    let summary_tb: SummaryTallyTable = SummaryTallyTable.init()
    let consumetype_tb: ConsumeTypeTable = ConsumeTypeTable.init()
    
    static func getPath() -> String {
        let doc: String = (NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)).first ?? ""
        let path = doc.appending("/tally.sqlite3")
        return path
    }
    
     // MARK: - TallyTable
    
    func tallylist_create() -> Bool {
        return tally_tb.create()
    }
    
    func tallylist_insert(tally: TallyList) -> Bool {
        return tally_tb.insert(record: tally)
    }
    
    func tallylist_query(date: String, userid: String) -> [TallyList] {
        return tally_tb.query(date: date, userid: userid)
    }
    
    func tallylist_query(startDate: String, endDate: String,userid: String) -> [TallyList] {
        return tally_tb.query(startDate:startDate, endDate:endDate, userid: userid)
    }
    
    func tallylist_delete(id: Int64) -> Bool {
        return tally_tb.delete(id: id)
    }
  
    func tallylist_update(tally: TallyList) -> Bool {
        return tally_tb.update(record: tally)
    }
     // MARK: - SummaryTallyTable
    
    func summary_create() -> Bool {
        return summary_tb.create()
    }
    
    @discardableResult func summary_update(tally: TallyList, type: SummaryType) -> Bool {
        
        let result1 = monthlyUpdate(tally: tally, type: type)
        let result2 = yearlyUpade(tally: tally, type: type)
        if result1 && result2{
            return true
        }
        return false
        
    }
    
    private func monthlyUpdate(tally: TallyList, type: SummaryType) -> Bool {
      return update(tally: tally, sumaryType: 1, type: type)
    }
    
    private func yearlyUpade(tally: TallyList, type: SummaryType) -> Bool {
        return update(tally: tally, sumaryType: 2, type: type)
    }
    
    private func update(tally: TallyList, sumaryType: Int, type: SummaryType) -> Bool {
        
        var result: Bool = false
        
        var date: String = CalendarHelper.dateString(date: tally.date ?? "", originFromat: "yyyyMMdd", resultFromat: "yyyyMM")
        
        if sumaryType == 2{
            date = CalendarHelper.dateString(date: tally.date ?? "", originFromat: "yyyyMMdd", resultFromat: "yyyy")
        }
        
        let monthly_summary: Summary = summary_tb.query(userid: tally.userid ?? "00000000", date: date, tallyType: tally.tallyType, summaryType: sumaryType) ?? Summary.init()
        if monthly_summary.date == nil {
            
            if type == SummaryType.reduce{
                return false
            }
            
            monthly_summary.date = date
            monthly_summary.totalamount = tally.amount
            monthly_summary.tallytype = tally.tallyType
            monthly_summary.summarytype = sumaryType
            monthly_summary.userid = tally.userid
            
            result = summary_tb.insert(summary: monthly_summary)
            if result == false{
                print("月度：summary数据插入失败")
                return result
            }
            
            let monthly_id = summary_tb.queryID(summary: monthly_summary)
            if monthly_id == -1{
                print("月度：summary_tb.queryID失败")
                return false
            }else{
                let consumeType = ConsumeType.init()
                consumeType.keyName = tally.consumeType
                consumeType.keyValue = tally.amount
                consumeType.pid = monthly_id
                consumeType.count = 1
                result = consumetype_tb.insert(consumeType: consumeType)
                if result == false{
                    print("月度：consumetype_tb.insert失败")
                    return false
                }
            }
            
        }else{
            
            var sum: Float = 0.00
            if type == SummaryType.add{
                 sum = (monthly_summary.totalamount! as NSString).floatValue + (tally.amount! as NSString).floatValue
            }else{
                sum = (monthly_summary.totalamount! as NSString).floatValue - (tally.amount! as NSString).floatValue
            }
            monthly_summary.totalamount = String(format: "%.2lf", sum)
            
            result = summary_tb.update(totalAmount: monthly_summary.totalamount ?? "0.00", id: monthly_summary.id)
            
            
            if result == false{
                print("月度：summary_tb.update失败")
                return false
            }
            
            
            let consumeTypes = consumetype_tb.query(pid: monthly_summary.id)
            var flag = true
            for consumeType in consumeTypes{
                if consumeType.keyName == tally.consumeType{
                    
                    var sum1: Float = 0.00
                    if type == SummaryType.add{
                        sum1 = (consumeType.keyValue! as NSString).floatValue + (tally.amount! as NSString).floatValue
                        consumeType.count += 1
                    }else{
                        sum1 = (consumeType.keyValue! as NSString).floatValue - (tally.amount! as NSString).floatValue
                        consumeType.count -= 1
                    }
                    
                    
                    result = consumetype_tb.update(keyValue: String(format: "%.2lf", sum1),count: consumeType.count, id: consumeType.id)
                    if result == false{
                        print("月度：consumetype_tb.update失败")
                        return false
                    }
                    flag = false
                    
                }
            }
            
            if flag && type == SummaryType.add{
                
                let consumeType = ConsumeType.init()
                consumeType.keyName = tally.consumeType
                consumeType.keyValue = tally.amount
                consumeType.pid = monthly_summary.id
                consumeType.count = 1
                
                result = consumetype_tb.insert(consumeType: consumeType)
                
                if result == false{
                    print("月度：consumetype_tb.insert失败")
                    return false
                }
                
            }
            
        }
        
        return result
    }
    
    func query(userid: String, tallyType: Int, summaryType: Int, date: String) -> Summary? {
        
        return summary_tb.query(userid: userid, date: date, tallyType: tallyType, summaryType: summaryType)
        
    }
    
     // MARK: - ConsumeTypeTable
    
    func consumetype_create() -> Bool{
        return consumetype_tb.create()
    }
    
    func consumetype_query(pid: Int64) -> [ConsumeType] {
        return consumetype_tb.query(pid: pid)
    }
    
    
}
