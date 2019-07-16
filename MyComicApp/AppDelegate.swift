//
//  AppDelegate.swift
//  MyComicApp
//
//  Created by 高子雄 on 2018/12/11.
//  Copyright © 2018年 oMaoyu. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawerController : MyDrawerController?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame:UIScreen.main.bounds)
        
        // 主页面
        let main = MyMainTabBarController.shared()
        window?.rootViewController = main
        window?.makeKeyAndVisible()
        return true
    }
    
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        /* Realm 数据库配置，用于数据库的迭代更新 */
        let schemaVersion: UInt64 = 0
        let config = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: { migration, oldSchemaVersion in
            /* 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构 */
            if (oldSchemaVersion < schemaVersion) {}
        })
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen { (realm, error) in
            
            /* Realm 成功打开，迁移已在后台线程中完成 */
            if let _ = realm {
                print("Realm 数据库配置成功")
            }
                /* 处理打开 Realm 时所发生的错误 */
            else if let error = error {
                print("Realm 数据库配置失败：\(error.localizedDescription)")
            }
        }
    }


}

