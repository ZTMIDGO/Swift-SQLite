//
//  SQLiteOpenHelper.swift
//  Swift-SQLite
//
//  Created by ztm on 2024/9/10.
//

import Foundation
import SQLite3

public extension OpaquePointer{
    var userVersion: Int{
        get { DBUtils.getUserVersion(db: self, def: -1) }
        set(version) { DBUtils.setUserVersion(db: self, version: version) }
    }
}

public class SQLiteOpenHelper: DBHelper{
    func delete(_ config: any SQL) -> Bool {
        SQLiteOpenHelper.lock.lock()
        let success = DBUtils.delete(db: db!, sql: config.getSQL(), args: config.getArgs())
        SQLiteOpenHelper.lock.unlock()
        return success
    }
    
    func delete(_ configs: [any SQL]) -> Bool {
        for config in configs{
            delete(config)
        }
        return true
    }
    
    func insert(_ config: any SQL) -> Bool {
        SQLiteOpenHelper.lock.lock()
        let success = DBUtils.insert(db: db!, sql: config.getSQL(), args: config.getArgs())
        SQLiteOpenHelper.lock.unlock()
        return success
    }
    
    func insert(_ configs: [any SQL]) -> Bool {
        for config in configs{
            insert(config)
        }
        return true
    }
    
    func update(_ config: any SQL) -> Bool {
        SQLiteOpenHelper.lock.lock()
        let success = DBUtils.update(db: db!, sql: config.getSQL(), args: config.getArgs())
        SQLiteOpenHelper.lock.unlock()
        return success
    }
    
    func update(_ configs: [any SQL]) -> Bool {
        for config in configs{
            update(config)
        }
        return true
    }
    
    func query<T>(_ config: any SQL, _ factory: BeanFactory<T>) -> [T] {
        SQLiteOpenHelper.lock.lock()
        var list:[T] = []
        let statement = DBUtils.query(db: db!, sql: config.getSQL(), args: config.getArgs())
        
        if statement == nil{
            return list
        }
        
        var columns:[String]? = nil
        while sqlite3_step(statement) == SQLITE_ROW{
            if columns == nil{
                columns = DBUtils.getColumns(db: statement!)
            }
            list.append(factory.create(cursor: Cursor(db: statement!, columns: columns!))!)
        }
        sqlite3_finalize(statement)
        SQLiteOpenHelper.lock.unlock()
        return list
    }
    
    func querySighle<T>(_ config: any SQL, _ factory: BeanFactory<T>) -> T? {
        let list:[T] = query(config, factory)
        return list.isEmpty ? nil : list[0]
    }
    
    func getItemCount(_ table: String, _ whereClause: String?, _ args: [Any]?) -> Int {
        SQLiteOpenHelper.lock.lock()
        var count:Int = 0
        let sql:String = SQLUtils.selectSQL(table, ["COUNT(*)"], whereClause, nil, "0,1")!
        let statement = DBUtils.query(db: db!, sql: sql, args: args)
        
        if statement == nil{
            return count
        }
        
        while sqlite3_step(statement) == SQLITE_ROW{
            count = Int(sqlite3_column_int(statement, 0))
        }
        sqlite3_finalize(statement)
        SQLiteOpenHelper.lock.unlock()
        return count
    }
    
    func getItemCount(_ table: String) -> Int {
        return getItemCount(table, nil, nil)
    }
    
    func hasItem(_ table: String, _ whereClause: String?, _ args: [Any]?) -> Bool {
        getItemCount(table, whereClause, args) != 0
    }
    
    func clearTable(_ table: String, _ whereClause: String?, _ args: [Any]?) ->Bool{
        SQLiteOpenHelper.lock.lock()
        let what:String = StringUtils.isEmpty(whereClause) ? "" : " WHERE \(whereClause!)"
        let success = DBUtils.delete(db: db!, sql: "DELETE FROM \(table)\(what)", args: args)
        SQLiteOpenHelper.lock.unlock()
        return success
    }
    
    func clearTable(_ table: String) ->Bool{
        clearTable(table, nil, nil)
    }
    
    func getDatabaseName() -> String {
        name
    }
    
    func close() {
        sqlite3_close(db)
    }
    
    private static let rootPath:URL = PathManager.getDBPath()
    private static let lock = NSLock()
    
    private let minimumSupportedVersion = 0
    private let version:Int
    
    let autoincrementKey = "_id \(SQLType.INTEGER) primary key autoincrement"
    let name:String
    
    var db: OpaquePointer?
    private var isTransaction:Bool = false
    private var isTransactionSuccessful = false
    
    init(name: String, version: Int) {
        self.name = name
        self.version = version
        
        sqlite3_open(FileUtils.toPath(at: SQLiteOpenHelper.rootPath.appending(path: name)), &db)
        checkVersion()
    }
    
    func onCreate() throws{}
    
    func onUpgrade(oldVersion:Int, newVersion:Int) throws {}
    
    func beginTransaction() ->Bool{
        if isTransaction {
            return false
        }
        isTransaction = sqlite3_exec(db, "BEGIN EXCLUSIVE", nil, nil, nil) == SQLITE_OK
        isTransactionSuccessful = false
        return isTransaction
    }
    
    func setTransactionSuccessful(){
        isTransactionSuccessful = true
    }
    
    func endTransaction(){
        if !isTransaction {
            return
        }
        
        if isTransactionSuccessful && isTransaction {
            sqlite3_exec(db, "COMMIT", nil, nil, nil)
        }else{
            sqlite3_exec(db, "ROLLBACK", nil, nil, nil)
        }
        
        isTransactionSuccessful = false
        isTransaction = false
    }
    
    private func checkVersion(){
        let oldVersion:Int = db!.userVersion
        if oldVersion != version{
            if oldVersion > 0 && oldVersion < minimumSupportedVersion{
                SQLiteOpenHelper.deleteDatabase(name)
            }else{
                do{
                    if beginTransaction(){
                        if oldVersion == 0{
                            try onCreate()
                        }else if oldVersion < version{
                            try onUpgrade(oldVersion: oldVersion, newVersion: version)
                        }
                        
                        db?.userVersion = version
                        setTransactionSuccessful()
                        endTransaction()
                    }
                }catch{
                    endTransaction()
                }
            }
        }
    }
    
    public static func deleteDatabase(_ dbName:String) ->Bool{
        var success = false
        do{
            try FileManager.default.removeItem(at: rootPath.appending(path: dbName))
            success = true
        }catch{}
        return success
    }
}
