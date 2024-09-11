//
//  UserSchema.swift
//  Swift-SQLite
//
//  Created by ztm on 2024/9/10.
//

import Foundation
struct UserSchema{
    static let NAME = "user"
    struct Cols{
        static let UID = "uid"
        static let NAME = "name"
        static let AGE = "age"
        static let SEX = "sex"
        
        static let ARRAY:[String] = [
            "\(UID) \(SQLType.TEXT) NOT NULL",
            "\(NAME) \(SQLType.TEXT) NOT NULL",
            "\(AGE) \(SQLType.INTEGER) DEFAULT 0 NOT NULL",
            "\(SEX) \(SQLType.TEXT) NOT NULL",
        ]
    }
}
