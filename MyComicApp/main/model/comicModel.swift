//
//  comicModel.swift
//  MyComicApp
//
//  Created by 高子雄 on 2018/12/17.
//Copyright © 2018年 oMaoyu. All rights reserved.
//

import Foundation
import RealmSwift

class comicModel: Object {
    @objc dynamic var imgUrl:String? = nil
    @objc dynamic var hear:String? = nil
    @objc dynamic var title:String? = nil
    @objc dynamic var page = 0
//    cn 中国   jp 日本  en 美国 sc收藏
    @objc dynamic var content:String? = nil
    let imgs = List<imgs>()
    override class func indexedProperties() -> [String] {
        return ["title"]
    }
}

class imgs: Object {
    @objc dynamic var imgUrl:String? = nil
}

class scModel: Object {
    @objc dynamic var imgUrl:String? = nil
    @objc dynamic var hear:String? = nil
    @objc dynamic var title:String? = nil
    @objc dynamic var page = 0
    @objc dynamic var content:String? = nil
    @objc dynamic var isSC = false
    let imgs = List<imgs>()
    override class func indexedProperties() -> [String] {
        return ["title"]
    }
}
