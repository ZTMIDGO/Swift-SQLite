//
//  User.swift
//  Swift-SQLite
//
//  Created by ztm on 2024/9/10.
//

import Foundation
struct User:Identifiable, Equatable{
    var id = UUID()
    var uid = UUID().uuidString
    var name:String = "-"
    var age:Int = 0
    var sex:String = "-"
}
