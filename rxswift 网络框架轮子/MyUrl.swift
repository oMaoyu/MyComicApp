//
//  MyUrl.swift
//  employees
//
//  Created by 高子雄 on 2017/9/13.
//  Copyright © 2017年 oMaoyu. All rights reserved.
//

import UIKit

// 正式环境obuck
let preObuck:String =  "https://obuck.51lovo.com/"
// 正式环境portal
let prePortal:String = "https://portal.51lovo.com/"
//  正式木牛
let prePicking:String = "https://muniu.51lovo.com:4433/"
//测试obuck
let obuck:String = "http://obuck.51lovo.ts/"
//let obuck:String = "http://192.168.2.124:8080/obuck/"
//测试portal //
let portal:String = "http://www.51lovo.ts/"
// 测试 何其丹
let picking:String = "http://muniu.51lovo.ts/"//"http://192.168.2.117:8080/wmsplus/"


//接口地址
public enum ApiUrl{
    /// 获取验证码 portal
    case getPhoneValicode
    /// 登录 portal
    case login
    /// 获取图标 portal
    case icon
    /// 获取用户信息 portal
    case userInfo
    /// 版本信息 portal
    case check
    /// 加入补货车 obuck
    case jAdd
    /// 清空补货车 obuck
    case jClear
    /// 产品详情 obuck
    case jGoodsDetail
    /// 我的订单列表 obuck
    case jList
    /// 再来一单 obuck
    case jBuyagain
    /// 导出邮箱 obuck
    case jEmali
    /// 修改补货单产品数量 obuck
    case jNum
    /// 取消补货单 obuck
    case jCancel
    /// 更新订单付款状态 obuck
    case jUpdate
    /// 订单详情 obuck
    case jDetail
    /// 品类列表 obuck
    case jWords
    /// 产品搜索 obuck
    case jSearchList
    /// 查看补货车 obuck
    case jView
    /// 查询收货地址 obuck
    case jDelivery
    /// 选择收货地址 obuck
    case jChooseDelivery
    /// 选择配送方式 obuck
    case jChooseShipping
    /// 结算 obuck
    case jCheckout
    /// 提交补货单 obuck
    case jSubmit
    /// 移除补货车商品 obuck
    case jRemove
    /// 修改调货车数量 obuck
    case stNum
    /// 查询调货补货车 obuck
    case stView
    /// 删除调货车产品 obuck
    case stRemove
    /// 提交调货单 obuck
    case stSubmit
    /// 邮件导出调拨单 obuck
    case stExport
    /// 仓库查询列表 obuck
    case stCk
    /// 加入调货补货车 obuck
    case stAdd
    /// 我发起的 收到的调拨单 obuck
    case stList
    /// 同意调仓申请 obuck
    case stAgree
    /// 拒绝调仓申请 obuck
    case stRefuse
    /// 搜索页 obuck
    case stSearchList
    /// 搜索详情 obuck
    case stSearchDetail
    /// 取消调仓申请 obuck
    case stCancel
    /// 加盟商产品查询接口 obuck
    case jmxProduct
    /// 产品查询列表 obuck
    case jmxList
    /// 提交订单列表 obuck
    case jmxSubmit
    /// 广告业 obuck
    case adGet
    /// 支付接口 obuck
    case payAlipay
    /// 校验拣货任务 picking
    case pInfo
    /// 查询篮位号 picking
    case pOrder
    ///  picking
    case jkBhcx
    
}
func MyNetApiUrl(_ api:ApiUrl)->String{
    switch api {
    case .adGet:
        return "rest/common/ad/get.json"
    case .check:
        return "rest/check.json"
    case .getPhoneValicode:
        return "rest/getPhoneValicode.json"
    case .icon:
        return "rest/icon.json"
    case .jAdd:
        return  "rest/jiameng/truck/add.json"
    case .jBuyagain:
        return "rest/jiameng/order/buy/again.json"
    case .jCancel:
        return "rest/jiameng/order/cancel.json"
    case .jCheckout:
        return "rest/jiameng/checkout/view.json"
    case .jChooseDelivery:
        return "rest/jiameng/checkout/choose/delivery.json"
    case .jChooseShipping:
        return "rest/jiameng/checkout/choose/shipping.json"
    case .jClear:
        return "rest/jiameng/truck/clear.json"
    case .login:
        return "rest/login.json"
    case .userInfo:
        return "rest/userInfo.json"
    case .jGoodsDetail:
        return "rest/jiameng/goods/detail.json"
    case .jList:
        return "rest/jiameng/order/list.json"
    case .jEmali:
        return "rest/jiameng/order/send/mail.json"
    case .jNum:
        return "rest/jiameng/truck/edit/num.json"
    case .jUpdate:
        return "rest/jiameng/order/pay/update.json"
    case .jDetail:
        return "rest/jiameng/order/detail.json"
    case .jWords:
        return "rest/jiameng/search/words.json"
    case .jSearchList:
        return "rest/jiameng/search/list.json"
    case .jView:
        return "rest/jiameng/truck/view.json"
    case .jDelivery:
        return "rest/jiameng/truck/delivery.json"
    case .jSubmit:
        return "rest/jiameng/checkout/submit.json"
    case .jRemove:
        return "rest/jiameng/truck/remove.json"
    case .stNum:
        return "rest/st/truck/edit/num.json"
    case .stView:
        return "rest/st/truck/view.json"
    case .stRemove:
        return "rest/st/truck/remove.json"
    case .stSubmit:
        return "rest/st/truck/submit.json"
    case .stExport:
        return "rest/st/order/export.json"
    case .stCk:
        return "rest/st/search/ck.json"
    case .stAdd:
        return "rest/st/truck/add.json"
    case .stList:
        return "rest/st/order/list.json"
    case .stAgree:
        return "rest/st/order/agree.json"
    case .stRefuse:
        return "rest/st/order/refuse.json"
    case .stSearchList:
        return "rest/st/search/list.json"
    case .stSearchDetail:
        return "rest/st/search/detail.json"
    case .stCancel:
        return "rest/st/order/cancel.json"
    case .jmxProduct:
        return "rest/jmx/search/product.json"
    case .jmxList:
        return "rest/jmx/order/list.json"
    case .jmxSubmit:
        return "rest/jmx/order/submit.json"
    case .payAlipay:
        return "pay/alipay.json"
    case .pInfo:
        return "app/picking/info.json"
    case .pOrder:
        return "app/picking/order.json"
    case .jkBhcx:
        return "app/jk/bhcx.json"
    }
}

