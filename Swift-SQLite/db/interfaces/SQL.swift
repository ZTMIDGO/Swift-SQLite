//
//  SQL.swift
//  Swift-SQLite
//
//  Created by ztm on 2024/9/10.
//

import Foundation
protocol SQL{
    func getSQL() ->String
    func getArgs() ->[Any]?
}
