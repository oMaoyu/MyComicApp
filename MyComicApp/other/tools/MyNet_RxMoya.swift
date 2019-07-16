//
//  MyNet_RxMoya.swift
//  securities
//
//  Created by 高子雄 on 2018/12/7.
//  Copyright © 2018年 oMaoyu. All rights reserved.
//

import UIKit
import Moya
//1、根据Moya要求，网络请求需要创建一个Provider,MoyaProvider需要我们传入一个实现TargetType协议的对象，这个协议里面包含了请求的路由地址和具体路径、请求方式等网络请求相关基本信息
let MyMainApi = MoyaProvider<MyApi>(plugins:[AuthPlugin()])
//路由地址
let My_BASE_URL = "https://www.douban.com"
//接口地址
public enum ApiUrl{
    case loge
}
public enum MyApi{
    //基本路由地址get、post请求
    case post(suffixUrl:ApiUrl, params:[String:Any])
    case get(suffixUrl:ApiUrl, params:[String:Any])
    
    //其它路由地址get、post请求
    case otherRequst(baseUrl:String, type:OtherBaseURLRequst)
    public enum OtherBaseURLRequst {
        case post(suffixUrl:ApiUrl, params:[String:Any])
        case get(suffixUrl:ApiUrl, params:[String:Any])
    }
}
//实现TargetType协议，配置基本信息
extension MyApi:TargetType{
    //路由地址
    public var baseURL: URL {
        let result = self.getConfigure()
        return URL(string: result.1)!
        
    }
    //具体地址
    public var path: String {
        let result = self.getConfigure()
        switch result.2 {
        case .loge:
            return "/j/app/radio/channels"
//        default:
//            return "yyyy"
        }
    }
    //请求方式get、post
    public var method: Moya.Method {
        let result = self.getConfigure()
        return result.0
    }
    //单元测试所用
    public var sampleData: Data {
        return "{}".data(using: .utf8)!
    }
    //请求任务事件（这里附带上参数）
    public var task: Task {
        //request上传、upload上传、download下载
        let result = self.getConfigure()
//        print(result.3)
        return .requestParameters(parameters: result.3, encoding: URLEncoding.default)
    }
    //请求头
    public var headers: [String : String]? {
        return nil
    }
    private func getConfigure() -> (Moya.Method,String,ApiUrl,[String:Any]) {
        switch self {
        case .get(suffixUrl: let suffixUrl, params: let params):
            return (.get,My_BASE_URL,suffixUrl,params)
        case .post(suffixUrl: let suffixUrl, params: let params):
            return (.post,My_BASE_URL,suffixUrl,params)
        case .otherRequst(baseUrl: let baseUrl, type: let type):
            switch type{
            case .get(suffixUrl: let suffixUrl, params: let params):
                return (.get,baseUrl,suffixUrl,params)
            case .post(suffixUrl: let suffixUrl, params: let params):
                return (.post,baseUrl,suffixUrl,params)
            }
        }
    }
    
}
//当需要在header里面添加请求token或者时间戳等信息时可以传入这些配置
struct AuthPlugin: PluginType {
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        
//         var request = request
//         UserDefaults.standard.synchronize()
//         let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String
//         let timestamp: Int = Int.getTimeStamp()
//         request.addValue("\(timestamp)", forHTTPHeaderField: "timestamp")
//         if accessToken != nil {
//         request.addValue(accessToken!, forHTTPHeaderField: "accessToken")
//         }
//         print(request.allHTTPHeaderFields)
 
        return request
    }
}
class MyNet_RxMoya: NSObject {
    
    
    
    
}
