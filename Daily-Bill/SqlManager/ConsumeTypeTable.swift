//
//  ConsumeTypeTable.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/21.
//

import UIKit
import SQLite

class ConsumeTypeTable: NSObject {

    //monthly_spending_tally的关联表
    
    let TABLE = Table("consumetype")
    let ID = Expression<Int64>("id")
    let KEYNAME = Expression<String>("keyname")
    let KEYVALUE = Expression<String>("keyvalue")
    let COUNT = Expression<Int64>("count")
    let PID = Expression<Int64>("pid") //关联表ID
    
    func create() -> Bool {
        do {
            let db = try Connection(SqlManager.getPath())
            try db.run(TABLE.create(ifNotExists: true){ table in
                table.column(ID, primaryKey: true)
                table.column(KEYNAME)
                table.column(KEYVALUE)
                table.column(PID)
                table.column(COUNT)
            })
            return true
        }catch{
            return false
        }
    }
    
    func insert(consumeType: ConsumeType) -> Bool {
        
        
        do {
            let db = try Connection(SqlManager.getPath())
            let insert = try db.prepare("INSERT INTO consumetype (keyname, keyvalue, pid, count) VALUES (?, ?, ?, ?)")
            try insert.run(consumeType.keyName, consumeType.keyValue, consumeType.pid, consumeType.count)
            
            return true
        }catch{
            return false
        }
        
    }
    
    func query(pid: Int64) -> [ConsumeType] {
        
        do {
            let db = try Connection(SqlManager.getPath())
            let select = TABLE.select(*).filter(PID == pid)
            let rows = try db.prepare(select)
            
            let array = NSMutableArray.init()
            for row: Row in rows {
                let consumeType = ConsumeType.init()
                consumeType.id = try row.get(ID)
                consumeType.keyName = try row.get(KEYNAME)
                consumeType.keyValue = try row.get(KEYVALUE)
                consumeType.pid = try row.get(PID)
                consumeType.count = try row.get(COUNT)
                array.add(consumeType)
            }
            
            return array as! [ConsumeType]
            
        }catch{
            
            return NSMutableArray.init() as! [ConsumeType]
        }
        
    }
    
    func delete(id: Int64) -> Bool {
        do {
            let db = try Connection(SqlManager.getPath())
            let delete = try db.prepare("DELETE FROM consumetype WHERE id = ?")
            try delete.run(id)
            return true
        }catch{
            return false
        }
    }
    
    func update(keyValue: String, count: Int64, id: Int64) -> Bool {
        
        do{
            let db = try Connection(SqlManager.getPath())
            let update = try db.prepare("UPDATE consumetype SET keyvalue = ?, count = ? WHERE id = ?")
            try update.run(keyValue,count,id)
            return true
        }catch{
            return false
        }
    }
    
    
    
}
