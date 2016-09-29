//
//  AppDelegate.swift
//  AsstisTouch2
//
//  Created by DKJone on 16/9/28.
//  Copyright © 2016年 南京麦伦思. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var assistiveTouch: AssistiveTouch!
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.performSelector(#selector(showDeBugExt), withObject: nil, afterDelay: 3)
        
        return true
    }
    

}

