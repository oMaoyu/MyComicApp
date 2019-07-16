//
//  MyFoldingCell.swift
//  MyComicApp
//
//  Created by 高子雄 on 2018/12/25.
//  Copyright © 2018年 oMaoyu. All rights reserved.
//

import UIKit
import FoldingCell
import Kingfisher
import RxSwift
import RxCocoa



class MyFoldingCell: FoldingCell {
    
    @IBOutlet weak var coverImg: UIImageView!
    
    lazy var containerImg: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "jz"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var containerImg1: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "jz"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    @IBOutlet weak var numText: UILabel!
    
    @IBOutlet weak var titleFolding: UILabel!
    
    @IBOutlet weak var scBtutton: UIButton!
    
    @IBOutlet weak var ydButton: UIButton!
    
//    let sub = PublishSubject<(String,UIImage)>()
    
    var bag = DisposeBag()
    //单元格重用时调用
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    var model:comicModel?{
        didSet{
            coverImg.kf.setImage(with: URL(string:(model?.imgUrl!)!))
            if model?.imgs.count == 0{
                titleFolding.text = "该漫画数据加载缓慢，将会自动进入重新加载栏，请勿乱点"
                numText.text = "共\(model?.imgs.count ?? 0)页"
                return
            }
            containerImg.kf.setImage(with: URL(string:(model?.imgs[2].imgUrl!)!))
            containerImg1.kf.setImage(with: URL(string:(model?.imgs[3].imgUrl!)!))
            numText.text = "共\(model?.imgs.count ?? 0)页"
            var str:String = (model?.title)!
            let range = str.startIndex..<str.index((str.startIndex), offsetBy: 1)
            str.removeSubrange(range)
            titleFolding.text = str
            titleFolding.sizeToFit()
            if !sc(false){
                scBtutton.setImgName("bjImageb","回收废纸")
            }else{
                scBtutton.setImgName("bjImage","腾出手来")
            }
        }
    }
    var mode:scModel?{
        didSet{
            coverImg.kf.setImage(with: URL(string:(mode?.imgUrl!)!))
            if mode?.imgs.count == 0{
                titleFolding.text = "该漫画没有成功爬取到数据，将会自动进入重新加载栏，请勿乱点"
                numText.text = "共\(mode?.imgs.count ?? 0)页"
                return
            }
            containerImg.kf.setImage(with: URL(string:(mode?.imgs[2].imgUrl!)!))
            containerImg1.kf.setImage(with: URL(string:(mode?.imgs[3].imgUrl!)!))
            numText.text = "共\(mode?.imgs.count ?? 0)页"
            var str:String = (mode?.title)!
            let range = str.startIndex..<str.index((str.startIndex), offsetBy: 1)
            str.removeSubrange(range)
            titleFolding.text = str
            titleFolding.sizeToFit()
            scBtutton.setImgName("bjImageb","回收废纸")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .none // UITableViewCell.AccessoryType.none
        selectionStyle = .none     // UITableViewCell.SelectionStyle.none
        let cellW = containerView.frame.width/2.0
        containerImg.frame = CGRect(x: 0, y: 0, width: cellW, height: 300)
        containerImg1.frame = CGRect(x: cellW, y: 0, width: cellW, height: 300)
        containerView.insertSubview(containerImg, at: 0)
        containerView.insertSubview(containerImg1, at: 0)
        
      
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyCurvedShadow(view: foregroundView)
        applyCurvedShadow(view: containerView)
    }
    
    func sc(_ isDelete:Bool)->Bool {
        let i = realm.objects(scModel.self).filter("title = %@", model?.title! as Any)
        if i.count != 0 && isDelete{
            MyGeneralObject.shared().deleteSCModel(i[0])
        }
        return (i.count == 0)
    }
    
    func applyCurvedShadow(view: UIView) {
        let size = view.bounds.size
        let width = size.width
        let height = size.height
        let path = UIBezierPath()
        path.move(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width + 3, y: 0))
        path.addLine(to: CGPoint(x: width + 3, y: height))
        path.addLine(to: CGPoint(x:0, y: height))
        path.close()
        let layer = view.layer
        layer.shadowPath = path.cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 3, height: 0)
        layer.cornerRadius = 5
    }
   
}

