//
//  SQLUpdate.swift
//  Swift-SQLite
//
//  Created by ztm on 2024/9/10.
//

import Foundation
public struct SQLUpdate: SQL{
    let table:String
    let updateClause:String
    let whereClause:String?
    var args:[Any]?
    
    init(_ table: String, _ values: [String:Any], _ whereClause: String?, _ args: [Any]?) {
        self.args = []
        self.table = table
        self.whereClause = whereClause
        let keys = SQLUtils.linkKeys(map: values, symbol: ",")
        self.updateClause = keys.0
        self.args?.append(contentsOf: keys.1)
        if args != nil { self.args?.append(contentsOf: args!) }
    }
    
    init(_ table: String, _ updateClause: String, _ whereClause: String?, _ args: [Any]?) {
        self.table = table
        self.updateClause = updateClause
        self.whereClause = whereClause
        self.args = args
    }
    
    func getSQL() -> String {
        let what:String = StringUtils.isEmpty(whereClause) ? "" : " WHERE \(whereClause!)"
        return "UPDATE \(table) SET \(updateClause)\(what)"
    }
    
    func getArgs() -> [Any]? {
        args
    }
}
