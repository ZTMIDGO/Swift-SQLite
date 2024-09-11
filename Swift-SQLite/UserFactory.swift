//
//  UserFactory.swift
//  Swift-SQLite
//
//  Created by ztm on 2024/9/10.
//

import Foundation
class UserFactory: BeanFactory<User>{
    override func create(cursor: Cursor) -> User? {
        let uid = cursor.getString(UserSchema.Cols.UID)
        let name = cursor.getString(UserSchema.Cols.NAME)
        let age = cursor.getInt(UserSchema.Cols.AGE)
        let sex = cursor.getString(UserSchema.Cols.SEX)
        return User(uid:uid, name: name, age: age, sex: sex)
    }
}
