//
//  MyNet_RxMoya.swift
//  securities
//
//  Created by 高子雄 on 2018/12/7.
//  Copyright © 2018年 oMaoyu. All rights reserved.
//
//  临走前改造一下网络接口

import UIKit
import Moya
import CommonCrypto

private let appKey = "3d399054afa67ff0"
private let app = "b96fc4c9bafaadc8118404baa79c932a"

let MyMainApi = MoyaProvider<MyApi>(plugins:[AuthPlugin()])
//开发环境 == true  正式 false
var preProduction:Bool = false
//路由地址
public enum My_BASE_URL{
    /// 登录等常用接口
    case portal
    /// 默认接口
    case obuck
    /// 木牛接口
    case picking
}
//接口地址
//public enum ApiUrl{
//    case loge
//}
public enum MyApi{
    //基本路由地址get、post请求
    case post(url:ApiUrl, params:[String:Any])
    case get(url:ApiUrl, params:[String:Any])
    //其它路由地址get、post请求
    case otherRequst(baseUrl:My_BASE_URL, type:OtherBaseURLRequst)
    public enum OtherBaseURLRequst {
        case post(url:ApiUrl, params:[String:Any])
        case get(url:ApiUrl, params:[String:Any])
    }
}
//实现TargetType协议，配置基本信息
extension MyApi:TargetType{
    //路由地址
    public var baseURL: URL {
        let result = self.getConfigure()
        switch result.1 {
        case .obuck:
            let str = preProduction ? "http://obuck.51lovo.ts/" : "https://obuck.51lovo.com/"
            return URL(string: str)!
        case .picking:
            let str = preProduction ? "http://muniu.51lovo.ts/" : "https://muniu.51lovo.com:4433/"
            return URL(string: str)!
        case .portal:
            let str = preProduction ? "http://www.51lovo.ts/" : "https://portal.51lovo.com/"
            return URL(string: str)!
        }
    }
    //具体地址
    public var path: String {
        let result = self.getConfigure()
        let str = MyNetApiUrl(result.2)
        
        
        return MyNetApiUrl(result.2)
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
        return  ["content-type" : "application/x-www-form-urlencoded"]
    }
    private func getConfigure() -> (Moya.Method,My_BASE_URL,ApiUrl,[String:Any]) {
        switch self {
        case .get(url: let suffixUrl, params: let params):
            return (.get,.obuck,suffixUrl,params)
        case .post(url: let suffixUrl, params: let params):
            return (.post,.obuck,suffixUrl,params)
        case .otherRequst(baseUrl: let baseUrl, type: let type):
            switch type{
            case .get(url: let suffixUrl, params: let params):
                return (.get,baseUrl,suffixUrl,params)
            case .post(url: let suffixUrl, params: let params):
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

extension Dictionary{
    /// 字典升序加密
    func dicMd5() -> String {
        let dic:[String:Any] = self as! [String : Any]
        let key = Array(dic.keys).sorted(by: {$0 > $1})
        var str = app
//        i 为 key排序后的string字段
        for i in key{
//          判断该字段值是否为array  如果是  则进行分化
            let v = dic[i]
            if v is Array<Any> {
                let array:Array<String> = v as! Array<String>
                str = str + i + "[]"
                for j in array.enumerated(){
                    if j.0 + 1 == array.count{
                        str = str + j.1
                    }else{
                        str = str + j.1 + ","
                    }
                }
            }else{
                str = str + i + "\(v ?? "")"
            }
        }
        str = str + app

        return str.MD5()
    }
    /// 生成网络请求字典
    func MyNetDict()->[String:Any]{
        var dict = self as! [String : Any]
        dict[""] = nil
        dict["user_token"] = "user_token".UnArchiverAnObjectWithFileName()
        dict["cv"] = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        dict["timestamp"] = Date().milliStamp
        dict["app_key"] = appKey
        dict["sign"] = dict.dicMd5()
        return dict
    }
}
extension String{
    /// 字符串md5加密
    func MD5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
    /// urlMd5加密
    func MD5URL()->String{
        if self.count <= 5 {return ""}
        let str = self[self.index(self.startIndex, offsetBy: 9)...self.index(self.startIndex, offsetBy: 16)]
        let str1 = self[self.index(self.startIndex, offsetBy: 5)...self.index(self.startIndex, offsetBy: 11)]
        let md = String(str + str1)
        return md.MD5()
    }
    ///  根据文件名解析地址
    public func getAbsolutePathWithFileName(_ fileName : String) -> String{
        let str = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        return (str as NSString).appendingPathComponent(fileName).appending(".data")
    }
    /// 解档
    public func UnArchiverAnObjectWithFileName()->Any{
        let path = getAbsolutePathWithFileName(self)
        return NSKeyedUnarchiver.unarchiveObject(withFile: path) ?? ""
    }
    /// 归档
    public func ArchiverAnObjectWithFileName(_ Object:Any) ->Bool{
        let path = getAbsolutePathWithFileName(self)
        
        return NSKeyedArchiver.archiveRootObject(Object, toFile:path )
    }
    var uuid:String{
        let uid = "uuid".UnArchiverAnObjectWithFileName() as? String
        guard uid != nil else {
            let uuid = UIDevice.current.identifierForVendor!.uuidString
            _ = "uuid".ArchiverAnObjectWithFileName(uuid)
            return uuid
        }
        return uid!;
    }
    ///版本比较 version 为系统版本  self 为后端版本
    func versionCompare(_ version:String) -> Bool {
        //判断合法性
        if checkSeparat(vString: version) == "" || checkSeparat(vString: self) == ""{
             print("只支持 '.''-'/''*'_'作为分隔符")
            return false
        }
        //获得两个数组
        let v1Arr = cutUpNumber(vString: version) as! [String]
        let v2Arr = cutUpNumber(vString: self) as! [String]
        //比较版本号
        return compareNumber(v1Arr: v1Arr, v2Arr: v2Arr)
    }
    ///提取连接符
    func checkSeparat(vString:String) -> String {
        var separated:String = ""
        if vString.contains("."){  separated = "." }
        if vString.contains("-"){  separated = "-" }
        if vString.contains("/"){  separated = "/" }
        if vString.contains("*"){  separated = "*" }
        if vString.contains("_"){  separated = "_" }
        
        return separated
    }
    ///提取版本号
    func cutUpNumber(vString:String) -> NSArray {
        let  separat = checkSeparat(vString: vString)
        let b = NSCharacterSet(charactersIn:separat) as CharacterSet
        let vStringArr = vString.components(separatedBy: b)
        return vStringArr as NSArray
    }
    ///比较版本
    func compareNumber(v1Arr:[String],v2Arr:[String]) -> Bool {
        for i in 0..<v1Arr.count{
            if  Int(v1Arr[i])! != Int(v2Arr[i])! {
                if Int(v1Arr[i])! > Int(v2Arr[i])! {
                    return false
                }else{
                    return true
                }
            }
        }
        return false
    }
    
}


extension Date {
    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
}
