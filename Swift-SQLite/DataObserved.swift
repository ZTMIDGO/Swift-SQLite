//
//  StoryObserved.swift
//  AppDemo
//
//  Created by ztm on 2024/7/30.
//

import SwiftUI

class DataObserved<T>: ObservableObject {
    @Published var data: T
    
    init(data: T) {
        self.data = data
    }
}
