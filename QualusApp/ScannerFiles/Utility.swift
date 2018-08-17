//
//  Utility.swift
//  AVScanner_Example
//
//  Created by Liang, KaiChih on 28/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

func printLog(_ message: Any..., file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}

