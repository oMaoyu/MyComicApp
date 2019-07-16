//
//  MyGeneralObject.swift
//  securities
//
//  Created by 高子雄 on 2018/12/7.
//  Copyright © 2018年 oMaoyu. All rights reserved.
//

import UIKit
import Ji
import RealmSwift
import RxSwift

let www = UIScreen.main.bounds.width
let hhh = UIScreen.main.bounds.height
let navH : CGFloat = UIDevice.current.isX() ? 88 : 64
let tabH : CGFloat = UIDevice.current.isX() ? 49 + 34 : 49

let Font1:UIFont = UIFont.systemFont(ofSize: 20)
let Font2:UIFont = UIFont.systemFont(ofSize: 18)
let Font3:UIFont = UIFont.systemFont(ofSize: 17)
let Font4:UIFont = UIFont.systemFont(ofSize: 16)
let Font5:UIFont = UIFont.systemFont(ofSize: 15)
let Font6:UIFont = UIFont.systemFont(ofSize: 14)
let Font7:UIFont = UIFont.systemFont(ofSize: 12)
let Font8:UIFont = UIFont.systemFont(ofSize: 10)
let Font9:UIFont = UIFont.systemFont(ofSize: 8)
// 创建本地数据实列
let realm = try! Realm()

// MARK: - 用户设定-语言喜好
public enum AppUser{
    case cn
    case jp
    case en
}
// MARK: - 用户设定-数组
public enum AppList{
    case cnModel // 汉化list
    case jpModel // 日版list
    case enModel // 英版list
    case scModel // 收藏list
}
class MyGeneralObject: NSObject {
    lazy var config: Realm.Configuration = {
        var config = Realm.Configuration.defaultConfiguration
        config.inMemoryIdentifier = UUID().uuidString
        return config
    }()
    
    private static let instance:MyGeneralObject  = MyGeneralObject()
    //单例
    class func shared()->MyGeneralObject{
        return  instance
    }
    let bag = DisposeBag()
    // MARK: - 获得当前页数据
    func comicList(_ page:String,_ user:AppUser){
        let pageS = page == "" ? "" : "\(page)/"
        let url = "https://hmghmg.xyz/" + modelStr(userListEnum(user)) + "/" + pageS
        
        guard let ji = Ji(htmlURL: URL(string: url)!) else {
            print("\(Date().timeStamp)===>Ji为空")
            return
        }
        guard let ary = ji.xPath("//a[contains(@href,'/\(modelStr(userListEnum(user)))/s/')]")else {
            print("xpath为空")
            return
        }
        let strAry = ary.map{$0.rawContent}
        Observable<comicModel>.create { [weak self] observer in
            guard let `self` = self else { return Disposables.create() }
            for j in strAry{
                observer.onNext(self.HtmlSubString(source: j ?? "", element:("href","title","src",page,self.modelStr(self.userListEnum(user)))))
            }
            return Disposables.create()
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(MainScheduler.instance)
        .subscribe(realm.rx.add())
        .disposed(by: bag)
    }

    // MARK: - 获取标签字符串 - 本地存储模型专用版本
    func HtmlSubString(source:String,element:(String,String,String,String,String)) -> comicModel{
        let model = comicModel()
        model.hear = htmlTag(pattern: element.0, str: source)
        model.title = htmlTag(pattern: element.1, str: source)
        
        print(htmlTag(pattern: element.2, str: source).removingPercentEncoding!)
        
        model.imgUrl = htmlTag(pattern: element.2, str: source).removingPercentEncoding!
//            (strJpg("url=", "jpg", htmlTag(pattern: element.2, str: source))+"jpg").removingPercentEncoding!
        model.page = element.3 == "" ? 0 : NSInteger(element.3)!
        model.content = element.4
        for i in imagesHref(page:htmlTag(pattern: element.0, str: source)){
            model.imgs.append(i)
        }
        return model
    } 
    // MARK: - 获取对应漫画页内容
    func imagesHref(page:String) -> [imgs]{
        let url = "https://hmghmg.xyz/" + page
        guard let ji = Ji(htmlURL: URL(string: url)!) else {
            print("img/Ji为空")
            return [imgs]()
        }
        guard let ary = ji.xPath("//a[contains(@target,'_blank')]") else {
            print("img/xpath为空")
            return [imgs]()
        }
        var imgStr = [imgs]()
        
        for j in ary {
            let str = j.rawContent
            if (str?.contains("<img") ?? false){
                if (str?.contains("https") ?? false){
                    let img = imgs()
//                    print( (strJpg("url=", "jpg", htmlTag(pattern: "src", str: str ?? ""))+"jpg").removingPercentEncoding!)
                    print(htmlTag(pattern: "src", str: str ?? "").removingPercentEncoding!)
                    
                    img.imgUrl = htmlTag(pattern: "src", str: str ?? "").removingPercentEncoding!
//                        (strJpg("url=", "jpg", htmlTag(pattern: "src", str: str ?? ""))+"jpg").removingPercentEncoding!
                    
                    imgStr.append(img)
                }
            }
        }
        return imgStr
    }
    // MARK: - 获取html标签正则
    func htmlTag(pattern:String, str:String)-> String{
      return regexGetSub("(?<=\(pattern)=\").+?(?=\")|(?<=\(pattern)=\').+?(?=\')",str)
    }
    func strJpg(_ s:String, _ e:String,_ str:String)-> String{
        return regexGetSub("(?<=(" + s + "))[.\\s\\S]*?(?=(" + e + "))",str)
    }
}
// 收藏专用
extension MyGeneralObject{
    func SCModel(_ model:comicModel){
        let mode = scModel()
        mode.title = model.title
        mode.imgUrl = model.imgUrl
        for i in model.imgs{
            mode.imgs.append(i)
        }
        Observable<scModel>.of(mode)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(realm.rx.add())
            .disposed(by: bag)
    }
    func deleteSCModel(_ model:scModel){
//        Observable<scModel>.of(model)
//            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//            .observeOn(MainScheduler.instance)
//            .subscribe(realm.rx.delete())
//            .disposed(by: bag)
        
        Observable<scModel>.create {observer in
            observer.onNext(model)
            return Disposables.create()
            }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(realm.rx.delete())
            .disposed(by: bag)
    }
}
extension MyGeneralObject {
    // MARK: - 获得用户设定 得到数据
    func userSet(_ user: AppUser)  {
        comicList("", user)
        _ = ArchiverAnObjectWithFileName("isDate", Date().timeStamp)
    }
    // MARK: - 获得用户设定 得到数据
    func userListEnum(_ user: AppUser) -> AppList {
        switch user {
        case .cn:
            return .cnModel
        case .jp:
            return .jpModel
        case .en:
            return .enModel
        }
    }
    // MARK: - 获取对应主键字符
    func modelStr(_ user:AppList) -> String {
        switch user {
        case .cnModel:
            return "cn"
        case .enModel:
            return "en"
        case .jpModel:
            return "ja"
        case .scModel:
            return "sc"
        }
    }
    // MARK: - 获取对应模型数据
    func userModes(_ user:AppUser) -> Results<comicModel> {
        return realm.objects(comicModel.self).sorted(byKeyPath:"page").filter("content = %@", modelStr(userListEnum(user)))
    }
    // MARK: - 获取收藏模型数据
    func scModes() -> Results<scModel> {
        return realm.objects(scModel.self)
    }
}

extension MyGeneralObject{
    
