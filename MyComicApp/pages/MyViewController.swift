//
//  MyViewController.swift
//  MyComicApp
//
//  Created by 高子雄 on 2018/12/12.
//  Copyright © 2018年 oMaoyu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ZHRefresh
import RealmSwift
import PKHUD

class MyViewController: UIViewController {
    class func aaa(){
        
    }
    
    private static let instance:MyViewController  = MyViewController()
    //单例
    class func shared()->MyViewController{
        return  instance
    }
    let bag = DisposeBag()
    
    let app = MyGeneralObject.shared()
    
    var table: MyMainTableView!
    
    var user:AppUser?
    
    var modes:Results<comicModel>!
    
    var cellHeights:[CGFloat]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
//        用户设置  后面重新包装
        user = .cn
        UIinitializeThe()
        accordingToTitle()
//        operationButton()
        operationTable()
        operationButton()
   
        
        
    }
    // MARK: - 数据初始化
    func dataInitializeThe()  {
        modes = app.userModes(user ?? .cn)
//        isTimeStamp(2) ||  如果时间为两天以上开始新的缓存  目前有问题，暂且隐去
        if  modes.count == 0{
            app.userSet(.cn)
        }
    }
    // MARK: - ui初始化
    func UIinitializeThe(){
        dataInitializeThe()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "∞", style: .done, target: nil, action: nil);
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_tabbar_me_pressed_30x30_").withRenderingMode(.alwaysOriginal), style: .done, target: nil, action: nil)
        table = MyMainTableView(frame: CGRect(x: 0, y: navH, width: www, height: hhh-navH-tabH), style: .plain)
        table.register(UINib(nibName:"MyFoldingCell", bundle: nil), forCellReuseIdentifier: "MyFoldingCell")
        table.footer = ZHRefreshBackFooter.footerWithRefreshing {[weak self] in
            guard let `self` = self else { return }
            self.toGetTheData((self.modes.last?.page) ?? -1)
        }
        view.addSubview(table)
    }
    // MARK: - 显示配置
    func accordingToTitle(){
        cellHeights = (0..<modes.count).map { _ in C.CellHeight.close }
//       动态创建cell高度数组
        Observable.collection(from: modes)
            .map{ _ -> CGFloat in
                return C.CellHeight.close}
            .subscribe{[weak self] close in
                guard let `self` = self else { return }
                if self.cellHeights?.count == self.modes.count { return }
                self.cellHeights?.append(close.element ?? C.CellHeight.close)
            }.disposed(by:bag)
        
//        显示漫画数量
        Observable.collection(from: modes)
            .map { results -> String  in
                return results.count > 750 ? "鸡儿要紧，保重身体" : "当前加载\(results.count)本漫画"
            }
            .subscribe {[weak self]  event in
                guard let `self` = self else { return }
                self.navigationItem.title = event.element
                self.view.backgroundColor = .white
            }
            .disposed(by: bag)
    }
    // MARK: - barbutton点击事件
    func operationButton(){
//          (UIApplication.shared.delegate as! AppDelegate).drawerController?.showLeftViewController(animated: true)
        navigationItem.rightBarButtonItem?.rx.tap.bind { [weak self] in
            HUD.flash(.label("为了看最新的代码\(self?.modes.count ?? 0)本本子的献祭不是没有用处！误点了那就不好意思了。"), delay: 8.0)
            guard let `self` = self else { return }
            try! realm.write {
                realm.delete(self.modes)
            }
            self.app.userSet(.cn)
        }.disposed(by: bag)
    }
    // MARK: - table 的rx一系列绑定用法
    func operationTable(){
//        绑定数据源
        let dataSource = RxTableViewRealmDataSource<comicModel>(cellIdentifier: "MyFoldingCell", cellType: MyFoldingCell.self.self){[weak self] cell, ip, mode in
            guard let `self` = self else { return }
            let durations: [TimeInterval] = [0.26, 0.2, 0.2]
            cell.durationsForExpandedState = durations
            cell.durationsForCollapsedState = durations
            cell.model = mode
            cell.ydButton.rx.tap.asDriver().drive(onNext: { [weak self] in
                guard let `self` = self else { return }
                let vc = MyImageVC.initModels(modelArray: mode.imgs)
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: cell.bag)
            cell.scBtutton.rx.tap.bind{
                if !cell.sc(true) {
                    HUD.flash(.label("正在回收，请不要重复操作"), delay: 1.0)
                    cell.scBtutton.setImgName("bjImage","腾出手来")
                }else{
                    cell.scBtutton.setImgName("bjImageb","回收废纸")
                    self.app.SCModel(mode)
                }
                }.disposed(by: cell.bag)
        }
        Observable.changeset(from: modes)
            .share()
            .bind(to: table.rx.realmChanges(dataSource))
            .disposed(by: bag)
//        设置代理  代理用来设置cell高度
        table.rx.setDelegate(self)
            .disposed(by: bag)
    }
    
//    用户进入该页面 直接从第一页开始拉取，存入后获取最后一次加载页
    func toGetTheData(_ page:NSInteger){
        let i = page + 1
        app.comicList(((i == 0) ? "":"\(i)"), user ?? .cn)
        Observable.of(1)
        .delay(10, scheduler: MainScheduler.instance)//yanshi
            .subscribe {[weak self]  event in
                guard let `self` = self else { return }
                self.table.footer?.endRefreshing()
        }.disposed(by: bag)
    }
}
//tableView代理实现
extension MyViewController : UITableViewDelegate {
    //设置单元格高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
        -> CGFloat {
            return cellHeights?[indexPath.row] ?? C.CellHeight.close
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard  let cell:MyFoldingCell = tableView.cellForRow(at: indexPath) as? MyFoldingCell else {
            return
        }
        var duration = 0.0
        if cellHeights?[indexPath.row] == C.CellHeight.close {
            cellHeights?[indexPath.row] = C.CellHeight.open
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights?[indexPath.row] = C.CellHeight.close
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
//        CurveEaseOut
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell:MyFoldingCell = tableView.cellForRow(at: indexPath) as? MyFoldingCell {
            if cellHeights![indexPath.row] == C.CellHeight.close {
                cell.unfold(false, animated: false, completion: nil)
            } else {
                cell.unfold(true, animated: false, completion: nil)
            }
        }
    }
    
}

extension MyViewController {
    struct C {
        struct CellHeight {
            static let close: CGFloat = 170 // equal or greater foregroundView height
            static let open: CGFloat = 330 // equal or greater containerView height
        }
    }
    //    对比时间戳  如果大于 N天  就进行调用
    func isTimeStamp(_ end : NSInteger) -> Bool {
        // 获取当前时间戳
        let date1 = Date(timeIntervalSince1970: TimeInterval(Date().timeStamp)!)
        // 获取本地时间戳
        let date2 = app.UnArchiverAnObjectWithFileName("isDate") as! String
        //对比时间戳
        if end <= Date(timeIntervalSince1970: TimeInterval(date2)!).daysBetweenDate(toDate: date1){
            return true
        }
        return false
    }
}

