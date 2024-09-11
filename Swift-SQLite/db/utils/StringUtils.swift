//
//  StringUtils.swift
//  Swift-SQLite
//
//  Created by ztm on 2024/9/10.
//

import Foundation
struct StringUtils{
    static func isEmpty(_ text: String?) ->Bool{
        return text == nil || text!.isEmpty
    }
}
