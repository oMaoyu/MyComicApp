//
//  MyDrawerController.swift
//  MyComicApp
//
//  Created by 高子雄 on 2018/12/24.
//  Copyright © 2018年 oMaoyu. All rights reserved.
//
import UIKit

// 抽屉的显示区域占屏幕宽度的百分比
fileprivate let DrawerWidthScale : CGFloat = 0.7
// 蒙版层最高透明度
fileprivate let CoverMaxAlpha : CGFloat = 0.5
// 屏幕宽
fileprivate let kScreenWidth : CGFloat = UIScreen.main.bounds.size.width

class MyDrawerController: UIViewController, UIGestureRecognizerDelegate {

    var mainVC      : UIViewController?
    var leftVC      : UIViewController?
    var rightVC     : UIViewController?
    var drawerWidth : CGFloat!
    var emptyWidth  : CGFloat!
    var isLeft      = true // 是否可以左滑
    var isRight     = false // 是否可以右滑
    init(mainVC: UIViewController?, leftVC: UIViewController?, rightVC: UIViewController?) {
        super.init(nibName: nil, bundle: nil)
        
        self.mainVC = mainVC
        self.addChild(self.mainVC!)
        self.view.addSubview((self.mainVC?.view)!)
        
        self.leftVC = leftVC
        if (self.leftVC != nil){
            self.addChild(self.leftVC!)
            self.view.insertSubview((self.leftVC?.view)!, at: 0)
        }
        
        
        self.rightVC = rightVC
        if (self.rightVC != nil){
            self.addChild(self.rightVC!)
            self.view.insertSubview((self.rightVC?.view)!, at: 0)
        }
        
        self.drawerWidth = DrawerWidthScale * kScreenWidth
        self.emptyWidth = kScreenWidth - self.drawerWidth
    }
    
