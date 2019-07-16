//
//  MyMainTableView.swift
//  employees
//
//  Created by 高子雄 on 2017/5/26.
//  Copyright © 2017年 oMaoyu. All rights reserved.
//

import UIKit

class MyMainTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        estimatedRowHeight = 0
        estimatedSectionHeaderHeight = 0
        estimatedSectionFooterHeight = 0
        tableHeaderView = UIView(frame:CGRect(x: 0, y: 0, width: www, height: 0.01))
        tableFooterView = UIView(frame:CGRect(x: 0, y: 0, width: www, height: 0.01))
        showsVerticalScrollIndicator = false
        
        separatorStyle = .none
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
