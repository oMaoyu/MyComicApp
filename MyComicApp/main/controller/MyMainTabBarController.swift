//
//  MyMainTabBarController.swift
//  MyComicApp
//
//  Created by 高子雄 on 2018/12/29.
//  Copyright © 2018年 oMaoyu. All rights reserved.
//

import UIKit
class MyMainTabBarController: UITabBarController {
    private static let instance:MyMainTabBarController  = MyMainTabBarController()
    //单例
    class func shared()->MyMainTabBarController{
        return  instance
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewControllers()
        UITabBar.appearance().tintColor = UIColor.black
        
    }
    // MARK: - 添加子控制器
    func addChildViewControllers() {
        setupOneChildViewController(title: "私人漫画手册",tabBarItem:"绅士一刻", image: "ic_tabbar_discover_normal_30x30_", selectedImage: "ic_tabbar_discover_pressed_30x30_", controller: MyViewController.shared(),color: UIColor.white)
        setupOneChildViewController(title: "学习资料",tabBarItem:"朕的书房", image: "ic_tabbar_me_normal_30x30_", selectedImage: "ic_tabbar_me_pressed_30x30_", controller: MyLikeVc.shared(),color: UIColor.white)
//        setupOneChildViewController(title: "私人漫画手册",tabBarItem:"更新站台", image: "ic_tabbar_media_normal_30x30_", selectedImage: "ic_tabbar_media_pressed_30x30_", controller: MyNewGateVc.shared(),color: UIColor.white)
    }
    
    func setupOneChildViewController(title: String ,tabBarItem:String, image: String, selectedImage:String ,controller:UIViewController,color:UIColor){
        controller.tabBarItem.title = tabBarItem
        controller.navigationItem.title = title
        controller.view.backgroundColor = color
        controller.tabBarItem.image = UIImage(named:image)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        controller.tabBarItem.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let navController = MyNavigationController(rootViewController: controller)
        addChild(navController)
    }
    
}