    // MARK: - swift 归档解档
    public func getAbsolutePathWithFileName(_ fileName : String) -> String{
        let str = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        return (str as NSString).appendingPathComponent(fileName).appending(".data")
    }
    public func UnArchiverAnObjectWithFileName(_ fileName:String)->Any{
        let path = getAbsolutePathWithFileName(fileName)
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: path) ?? "1545643005"
    }
    public func ArchiverAnObjectWithFileName(_ fileName:String,_ Object:Any) ->Bool{
        let path = getAbsolutePathWithFileName(fileName)
        
       return NSKeyedArchiver.archiveRootObject(Object, toFile:path )
    }
    // MARK: - 正则获取想要内容
    public func regexGetSub(_ pattern:String,_ str:String) -> String {
        var str1 = ""
        let regex = try! NSRegularExpression(pattern: pattern, options:[])
        let matches = regex.matches(in: str, options: [], range: NSRange(str.startIndex...,in: str))
        //解析出子串
        for  match in matches {
            str1 = (str as NSString).substring(with: match.range).replacingOccurrences(of: "\"", with: "")
        }
        return str1
    }
}

extension UIDevice {
    public func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        return false
    }
}
extension Array {
    // 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}
extension UIButton {
    func setImgName(_ imgName:String,_ titleName:String){
        self.setTitle(titleName, for: .normal)
        self.setBackgroundImage(UIImage(named:imgName), for: .normal)
    }
}
extension UIImageView{
    func imageColor(_ color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: self.zh_w, height: self.zh_h)
        UIGraphicsBeginImageContext(rect.size)
        let con = UIGraphicsGetCurrentContext()
        con?.setFillColor(color.cgColor)
        con?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img ?? UIImage()
    }
    func setCornerImage(){
        //异步绘制图像
        DispatchQueue.global().async(execute: {
            //1.建立上下文
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
            //获取当前上下文
            let ctx = UIGraphicsGetCurrentContext()
            //设置填充颜色
            UIColor.white.setFill()
            UIRectFill(self.bounds)
            //2.添加圆及裁切
            ctx?.addEllipse(in: self.bounds)
            //裁切
            ctx?.clip()
            //3.绘制图像
            self.draw(self.bounds)
            //4.获取绘制的图像
            let image = UIGraphicsGetImageFromCurrentImageContext()
            //5关闭上下文
            UIGraphicsEndImageContext()
            DispatchQueue.main.async(execute: {
                self.image = image
            })
        })
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
