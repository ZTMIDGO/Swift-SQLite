//
//  SQLQuery.swift
//  Swift-SQLite
//
//  Created by ztm on 2024/9/10.
//

import Foundation

public struct SQLQuery: SQL{
    let sql:String
    let args:[Any]?
    
    init(_ sql:String, _ args:[Any]?){
        self.sql = sql
        self.args = args
    }
    
    init(_ table: String, _ columns: [String]?, _ whereClause: String?, _ limit: String?, _ sort: String?, _ args: [Any]?) {
        sql = SQLUtils.selectSQL(table, columns, whereClause, sort, limit)!
        self.args = args
    }
    
    func getSQL() -> String {
        sql
    }
    
    func getArgs() -> [Any]? {
        args
    }
}
