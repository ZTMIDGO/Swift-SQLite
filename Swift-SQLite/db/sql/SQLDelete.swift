//
//  SQLDelete.swift
//  Swift-SQLite
//
//  Created by ztm on 2024/9/10.
//

import Foundation

public struct SQLDelete: SQL{
    let table:String
    let whereClause:String?
    let args:[Any]?
    
    init(_ table: String, _ whereClause: String?, _ args: [Any]?) {
        self.table = table
        self.whereClause = whereClause
        self.args = args
    }
    
    func getSQL() -> String {
        let what:String = StringUtils.isEmpty(whereClause) ? "" : " WHERE \(whereClause!)"
        return "DELETE FROM \(table)\(what)"
    }
    
    func getArgs() -> [Any]? {
        args!
    }
}

