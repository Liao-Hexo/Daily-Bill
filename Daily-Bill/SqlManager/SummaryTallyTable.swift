//
//  SummaryTallyTable.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/21.
//

import UIKit
import SQLite

class SummaryTallyTable: NSObject {

    let TABLE = Table("monthly_spending_tally")
    let ID = Expression<Int64>("id")
    let USERID = Expression<String>("userid")
    let TOTALAMOUNT = Expression<String>("totalamount")
    let DATE = Expression<String>("date")
    let TALLYTYPE = Expression<Int>("tallytype")  //1、支出， 2、收入
    let SUMMARYTYPE = Expression<Int>("summarytype") //1、月度， 2、年度
    
    func create() ->  Bool{
        do {
            
            let db = try Connection(SqlManager.getPath())
            try db.run(TABLE.create(ifNotExists: true){ table in
                
                table.column(ID, primaryKey: true)
                table.column(USERID)
                table.column(TOTALAMOUNT)
                table.column(DATE)
                table.column(TALLYTYPE)
                table.column(SUMMARYTYPE)
                
            })
            
            
            return true
        } catch {
            return false
        }
    }
    
    func insert(summary: Summary) -> Bool {
        do {
            let db = try Connection(SqlManager.getPath())
            let insert = try db.prepare("INSERT INTO monthly_spending_tally (userid, totalamount, date, tallytype, summarytype) VALUES (?, ?, ?, ?, ?)")
            try insert.run(summary.userid, summary.totalamount, summary.date, summary.tallytype, summary.summarytype)
           return true
        } catch {
            return false
        }
    }
    
    func queryID(summary: Summary) -> Int64{
        
        do {
            
           let db = try Connection(SqlManager.getPath())
            let select = TABLE.select(*).filter(USERID == summary.userid ?? "").filter(DATE == summary.date ?? "").filter(TOTALAMOUNT == summary.totalamount ?? "").filter(TALLYTYPE == summary.tallytype).filter(SUMMARYTYPE == summary.summarytype)
            let rows = try db.prepare(select)
            
            var id: Int64 = 0
            for row:Row in rows {
                id = try row.get(ID)
                break
            }
            return id
            
        } catch {
            return -1
        }
        
    }
    
    func query(userid: String, date: String, tallyType: Int, summaryType: Int) -> Summary? {
        
        do {
            
            let db = try Connection(SqlManager.getPath())
            let select = TABLE.select(*).filter(USERID == userid).filter(DATE == date).filter(TALLYTYPE == tallyType).filter(SUMMARYTYPE == summaryType)
            let rows = try db.prepare(select)
            
            let summary: Summary = Summary.init()
            for row:Row in rows {
                summary.id = try row.get(ID)
                summary.userid = try row.get(USERID)
                summary.totalamount = try row.get(TOTALAMOUNT)
                summary.tallytype = try row.get(TALLYTYPE)
                summary.summarytype = try row.get(SUMMARYTYPE)
                summary.date = try row.get(DATE)
                break
            }
            return summary
            
        } catch {
            return nil
        }
        
    }
    
    func update(totalAmount: String, id: Int64) -> Bool{
        
        do {
            let db = try Connection(SqlManager.getPath())
            let update = try db.prepare("UPDATE monthly_spending_tally SET totalamount = ? WHERE id = ?")
            try update.run(totalAmount, id)
            return true
        } catch {
            return false
        }
        
    }
    
    
    
}
