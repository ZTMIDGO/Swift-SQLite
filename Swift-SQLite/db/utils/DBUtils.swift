//
//  DBUtils.swift
//  Swift-SQLite
//
//  Created by ztm on 2024/9/10.
//

import Foundation
import SQLite3

struct DBUtils{
    static func createTable(_ db: OpaquePointer, _ sql: String) ->Bool{
        exec(db: db, sql: sql, args: nil)
    }
    
    static func insert(db: OpaquePointer, sql: String, args: [Any]?) ->Bool{
        exec(db: db, sql: sql, args: args)
    }
    
    static func query(db: OpaquePointer, sql: String, args: [Any]?) ->OpaquePointer?{
        var statement: OpaquePointer?
        sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK
        return statement
    }
    
    static func update(db: OpaquePointer, sql: String, args: [Any]?) ->Bool{
        exec(db: db, sql: sql, args: args)
    }
    
    static func delete(db: OpaquePointer, sql: String, args: [Any]?) ->Bool{
        exec(db: db, sql: sql, args: args)
    }
    
    static func getUserVersion(db: OpaquePointer, def:Int) ->Int{
        var version:Int = def
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, "PRAGMA user_version", -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                version = Int(sqlite3_column_int(statement, 0))
            }
        }
        sqlite3_finalize(statement)
        return version
    }
    
    static func setUserVersion(db: OpaquePointer, version:Int){
        update(db: db, sql: "PRAGMA user_version = \(version)", args: nil)
    }
    
    static func getColumns(db: OpaquePointer) ->[String]{
        var list:[String] = []
        let size:Int32 = sqlite3_column_count(db)
        for index in 0...size-1{
            list.append(String(describing: String(cString: sqlite3_column_name(db, index))))
        }
        return list
    }
    
    static func exec(db: OpaquePointer, sql: String, args: [Any]?) ->Bool{
        var success:Bool = false
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK{
            bindStatement(statement: statement!, args: args)
            success = sqlite3_step(statement) == SQLITE_DONE
        }else{
            success = false
        }
        sqlite3_finalize(statement)
        return success
    }
    
    static func bindStatement(statement:OpaquePointer, args:[Any]?){
        if args == nil || args?.count == 0{ return }
        for i in 0...args!.count-1{
            let index:Int32 = Int32(i + 1)
            let item:Any? = args![i]
            if item == nil{
                sqlite3_bind_null(statement, index)
            }else if item is String{
                sqlite3_bind_text(statement, index, (item as! NSString).utf8String, -1, nil)
            }else if item is Int{
                sqlite3_bind_int(statement, index, Int32(item as! Int))
            }else if item is Double{
                sqlite3_bind_double(statement, index, item as! Double)
            }
        }
    }
}
