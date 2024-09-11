//
//  SQLInsert.swift
//  Swift-SQLite
//
//  Created by ztm on 2024/9/10.
//

import Foundation

public struct SQLInsert: SQL{
    let table:String
    let values:[String:Any]
    var keys:[String] = []
    var args:[Any] = []
    
    init(_ table: String, _ values: [String : Any]) {
        self.table = table
        self.values = values
        
        for (key, value) in values{
            keys.append(key)
            args.append(value)
        }
    }
    
    func getSQL() -> String {
        var keyClause:String = ""
        var valueClause:String = ""
        for i in 0...keys.count-1{
            keyClause.append(keys[i])
            valueClause.append("?")
            if i < keys.count-1{
                keyClause.append(",")
                valueClause.append(",")
            }
        }
        return "INSERT INTO \(table) (\(keyClause)) VALUES (\(valueClause))"
    }
    
    func getArgs() -> [Any]? {
        args
    }
}
