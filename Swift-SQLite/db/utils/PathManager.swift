//
//  PathManager.swift
//  Swift-SQLite
//
//  Created by ztm on 2024/9/10.
//

import Foundation

struct PathManager{
    static func getDBPath() ->URL{
        let name = "db"
        return FileUtils.getAtPath(name: name)
    }
    
    static func  getCachePath() ->URL{
        return FileUtils.getAtPath(name: "cache")
    }
}
