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
