//
//  MincloudTools.swift
//  MyNotes
//
//  Created by YES on 2020/4/14.
//  Copyright © 2020 YES. All rights reserved.
//

import Foundation
import Combine
import MinCloud
import SwiftUI


var noteItemControllerGlobal = NoteItemController()
var toDoItemControllerGLobal = ToDoItemController()
var uploadDone = false
var loginError = false

final class MincloudTools: ObservableObject {
    
    @ObservedObject var toDoItemController = toDoItemControllerGLobal
    
    func userregister(name:String, pass:String) {
        Auth.register(username: name, password: pass) { (currentUser, error) in

        }
    }
    
    func userlogin(name:String, pass:String){
        Auth.login(username: name, password:pass) { (user, error) in
            // 错误处理
            if error != nil {
                loginError = true
                if let error = error {
                    print("Parsing error: \(error.code), \(error.localizedDescription)")
                } else {
                    print("Other error: \(error!)")
                }
            }else{
                UserDefaults.standard.setLoggedIn(value: true)
                UserDefaults.standard.set(user?.username ?? "unkonwn",forKey:"username")
                UserDefaults.standard.set(pass,forKey:"userPassward")
                
                UserDefaults.standard.setUserID(value: user?.userId ?? "")
                print("success")
            }


        }
    }
    
    func userUpload() {
        let userId = UserDefaults.standard.getUserID()
        let name = UserDefaults.standard.string(forKey: "username")
        let pass = UserDefaults.standard.string(forKey: "userPassward")
        let timeCount = UserDefaults.standard.integer(forKey: "timeCount_test") / 60
        
        let table = Table(name: "ToDoItem")
        let record = table.createRecord()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd, HH:mm:ss"

        
        Auth.login(username: name ?? "", password: pass ?? "") { (user, error) in
            // 错误处理
            if error != nil {
                if let error = error {
                    print("Parsing error: \(error.code), \(error.localizedDescription)")
//                    print(name)
//                    print(pass)
                } else {
                    print("Other error: \(error!)")
                }
            }else{
                user?.updateUserInfo(["timeCount": timeCount]) { (result, error) in
//                    print(timeCount)
//                    print("上传的专注时长：",result)
                }
                
                //要先把云端现有的全部删了
                let whereargs = Where.contains("created_by_string", value: userId)
                let query = Query()
                query.where = whereargs
                query.returnTotalCount = true
                
                //每一条记录要查询的字段
                let expand = ["content", "done"]
                
                table.find(query: query) { (listResult, error) in
                    //本用户的数据总数
                    let rs_index = listResult?.totalCount
                    var count:ClosedRange<Int>
                    
                    if rs_index != 0 {
                        count = 0...(rs_index ?? 1) - 1
                        for i in count{
                            //print(listResult?.records?[i].Id ?? "")
                            table.get(listResult?.records?[i].Id ?? "", expand: expand) { (record, error) in
                                record?.delete { (success, error) in
                                }
                            }
                            
                        }
                    }else{
                        count = 0...0
                        print("云端没有数据")
                    }
                }
                
                
                //上传每一条待办事项
                for todo in self.toDoItemController.ToDoItemDataStore {
                    record.set("content", value: todo.content ?? "null")
                    record.set("done", value: todo.done )
                    record.set("createdAt",value: dateFormatter.string(from: todo.createdAt ?? Date()))
                    record.set("created_by_string",value: userId)
                    record.save { (success, error) in}
                }
                
                
            }
        }
    }
    
    func userDownload() {
        let userId = UserDefaults.standard.getUserID()
        var timeCount = 0

        
        
        User.get(userId) { (user, error) in
            timeCount = user?.get("timeCount") as! Int
            UserDefaults.standard.set(timeCount*60, forKey: "timeCount_test")
            
            timerControllerGlobal.timeCount = UserDefaults.standard.integer(forKey: "timeCount_test")
        }
        
        toDoItemController.deleteAllToDoItem()
        
        let table = Table(name: "ToDoItem")
        let whereargs = Where.contains("created_by_string", value: userId)
        let query = Query()
        query.where = whereargs
        query.returnTotalCount = true
        
        //每一条记录要查询的字段
        let expand = ["content", "done"]
        
        table.find(query: query) { (listResult, error) in
            //print(userId)
            //print(listResult?.records?[0].Id ?? "")
            //本用户的数据总数
            let rs_index = listResult?.totalCount
            var count:ClosedRange<Int>
            if rs_index != 0 {
                count = 0...(rs_index ?? 1) - 1
                for i in count{
                    //print(listResult?.records?[i].Id ?? "")
                    table.get(listResult?.records?[i].Id ?? "", expand: expand) { (record, error) in
                        print(record?.get("content") ?? "", record?.get("done") ?? "no")
                        let content = record?.get("content") as! String
                        let done_record = record?.get("done") as! Bool
                        var done:Bool
                        if done_record == true {
                            done = true
                        }else{
                            done = false
                        }
                        
                        self.toDoItemController.createToDoItem(content: content, done: done)
                    }
                    
                }
            }else{
                count = 0...0
                print("云端没有数据")
            }
            

        }

        
    }
    
    func userlogout() {
        Auth.logout { (success, error) in

        }
    }
    
}


enum UserDefaultsKeys : String {
    case isLoggedIn
    case userID
}

extension UserDefaults{

    //MARK: Check Login
    func setLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        //synchronize()
    }

    func isLoggedIn()-> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }

    //MARK: Save User Data
    func setUserID(value: String){
        set(value, forKey: UserDefaultsKeys.userID.rawValue)
        //synchronize()
    }

    //MARK: Retrieve User Data
    func getUserID() -> String{
        return string(forKey: UserDefaultsKeys.userID.rawValue) ?? ""
    }
}
