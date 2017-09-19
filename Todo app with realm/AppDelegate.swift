//
//  AppDelegate.swift
//  Todo app with realm
//
//  Created by samet sahin on 18.09.2017.
//  Copyright © 2017 samet sahin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        helper().AppFinishLoading()
        
        UISearchBar.appearance().barTintColor = .white
        UISearchBar.appearance().tintColor = .black
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
        // Override point for customization after application launch.
        return true
    }

  


}

