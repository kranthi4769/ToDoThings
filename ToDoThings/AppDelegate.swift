//
//  AppDelegate.swift
//  ToDoThings
//
//  Created by User on 28/05/18.
//  Copyright © 2018 Kranthikiran. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
// test commit
    ////////
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
       // print(Realm.Configuration.defaultConfiguration.fileURL)
        do{
         _ = try Realm()
        }catch{
            print("Error in intialisizing the new realm \(error)")
        }
         return true
    }
    
}
