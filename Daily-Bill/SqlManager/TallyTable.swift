//
//  TallyTable.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/21.
//

import UIKit
import SQLite

class TallyTable: NSObject {

    let TALLY = Table("tallyList")
    let ID = Expression<Int64>("id")
    let USERID = Expression<String>("userid")
    let AMOUNT = Expression<String>("amount")
    let DATE = Expression<String>("date")
    let REMARK = Expression<String?>("remark")  //备注
    let CONSUMETYPE = Expression<String>("consumetype")
    let TALLYTYPE = Expression<Int>("tallytype")  //1、支出， 2、收入

    func create() -> Bool {
        do {
            
            let db = try Connection(SqlManager.getPath())
            try db.run(TALLY.create(ifNotExists: true){ table in
                table.column(ID, primaryKey: true)
                table.column(USERID)
                table.column(AMOUNT)
                table.column(DATE)
                table.column(REMARK)
                table.column(CONSUMETYPE)
                table.column(TALLYTYPE)
            })
            
            return true
            
        } catch{
            print("Tally表创建失败")
            return false
        }
        
    }
    
    func insert(record tally: TallyList) -> Bool {
        do {
            let db = try Connection(SqlManager.getPath())
            let insert = try db.prepare("INSERT INTO tallyList (userid, amount, date, remark, consumetype, tallytype) VALUES (?, ?, ?, ?, ?, ?)")
            try insert.run(tally.userid, tally.amount, tally.date, tally.remark, tally.consumeType, tally.tallyType)
            return true
        } catch  {
            return false
        }
    }
    
    
    func update(record tally: TallyList) -> Bool {
        do {
            let db = try Connection(SqlManager.getPath())
            let update = try db.prepare("UPDATE tallyList SET userid = ?,amount = ?, date = ?,remark = ?, consumetype = ?, tallytype = ? WHERE id = ?")
            try update.run(tally.userid, tally.amount, tally.date, tally.remark, tally.consumeType, tally.tallyType, tally.id)
            return true
        } catch  {
            return false
        }
    }
    
    func query(date: String, userid: String) -> [TallyList] {
        
        let array: NSMutableArray = NSMutableArray.init()
        do {
            
            let db = try Connection(SqlManager.getPath())
            let tallyListRows = try db.prepare(TALLY.select(*).filter(DATE == date).filter(USERID == userid).order(ID.desc))
            
            for row:Row in tallyListRows {
                let tally: TallyList = TallyList.init()
                tally.id = try row.get(ID)
                tally.amount = try row.get(AMOUNT)
                tally.date = try String(format: "%@", row.get(DATE))
                tally.consumeType = try row.get(CONSUMETYPE)
                tally.tallyType = try row.get(TALLYTYPE)
                tally.remark = try row.get(REMARK)
                tally.userid = try row.get(USERID)
                array.add(tally)
            }
            
        } catch  {
            print("读取失败")
        }
        
        return array as! [TallyList]
    }
    
    func query(startDate: String, endDate: String, userid: String) -> [TallyList] {
        
        let array: NSMutableArray = NSMutableArray.init()
        
        let select = "SELECT * FROM tallyList WHERE ((date >=  \"\(startDate)\") AND (date <= \"\(endDate)\") AND (userid = \"\(userid)\")) ORDER BY id DESC"
        
        var db: OpaquePointer!
        let openDBResult = sqlite3_open(SqlManager.getPath(), &db)
        if openDBResult != SQLITE_OK{
            print("数据库打开失败")
            return array as! [TallyList]
        }
        
        var handler: OpaquePointer!
       let queryResult = sqlite3_prepare_v2(db, select, -1, &handler, nil)
        if queryResult == SQLITE_OK{
            
                while(sqlite3_step(handler) == SQLITE_ROW){
                    
                    let id = sqlite3_column_int(handler, 0)
                    let aUserid = sqlite3_column_text(handler, 1)
                    let amount = sqlite3_column_text(handler, 2)
                    let date = sqlite3_column_text(handler, 3)
                    let remark = sqlite3_column_text(handler, 4)
                    let consumeType = sqlite3_column_text(handler, 5)
                    let tallyType = sqlite3_column_int(handler, 6)
                    
                    
                    let tally: TallyList = TallyList.init()
                    tally.id = Int64(id)
                    tally.amount = String(cString: UnsafePointer(amount!))
                    tally.date = String(cString: UnsafePointer(date!))
                    tally.consumeType = String(cString: UnsafePointer(consumeType!))
                    if remark != nil{
                        tally.remark = String(cString: UnsafePointer(remark!))
                    }
                    tally.userid = String(cString: UnsafePointer(aUserid!))
                    tally.tallyType = Int(tallyType)

                    
                    array.add(tally)
                    
                }
    
        }
        
        sqlite3_finalize(handler)
        let closeResult = sqlite3_close(db)
        if closeResult == SQLITE_OK{
            print("数据库关闭成功")
        }
        
        
        return array as! [TallyList]

        
        
        /*
        
        do {
         
            let db = try Connection(SqlManager.getPath())
            let select = TALLY.select(*).filter(DATE >= startDate).filter(DATE <= endDate).filter(USERID == userid).order(ID.desc)

            let tallyListRows = try db.prepare(select)

            for row:Row in tallyListRows{
                let tally: TallyList = TallyList.init()
                tally.id = try row.get(ID)
                tally.amount = try row.get(AMOUNT)
                tally.date = try row.get(DATE)
                tally.consumeType = try row.get(CONSUMETYPE)
                tally.tallyType = try row.get(TALLYTYPE)
                tally.remark = try row.get(REMARK)
                tally.userid = try row.get(USERID)
                array.add(tally)
            }
            
        } catch  {
            print("读取失败")
        }
 
        */
 
    }
    
    func delete(id: Int64) -> Bool {
        do {
            let db = try Connection(SqlManager.getPath())
            let delete = try db.prepare("DELETE FROM tallyList WHERE id = ?")
            try delete.run(id)
            return true
        }catch{
            return false
        }
    }
    
    func associatedSummary(yearlyID: Int64, monthlyID: Int64) -> Bool {
        return false
    }
}
