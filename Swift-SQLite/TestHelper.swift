//
//  TestHelper.swift
//  Swift-SQLite
//
//  Created by ztm on 2024/9/10.
//

import Foundation
class TestHelper: SQLiteOpenHelper{
    static let INSTANCE = TestHelper()
    
    private static let name = "test.db"
    private static let version = 1
    
    init() {
        super.init(name: TestHelper.name, version: TestHelper.version)
    }
    
    override func onCreate() throws {
        DBUtils.createTable(db!, SQLUtils.tableSQL(UserSchema.NAME, autoincrementKey, UserSchema.Cols.ARRAY))
    }
    
    override func onUpgrade(oldVersion: Int, newVersion: Int) throws {
        
    }
}
