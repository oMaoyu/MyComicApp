//
//  MyMainController.swift
//  securities
//
//  Created by 高子雄 on 2018/12/7.
//  Copyright © 2018年 oMaoyu. All rights reserved.
//

import UIKit

class MyMainController: UITabBarController {
    private static let instance:MyMainController  = MyMainController()
    //单例
    class func shared()->MyMainController{
        return  instance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
