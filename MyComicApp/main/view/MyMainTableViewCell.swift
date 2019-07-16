//
//  MyMainTableViewCell.swift
//  employees
//
//  Created by 高子雄 on 2017/4/24.
//  Copyright © 2017年 oMaoyu. All rights reserved.
//

import UIKit

class MyMainTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .none // UITableViewCell.AccessoryType.none
        self.selectionStyle = .none     // UITableViewCell.SelectionStyle.none
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
