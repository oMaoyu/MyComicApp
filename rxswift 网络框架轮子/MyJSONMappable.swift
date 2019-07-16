//
//  MyJSONMappable.swift
//  securities
//
//  Created by 高子雄 on 2018/12/10.
//  Copyright © 2018年 oMaoyu. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol JSONMappable{
    init?(fromJson json:JSON)
}

struct baseMode:JSONMappable{
    var code: String?
    var data:[String:JSON]?
    var msg:String?
    var error:String?
    var response_time:String?
    
    init?(fromJson json: JSON) {
        code = json["code"].stringValue
        data = json["data"].dictionary
        msg = json["msg"].stringValue
        error = json["error"].stringValue
        response_time = json["response_time"].stringValue
    }
}

struct  updataModel: JSONMappable {
    var update_info:String? // 更新内容
    var app_store_id:String? // 更新url
    var version_no:String? // 版本号
    var site_code:String?
    var must_update:NSNumber? // 0不强制 1强制
    init?(fromJson json: JSON) {
        update_info = json["update_info"].stringValue
        app_store_id = json["app_store_id"].stringValue
        version_no = json["version_no"].stringValue
        site_code = json["site_code"].stringValue
        must_update = json["must_update"].numberValue
    }
}