class MyUrl: NSObject {
    // preProduction = true  测试  false 正式
    //  portal接口系列
    // MARK: - 获取验证码
    class func getPhoneValicode()->String{
        let str = MyNetWorking.shared().preProduction ? portal : prePortal
        return str.appending("rest/getPhoneValicode.json")
    }
    // MARK: -  登录
    class func login()->String{
        let str = MyNetWorking.shared().preProduction ? portal : prePortal
        return str.appending("rest/login.json")
    }
    // MARK: -  获取图标
    class func icon()->String{
        let str = MyNetWorking.shared().preProduction ? portal : prePortal
        return str.appending("rest/icon.json")
    }
    // MARK: -  获取用户信息
    class func userInfo()->String{
        let str = MyNetWorking.shared().preProduction ? portal : prePortal
        return str.appending("rest/userInfo.json")
    }
    // MARK: -  版本信息
    class func check()->String{
        let str = MyNetWorking.shared().preProduction ? portal : prePortal
        return str.appending("rest/check.json")
    }
    //  obuck接口系列
    // MARK: - 加入补货车
    class func jAdd()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jiameng/truck/add.json")
    }
    // MARK: - 清空补货车
    class func jClear()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jiameng/truck/clear.json")
    }
    // MARK: -  产品详情
    class func jGoodsDetail()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jiameng/goods/detail.json")
    }
    // MARK: -  我的订单列表
    class func jList()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jiameng/order/list.json")
    }
    // MARK: - 再来一单
    class func jBuyagain()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jiameng/order/buy/again.json")
    }
    // 导出邮箱
    class func jEmali()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jiameng/order/send/mail.json ")
    }
    
    // MARK: -  修改补货单产品数量
    class func jNum()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jiameng/truck/edit/num.json")
    }
    // MARK: -  取消补货单
    class func jCancel()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jiameng/order/cancel.json")
    }
    // MARK: -  更新订单付款状态
    class func jUpdate()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jiameng/order/pay/update.json")
    }
    // MARK: -  订单详情
    class func jDetail()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jiameng/order/detail.json")
    }
    // MARK: -  品类列表
    class func jWords()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jiameng/search/words.json")
    }
    // MARK: -  产品搜索
    class func jSearchList()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jiameng/search/list.json")
    }
    // MARK: -  查看补货车
    class func jView()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jiameng/truck/view.json")
    }
    // MARK: -  查询收货地址
    class func jDelivery()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jiameng/truck/delivery.json")
    }
    // MARK: -  选择收货地址
    class func jChooseDelivery()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jiameng/checkout/choose/delivery.json")
    }
    // MARK: -  选择配送方式
    class func jChooseShipping()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jiameng/checkout/choose/shipping.json")
    }
    //MARK: - 结算
    class func jCheckout()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jiameng/checkout/view.json")
    }
    //MARK: - 提交补货单
    class func jSubmit()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jiameng/checkout/submit.json")
    }
    // MARK: - 移除补货车商品
    class func jRemove()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jiameng/truck/remove.json")
    }
    // MARK: -  修改调货车数量
    class func stNum()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/st/truck/edit/num.json")
    }
    // MARK: -  查询调货补货车
    class func stView()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/st/truck/view.json")
    }
    // MARK: -  删除调货车产品
    class func stRemove()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/st/truck/remove.json")
    }
    // MARK: -  提交调货单
    class func stSubmit()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/st/truck/submit.json")
    }
    // MARK: -  邮件导出调拨单
    class func stExport()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/st/order/export.json")
    }
    // MARK: -  仓库查询列表
    class func stCk()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/st/search/ck.json")
    }
    // MARK: -  加入调货补货车
    class func stAdd()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/st/truck/add.json")
    }
    // MARK: -  我发起的 收到的调拨单
    class func stList()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/st/order/list.json")
    }
    // MARK: -  同意调仓申请
    class func stAgree()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/st/order/agree.json")
    }
    // MARK: -  拒绝调仓申请
    class func stRefuse()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/st/order/refuse.json")
    }
    // MARK: -  搜索页
    class func stSearchList()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/st/search/list.json")
    }
    // MARK: -  搜索详情
    class func stSearchDetail()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/st/search/detail.json")
    }
    // MARK: -  取消调仓申请
    class func stCancel()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/st/order/cancel.json")
    }
    // MARK: -  加盟商产品查询接口
    class func jmxProduct()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jmx/search/product.json")
    }
    // MARK: -  产品查询列表
    class func jmxList()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jmx/order/list.json")
    }
    // MARK: -  提交订单列表
    class func jmxSubmit()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/jmx/order/submit.json")
    }
    // MARK: -  广告业
    class func adGet()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("rest/common/ad/get.json")
    }
    // MARK: - 支付接口
    class func payAlipay()->String{
        let str = MyNetWorking.shared().preProduction ? obuck : preObuck
        return str.appending("pay/alipay.json")
    }
    
    //
    // MARK: -  校验拣货任务
    class func pInfo()->String{
        let str = MyNetWorking.shared().preProduction ? picking : prePicking
        return str.appending("app/picking/info.json")
    }
    // MARK: -  查询篮位号
    class func pOrder()->String{
        let str = MyNetWorking.shared().preProduction ? picking : prePicking
        return str.appending("app/picking/order.json")
    }
    
    class func jkBhcx()->String{
        let str = MyNetWorking.shared().preProduction ? picking : prePicking
        return str.appending("app/jk/bhcx.json")
    }
}
