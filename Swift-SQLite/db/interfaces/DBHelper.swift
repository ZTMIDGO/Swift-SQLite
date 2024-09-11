//
//  DBHelper.swift
//  Swift-SQLite
//
//  Created by ztm on 2024/9/10.
//

import Foundation
protocol DBHelper{
    func delete(_ config: SQL) ->Bool
    func delete(_ configs:[SQL]) ->Bool
    
    func insert(_ config: SQL) ->Bool
    func insert(_ configs: [SQL]) ->Bool
    
    func update(_ config: SQL) ->Bool
    func update(_ configs: [SQL]) ->Bool
    
    func query<T>(_ config: SQL, _ factory: BeanFactory<T>) ->[T]
    func querySighle<T>(_ config: SQL, _ factory: BeanFactory<T>) ->T?
    
    func getItemCount(_ table: String, _ whereClause: String?, _ args:[Any]?) ->Int
    func getItemCount(_ table: String) ->Int
    
    func hasItem(_ table: String, _ whereClause: String?, _ args:[Any]?) ->Bool
    
    func clearTable(_ table: String, _ whereClause: String?, _ args:[Any]?) ->Bool
    func clearTable(_ table: String) ->Bool
    
    func getDatabaseName() ->String
    
    func close()
}
