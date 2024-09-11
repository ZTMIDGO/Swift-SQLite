//
//  Cursor.swift
//  Swift-SQLite
//
//  Created by ztm on 2024/9/10.
//

import Foundation
import SQLite3

class Cursor{
    private let db:OpaquePointer
    let columns:[String]
    init(db: OpaquePointer, columns: [String]) {
        self.db = db
        self.columns = columns
    }
    
    func getInt(_ columnName: String) ->Int{
        Int(sqlite3_column_int(db, Int32(columns.firstIndex(of: columnName)!)))
    }
    
    func getFloat(_ columnName: String) ->CGFloat{
        CGFloat(sqlite3_column_double(db, Int32(columns.firstIndex(of: columnName)!)))
    }
    
    func getString(_ columnName: String) ->String{
        String(describing: String(cString: sqlite3_column_text(db, Int32(columns.firstIndex(of: columnName)!))))
    }
}
