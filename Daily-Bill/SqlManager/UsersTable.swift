//
//  UsersTable.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

//import UIKit
//import SQLite
//
//class UsersTable: NSObject {
//
//
//
//    let users = Table("users")
//    let id = Expression<Int64>("id")
//    let name = Expression<String?>("name")
//    let email = Expression<String?>("email")
//    let userid = Expression<String>("userid")
//
//    func createTable() -> Void {
//
//        do {
//            let db = try Connection(SqlManager.getPath())
//            try db.run(users.create(ifNotExists: true){ t in
//                t.column(id, primaryKey: true)
//                t.column(name)
//                t.column(email)
//                t.column(userid)
//            })
//        } catch  {
//
//        }
//    }
//
//    func insertUser(user: User) -> Bool {
//        do {
//
//            let db = try Connection(SqlManager.getPath())
//            let insert = try db.prepare("INSERT INTO users (name, userid) VALUES (?, ?)")
//            try insert.run(user.name, user.userid)
//            return true
//        } catch {
//            print("插入失败")
//            return false
//        }
//    }
//
//    func readUsers(aUserid: String?) -> [User] {
//
//        let array: NSMutableArray = NSMutableArray.init()
//        do {
//
//            let db = try Connection(SqlManager.getPath())
//            let userRows = try db.prepare(users.select(*).filter(userid == aUserid ?? "00000000"))
//
//            for row:Row in userRows {
//                let user: User = User.init()
//                user.name = try row.get(name)
//                user.userid = try row.get(userid)
//                array.add(user)
//            }
//
//        } catch  {
//            print("读取失败")
//        }
//
//        return array as! [User]
//
//
//    }
//
//    func updateUser(user: User) -> Bool {
//        do {
//            let db = try Connection(SqlManager.getPath())
//            let update = try db.prepare("UPDATE users SET name = ?   WHERE userid = ?")
//            try update.run(user.name, user.userid)
//            return true
//        } catch  {
//            print("更新失败")
//            return false
//        }
//    }
//
//    func delete(user: User) -> Bool {
//        do {
//            let db = try Connection(SqlManager.getPath())
//            let delete = try db.prepare("DELETE FROM users WHERE userid = ?")
//            try delete.run(user.userid)
//            return true
//        } catch {
//            print("删除失败")
//            return false
//        }
//    }
//
//    
//}
