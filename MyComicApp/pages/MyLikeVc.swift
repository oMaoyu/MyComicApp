//
//  MyLeftViewController.swift
//  MyComicApp
//
//  Created by 高子雄 on 2018/12/24.
//  Copyright © 2018年 oMaoyu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RealmSwift
import PKHUD

class MyLikeVc: UIViewController {
    private static let instance:MyLikeVc  = MyLikeVc()
    //单例
    class func shared()->MyLikeVc{
        return  instance
    }
    let bag = DisposeBag()
    
    let app = MyGeneralObject.shared()
    
    var table: MyMainTableView!
    
    var modes:Results<scModel>!

    var cellHeights:[CGFloat]?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false

        UIinitializeThe()
        accordingToTitle()
        operationTable()
    }
    // MARK: - ui初始化
    func UIinitializeThe(){
        modes = app.scModes()
        table = MyMainTableView(frame: CGRect(x: 0, y: navH, width: www, height: hhh-navH-tabH), style: .plain)
        table.register(UINib(nibName:"MyFoldingCell", bundle: nil), forCellReuseIdentifier: "MyFoldingCell")
        
        view.addSubview(table)
    }
    // MARK: - 显示配置
    func accordingToTitle(){
        cellHeights = (0..<modes.count).map { _ in C.CellHeight.close }
        //       动态创建cell高度数组
        Observable.collection(from: modes)
            .map{ _ -> CGFloat in return C.CellHeight.close}
            .subscribe{[weak self] close in
                guard let `self` = self else { return }
                if self.cellHeights?.count == self.modes.count { return }
                self.cellHeights?.append(close.element ?? C.CellHeight.close)
            }.disposed(by:bag)
        
        //        显示漫画数量
        Observable.collection(from: modes)
            .map { results -> String  in
                return  "已收藏\(results.count)本漫画"
            }
            .subscribe {[weak self]  event in
                guard let `self` = self else { return }
                self.navigationItem.title = event.element
                self.view.backgroundColor = .white
            }
            .disposed(by: bag)
    }
    
    func operationTable(){
        //        绑定数据源
        let dataSource = RxTableViewRealmDataSource<scModel>(cellIdentifier: "MyFoldingCell", cellType: MyFoldingCell.self.self){[weak self] cell, ip, mode in
            guard let `self` = self else { return }
            let durations: [TimeInterval] = [0.26, 0.2, 0.2]
            cell.durationsForExpandedState = durations
            cell.durationsForCollapsedState = durations
            cell.mode = mode
            cell.ydButton.rx.tap.asDriver().drive(onNext: { [weak self] in
                guard let `self` = self else { return }
                let vc = MyImageVC.initModels(modelArray: mode.imgs)
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: cell.bag)
            cell.scBtutton.rx.tap.bind{
                HUD.flash(.label("正在回收，请不要重复操作"), delay: 1.0)
                MyGeneralObject.shared().deleteSCModel(mode)
                self.cellHeights?.remove(at: ip.item)
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
    
}

//tableView代理实现
extension MyLikeVc : UITableViewDelegate {
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
extension MyLikeVc {
    struct C {
        struct CellHeight {
            static let close: CGFloat = 170 // equal or greater foregroundView height
            static let open: CGFloat = 330 // equal or greater containerView height
        }
    }
}

