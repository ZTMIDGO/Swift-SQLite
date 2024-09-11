//
//  SQLUtils.swift
//  Swift-SQLite
//
//  Created by ztm on 2024/9/10.
//

import Foundation

struct SQLUtils{
    private static let CONFLICT_VALUES = ["", " OR ROLLBACK ", " OR ABORT ", " OR FAIL ", " OR IGNORE ", " OR REPLACE "]
    
    static func tableSQL(_ table: String, _ key: String, _ cols: [String]) ->String{
        var sql: String = "CREATE TABLE \(table) (\(key),"
        for index in 0...cols.count-1{
            sql.append("\(cols[index])")
            if index < cols.count-1{
                sql.append(",")
            }
        }
        sql.append(")")
        return sql
    }
    
    static func selectSQL(_ tables:String, _ columns:[String]?, _ whereClause:String?, _ orderBy:String?, _ limit:String?) ->String?{
        selectSQL(false, tables, columns, whereClause, nil, nil, orderBy, limit)
    }
    
    static func selectSQL(_ distinct: Bool, _ tables: String, _ columns: [String]?, _ whereClause: String?, _ groupBy:String?, _ having:String?, _ orderBy:String?, _ limit: String?) ->String?{
        if StringUtils.isEmpty(groupBy) && !StringUtils.isEmpty(having){
            return nil
        }
        
        var sql: String = ""
        sql.append("SELECT ")
        if distinct{
            sql.append("DISTINCT ")
        }
        if columns != nil && columns?.count != 0{
            sql.append(appendColumns(columns: columns!))
        }else{
            sql.append("* ")
        }
        sql.append("FROM \(tables) ")
        sql.append(appendClause(name: "WHERE ", clause: whereClause))
        sql.append(appendClause(name: "GROUP BY ", clause: groupBy))
        sql.append(appendClause(name: "HAVING ", clause: having))
        sql.append(appendClause(name: "ORDER BY ", clause: orderBy))
        sql.append(appendClause(name: "LIMIT ", clause: limit))
        return sql
    }
    
    static func appendClause(name: String, clause: String?) ->String{
        var result:String = ""
        if !StringUtils.isEmpty(clause){
            result.append(name)
            result.append(clause!)
        }
        return result
    }
    
    static func appendColumns(columns:[String]) ->String{
        var result:String = ""
        for i in 0...columns.count-1{
            let column:String? = columns[i]
            if column != nil{
                if i > 0{
                    result.append(", ")
                }
                result.append(column!)
            }
        }
        result.append(" ")
        return result
    }
    
    static func linkKeys(map: [String:Any], symbol: String) ->(String, [Any]){
        var args:[Any] = []
        var result:String = ""
        var index = 0
        for (key, value) in map{
            result.append(key)
            result.append("=?")
            args.append(value)
            if index < map.count-1{
                result.append(" \(symbol) ")
            }
            index += 1
        }
        return (result, args)
    }
}
