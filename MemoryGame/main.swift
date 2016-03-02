//
//  main.swift
//  MemoryGame
//
//  Created by qingtian on 16/1/9.
//  Copyright © 2016年 qingtian. All rights reserved.
//

import Foundation
import UIKit

class QtApplication: UIApplication {
    override func sendEvent(event: UIEvent) {
        super.sendEvent(event)
//        print("Event sent: \(event)")
    }
}


/**
    在top-level定义了`UIApplicationMain`后，在`AppDelegate`中就不用`@UIApplicationMain`了
*/
UIApplicationMain(
    Process.argc,
    Process.unsafeArgv,
    NSStringFromClass(QtApplication),
    NSStringFromClass(AppDelegate))