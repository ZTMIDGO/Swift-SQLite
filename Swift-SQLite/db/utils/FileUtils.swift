//
//  FileUtils.swift
//  Swift-SQLite
//
//  Created by ztm on 2024/9/10.
//

import Foundation
import UIKit
import SwiftUI

struct FileUtils{
    private static let MANAGER = FileManager.default
    
    static func getManager() ->FileManager{
        MANAGER
    }
    
    static func getFileRoot() ->URL{
        let document = getManager().urls(for: .documentDirectory, in:.userDomainMask)
        let url = document[0] as URL
        return url
    }
    
    static func getAtPath(name:String) ->URL{
        let path = appending(at: getFileRoot(), name: name)
        if !fileExists(atPath: toPath(at: path)){
            createDirectory(at: path)
        }
        return path
    }
    
    static func toPath(at:URL) ->String{
        at.path()
    }
    
    static func write(at:URL, image:UIImage) ->Bool{
        write(at: at, data: image.jpegData(compressionQuality: 1.0)!)
    }
    
    static func write(at:URL, data:Data) ->Bool{
        getManager().createFile(atPath: toPath(at: at), contents: data, attributes: nil)
    }
    
    static func read(at:URL) ->Data?{
        var result:Data?
        do{
            result = try Data.init(contentsOf: at)
        }catch{
            print(error)
        }
        return result
    }
    
    static func appending(at:URL, name:String) ->URL{
        at.appendingPathComponent(name, conformingTo: .fileURL)
    }
    
    static func createDirectory(at:URL) ->Bool{
        var success:Bool = false
        do{
            try getManager().createDirectory(at: at, withIntermediateDirectories: true, attributes: nil)
        }catch{
            success = false
        }
        return success
    }
    
    static func fileExists(atPath:String) ->Bool{
        getManager().fileExists(atPath: atPath)
    }
}
