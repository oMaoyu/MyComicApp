//
//  MyImageVC.swift
//  MyComicApp
//
//  Created by 高子雄 on 2018/12/28.
//  Copyright © 2018年 oMaoyu. All rights reserved.
//

import UIKit
import RealmSwift
import JXPhotoBrowser

class MyImageVC: UICollectionViewController {
    
    /// 数据源
    var modelArray: List<imgs>!
    
    /// 名称
    var name: String {
        return "详情页"
    }
    
    let reusedId = "reused"
    
    private var flowLayout: UICollectionViewFlowLayout
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        self.flowLayout = flowLayout
        super.init(collectionViewLayout: flowLayout)
    }

    class func initModels(modelArray: List<imgs>)->MyImageVC{
        let vc = MyImageVC()
        vc.modelArray = modelArray
        return vc
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = name
        collectionView?.backgroundColor = .white
        collectionView?.jx.registerCell(MyImageCell.self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let insetValue: CGFloat = 30
        let totalWidth: CGFloat = view.bounds.width - insetValue * 2
        let colCount = 3
        let spacing: CGFloat = 10.0
        let sideLength: CGFloat = (totalWidth - 2 * spacing) / CGFloat(colCount)
        
        flowLayout.minimumLineSpacing = spacing
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.itemSize = CGSize(width: sideLength, height: sideLength)
        flowLayout.sectionInset = UIEdgeInsets.init(top: insetValue, left: insetValue, bottom: insetValue, right: insetValue)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        openPhotoBrowser(with: collectionView, indexPath: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.jx.dequeueReusableCell(MyImageCell.self, for: indexPath)
        // 加载一级资源
        if let firstLevel = self.modelArray[indexPath.item].imgUrl {
            let url = URL(string: firstLevel)
            cell.imageView.kf.setImage(with: url)
        } else {
            cell.imageView.kf.setImage(with: nil)
        }
        return cell
    }
    
    func openPhotoBrowser(with collectionView: UICollectionView, indexPath: IndexPath) {
        // 网图加载器
        let loader = JXKingfisherLoader()
        // 数据源
        let dataSource = JXRawImageDataSource(photoLoader: loader, numberOfItems: { () -> Int in
            return self.modelArray.count
        }, placeholder: { index -> UIImage? in
            let cell = collectionView.cellForItem(at: indexPath) as? MyImageCell
            return cell?.imageView.image
        }, autoloadURLString: { index -> String? in
            return self.modelArray[index].imgUrl
        }) { index -> String? in
            return self.modelArray[index].imgUrl
        }
        // 视图代理，实现了数字型页码指示器
        let delegate = JXNumberPageControlDelegate()
        // 转场动画
        let trans = JXPhotoBrowserZoomTransitioning { (browser, index, view) -> UIView? in
            let indexPath = IndexPath(item: index, section: 0)
            return collectionView.cellForItem(at: indexPath)
        }
        // 打开浏览器
        JXPhotoBrowser(dataSource: dataSource, delegate: delegate, transDelegate: trans)
            .show(pageIndex: indexPath.item)
    }
}
