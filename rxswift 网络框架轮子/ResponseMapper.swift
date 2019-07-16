//
//  ResponseMapper.swift
//  employees
//
//  Created by 高子雄 on 2019/1/30.
//  Copyright © 2019年 oMaoyu. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import RxSwift

let RESULT_CODE = "code"
let RESULT_DATA = "data"


enum MyRequestStatus:String {
    case RequstSuccess = "200"
    case RequstError
}
enum MyError : Error {
    /// 网络请求数据有问题
    case noRepresentor
    /// 链接问题
    case notSuccessfulHTTP
    /// 没数据
    case noData
    /// 解析data数据错误
    case couldNotMakeObjectError
    ///没登录
    case noLogin
    /// 适用于 200  401 以外错误 如999
    case netError(msg:String?,code:String?)
}
extension Error {
    func errorHandling(_ error:Error){
        /// 用来弹窗等显示
        if case MyError.netError(msg: let _, code: let _) = error {
            print("执行")
//            print(i,j)
        }
        /// 前往登录界面
        else if case MyError.noLogin = error {
            
        }
        /// 其他错误统一处理
        else{
            print(error)
        }
    }
}


extension Observable{
    
    private func resultFromJSON<T:JSONMappable>(jsonData:JSON,classType:T.Type) -> T? {
        return T(fromJson: jsonData)
    }
    
    func mapResponseToObj<T:JSONMappable>(type:T.Type) -> Observable<T?> {
        return map{ representor in
            guard let response = representor as? Moya.Response else{
                throw MyError.noRepresentor
            }
            guard ((200...209) ~= response.statusCode) else{
                throw MyError.notSuccessfulHTTP
            }
            let json = try? JSON.init(data: response.data)
            if let code = json?[RESULT_CODE].string{
                if code == MyRequestStatus.RequstSuccess.rawValue{
                    return self.resultFromJSON(jsonData: json![RESULT_DATA], classType: type)
                }else if code == "401"{
                    throw MyError.noLogin
                }else {
                    throw MyError.netError(msg: json?["msg"].string, code: json?[RESULT_CODE].string)
                }
            }else{
                throw MyError.couldNotMakeObjectError
            }
        }
    }
    func mapResponseToObjArray<T:JSONMappable>(type:T.Type) -> Observable<[T]> {
        return map{ representor in
            guard let response = representor as? Moya.Response else{
                throw MyError.noRepresentor
            }
            guard ((200...209) ~= response.statusCode) else{
                throw MyError.notSuccessfulHTTP
            }
            
            let json = try? JSON.init(data: response.data)
            
            if let code = json?[RESULT_CODE].string{
                if code == MyRequestStatus.RequstSuccess.rawValue{
                    var objects = [T]()
                    let objectsArray = json?[RESULT_DATA].array
                    if let array = objectsArray{
                        for object in array{
                            if let obj = self.resultFromJSON(jsonData: object, classType: type){
                                objects.append(obj)
                            }
                        }
                        return objects
                    }else{
                        throw  MyError.noData
                    }
                }else if code == "401"{
                    throw MyError.noLogin
                }else{
                    throw MyError.netError(msg: json?["msg"].string, code: json?[RESULT_CODE].string)
                }
                
            }else{
                throw MyError.couldNotMakeObjectError
            }
        }
    }
    
}
