
//
//  AppDelegate.swift
//  ToDoey
//
//  Created by Pankaj Sharma on 6/24/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit

import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     //   print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        do {
            _ = try Realm()
            
        } catch {
            print("Error from realm: \(error)")
        }
        
        // Override point for customization after application launch.
        return true
    }
    



}

