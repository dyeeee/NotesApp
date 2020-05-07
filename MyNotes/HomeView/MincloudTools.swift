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
var registeResult = true

final class MincloudTools: ObservableObject {
    
    @ObservedObject var toDoItemController = toDoItemControllerGLobal
    @ObservedObject var noteItemController = noteItemControllerGlobal
    
    func userregister(name:String, pass:String) {
        Auth.login(username: name, password:pass) { (user, error) in
            var inResult:Bool = true
            
            if error != nil {
                //无法登陆才注册
                Auth.register(username: name, password: pass) { (currentUser, error) in
                    print("工具界面的成功")
                }
            }else{
                print("工具界面的失败，已有同名同密码用户")
                registeResult = false
            }
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
        
        let noteTable = Table(name: "NoteItem")
        let noteRecord = noteTable.createRecord()
        
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
                
                // MARK:- 上传所有待办，要先把云端现有的全部删了, 删除所有待办
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
                
                var toDoCount = 0
                
                let time: TimeInterval = 0.1
                
                
                //上传每一条待办事项
                for todo in self.toDoItemController.ToDoItemDataStore {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                        record.set("content", value: todo.content ?? "null")
                        record.set("done", value: todo.done )
                        record.set("createdAt",value: dateFormatter.string(from: todo.createdAt ?? Date()))
                        record.set("created_by_string",value: userId)
                        record.save { (success, error) in}
                        toDoCount += 1
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    UserDefaults.standard.set(toDoCount,forKey:"totalToDos")
                }
                
                // MARK:- 要先把云端现有的全部删了, 删除所有笔记
                let whereargsNote = Where.contains("created_by_string", value: userId)
                let queryNote = Query()
                queryNote.where = whereargsNote
                queryNote.returnTotalCount = true
                
                //每一条记录要查询的字段
                let expandNote = ["title","content"]
                
                noteTable.find(query: queryNote) { (listResult, error) in
                    //本用户的数据总数
                    let rs_index_note = listResult?.totalCount
                    var count:ClosedRange<Int>
                    
                    if rs_index_note != 0 {
                        count = 0...(rs_index_note ?? 1) - 1
                        for i in count{
                            //print(listResult?.records?[i].Id ?? "")
                            noteTable.get(listResult?.records?[i].Id ?? "", expand: expandNote) { (record, error) in
                                record?.delete { (success, error) in
                                }
                            }
                        }
                    }else{
                        count = 0...0
                        print("云端没有数据, 无法删除")
                    }
                }
                
                
                //上传每一条笔记
                var noteCount = 0
                for note in self.noteItemController.NoteItemDataStore {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                        noteRecord.set("title", value: note.title ?? "null")
                        noteRecord.set("content", value: note.content ?? "null")
                        noteRecord.set("createdAt",value: dateFormatter.string(from: note.createdAt ?? Date()))
                        noteRecord.set("created_by_string",value: userId)
                        noteRecord.save { (success, error) in}
                        noteCount += 1
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    UserDefaults.standard.set(noteCount,forKey:"totalNotes")
                }
            }
        }
    }
    
    func userDownload() {
        let userId = UserDefaults.standard.getUserID()
        var timeCount = 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd, HH:mm:ss"
        
        User.get(userId) { (user, error) in
            timeCount = user?.get("timeCount") as! Int
            UserDefaults.standard.set(timeCount*60, forKey: "timeCount_test")
            
            timerControllerGlobal.timeCount = UserDefaults.standard.integer(forKey: "timeCount_test")
        }
        
        //MARK:- 下载所有待办，首先删除本地待办
        
        let table = Table(name: "ToDoItem")
        let whereargs = Where.contains("created_by_string", value: userId)
        let query = Query()
        query.where = whereargs
        query.returnTotalCount = true
        
        //每一条记录要查询的字段
        let expand = ["content", "done","createdAt"]
        
        table.find(query: query) { (listResult, error) in
            //print(userId)
            //print(listResult?.records?[0].Id ?? "")
            //本用户的数据总数
            let rs_index = listResult?.totalCount
            var count:ClosedRange<Int>
            if rs_index != 0 {
                self.toDoItemController.deleteAllToDoItem()
                count = 0...(rs_index ?? 1) - 1
                for i in count{
                    //print(listResult?.records?[i].Id ?? "")
                    table.get(listResult?.records?[i].Id ?? "", expand: expand) { (record, error) in
                        let content = record?.get("content") as! String
                        let done_record = record?.get("done") as! Bool
                        let createdAt = dateFormatter.date(from: record?.get("createdAt") as! String)
                        var done:Bool
                        if done_record == true {
                            done = true
                        }else{
                            done = false
                        }
                        
                        self.toDoItemController.createToDoItem(content: content, done: done,createdAt:createdAt ?? Date())
                    }
                    
                }
            }else{
                count = 0...0
                //print("云端没有数据")
            }
            
            
        }
        
        //MARK:- 下载所有笔记
        
        let noteTable = Table(name: "NoteItem")
        let whereargsNote = Where.contains("created_by_string", value: userId)
        let queryNote = Query()
        queryNote.where = whereargsNote
        queryNote.returnTotalCount = true
        
        //每一条记录要查询的字段
        let expandNote = ["title","content","createdAt"]
        
        noteTable.find(query: queryNote) { (listResult, error) in
            //print(userId)
            //print(listResult?.records?[0].Id ?? "")
            //本用户的数据总数
            let rs_index_note = listResult?.totalCount
            //UserDefaults.standard.set(rs_index_note,forKey:"totalNotes")
            var count:ClosedRange<Int>
            if rs_index_note != 0 {
                self.noteItemController.deleteAllNoteItem()
                count = 0...(rs_index_note ?? 1) - 1
                for i in count{
                    //print(listResult?.records?[i].Id ?? "")
                    noteTable.get(listResult?.records?[i].Id ?? "", expand: expandNote) { (record, error) in
                        //print(record?.get("content") ?? "", record?.get("title") ?? "no")
                        let title = record?.get("title") as! String
                        let content = record?.get("content") as! String
                        let createdAt = dateFormatter.date(from: record?.get("createdAt") as! String)
                        
                        self.noteItemController.createNoteItem(title: title, content: content,createdAt:createdAt ?? Date())
                    }
                }
            }else{
                count = 0...0
                //print("云端没有数据")
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
    
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunched = "hasBeenLaunched"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunched)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: hasBeenLaunched)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}

//MARK: 日期转换工具

func StringToDate(string :String) ->Date{
    let dformatter = DateFormatter()
    dformatter.dateFormat="yyyy年MM月dd日HH:mm:ss"
    let date = dformatter.date(from: string)
    return date!
}