    fileprivate var startPoint : CGPoint!
    fileprivate var coverView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
    }
    
    func addSubviews() {
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panView(pan:)))
        pan.delegate = self;
        self.view.addGestureRecognizer(pan)
        
        if coverView == nil {
            
            coverView = UIView.init(frame: self.view.bounds)
            coverView.backgroundColor = UIColor.black
            coverView.alpha = 0
            coverView.isHidden = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapCoverView(tap:)))
            coverView.addGestureRecognizer(tap)
            self.mainVC?.view.addSubview(coverView)
        }
    }
    // MARK: - pan event
    @objc func panView(pan: UIPanGestureRecognizer) {
        
        switch pan.state {
        case UIGestureRecognizer.State.began:
            self.startPoint = self.mainVC?.view.center
            break
        case UIGestureRecognizer.State.changed:
            panChange(pan: pan)
            break
        case UIGestureRecognizer.State.ended:
            if (self.mainVC?.view.frame.minX)! > self.drawerWidth / 2.0 {
                
                showLeftViewController(animated: true)
            } else if (self.mainVC?.view.frame.maxX)! < self.drawerWidth / 2.0 + self.emptyWidth {
                
                showRightViewController(animated: true)
            } else {
                
                showMainViewController(animated: true)
            }
            break
        default:
            break
        }
    }
    func panChange(pan: UIPanGestureRecognizer) {
        
        // 拖拽的距离
        let translation = pan.translation(in: self.view)
        if (!isLeft  && translation.x > 0){
            return
        }
        if (!isRight && translation.x < 0){
            return
        }
        
        // 移动主控制器
        self.mainVC?.view.center = CGPoint.init(x: self.startPoint.x + translation.x, y: self.startPoint.y)
        // 判断是否设置了左右菜单
        if self.rightVC == nil && (self.mainVC?.view.frame.minX)! <= CGFloat(0) {
            
            self.mainVC?.view.frame = self.view.bounds
        }
        if self.leftVC == nil && (self.mainVC?.view.frame.minX)! >= CGFloat(0) {
            
            self.mainVC?.view.frame = self.view.bounds
        }
        
        // 滑动到边缘位置后不可以继续滑动
        if (self.mainVC?.view.frame.minX)! > self.drawerWidth {
            
            self.mainVC?.view.center = CGPoint.init(x: (self.mainVC?.view.bounds.size.width)! / 2.0 + self.drawerWidth, y: (self.mainVC?.view.center.y)!)
        }
        if (self.mainVC?.view.frame.maxX)! < self.emptyWidth {
            
            self.mainVC?.view.center = CGPoint.init(x: (self.mainVC?.view.bounds.size.width)! / 2.0 - self.drawerWidth, y: (self.mainVC?.view.center.y)!)
        }
        
        // 判断显示左菜单还是右菜单
        if (self.mainVC?.view.frame.minX)! > 0.0 {
            
            // 显示左菜单
            self.view.sendSubviewToBack((self.rightVC?.view)!)
            // 更新左菜单位置
            updateLeftVCFrame()
            // 更新蒙版透明度
            self.coverView.isHidden = false
            self.coverView.alpha = CoverMaxAlpha * (self.mainVC?.view.frame.minX)! / self.drawerWidth
        } else if (self.mainVC?.view.frame.minX)! < 0 {
            
            // 显示右菜单
            self.view.sendSubviewToBack((self.leftVC?.view)!)
            // 更新右菜单位置
            updateRightVCFrame()
            // 更新蒙版透明度
            self.coverView.isHidden = false
            self.coverView.alpha = CoverMaxAlpha * (kScreenWidth - (self.mainVC?.view.frame.maxX)!) / self.drawerWidth
        }
        
    }
    // MARK: - tap event
    @objc func tapCoverView(tap: UITapGestureRecognizer) {
        
        showMainViewController(animated: true)
    }
    
    // MARK: - pan delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        // 设置navigation子视图不可拖拽
        if self.mainVC is UINavigationController {
            
            let nav = self.mainVC as! UINavigationController
            if nav.viewControllers.count > 1 && (nav.interactivePopGestureRecognizer?.isEnabled)! {
                
                return false
            }
        }
        // 如果mainVC是tabBarController  设置navigation子视图不可拖拽
        if self.mainVC is UITabBarController {
            
            let tabbar = self.mainVC as! UITabBarController
            let nav = tabbar.selectedViewController as! UINavigationController
            if nav.viewControllers.count > 1 && (nav.interactivePopGestureRecognizer?.isEnabled)! {
                
                return false
            }
        }
        
        // 设置拖拽响应范围
        if gestureRecognizer is UIPanGestureRecognizer {
            
            let actionWidth : CGFloat = self.emptyWidth
            let panPoint = touch.location(in: gestureRecognizer.view)
            if panPoint.x <= actionWidth || panPoint.x > self.view.bounds.size.width - actionWidth {
                
                return true
            } else {
                
                return false
            }
        }
        return true
    }
    
    // MARK: - 设置抽屉弹出收起动画
    func showMainViewController(animated: Bool) {
        
        UIView.animate(withDuration: animationDuration(animated: animated), animations: {
            
            var frame : CGRect? = self.mainVC?.view.frame
            frame?.origin.x = 0
            self.mainVC?.view.frame = frame!
            self.updateLeftVCFrame()
            self.updateRightVCFrame()
            self.coverView.alpha = 0
        }) { (finished) in
            
            self.coverView.isHidden = true
        }
    }
    func showLeftViewController(animated: Bool) {
        
        if self.leftVC == nil {
            
            return
        }
        self.view.sendSubviewToBack((self.rightVC?.view)!)
        self.coverView.isHidden = false
        
        UIView.animate(withDuration: animationDuration(animated: animated), animations: {
            
            self.mainVC?.view.center = CGPoint.init(x: (self.mainVC?.view.bounds.size.width)! / 2.0 + self.drawerWidth, y: (self.mainVC?.view.center.y)!)
            self.leftVC?.view.frame = self.view.bounds
            self.coverView.alpha = CoverMaxAlpha
        })
    }
    func showRightViewController(animated: Bool) {
        
        if self.rightVC == nil {
            
            return
        }
        self.view.sendSubviewToBack((self.leftVC?.view)!)
        self.coverView.isHidden = false
        
        UIView.animate(withDuration: animationDuration(animated: animated), animations: {
            
            self.mainVC?.view.center = CGPoint.init(x: (self.mainVC?.view.bounds.size.width)! / 2.0 - self.drawerWidth, y: (self.mainVC?.view.center.y)!)
            self.rightVC?.view.frame = self.view.bounds
            self.coverView.alpha = CoverMaxAlpha
        })
    }
    
    // MARK: - update leftVC and rightVC frame
    func updateLeftVCFrame() {
        
        self.leftVC?.view.center = CGPoint.init(x: ((self.mainVC?.view.frame.minX)! + self.emptyWidth) / 2, y: (self.leftVC?.view.center.y)!)
    }
    func updateRightVCFrame() {
        
        self.rightVC?.view.center = CGPoint.init(x: (self.view.bounds.width + (self.mainVC?.view.frame.maxX)! - self.emptyWidth) / 2, y: (self.rightVC?.view.center.y)!)
    }
    
    // MARK: - private
    // 动画时长
    func animationDuration(animated: Bool) -> TimeInterval {
        
        return animated ? 0.25 : 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

