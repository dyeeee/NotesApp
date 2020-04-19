//
//  ToDoItemController.swift
//  MyNotes
//
//  Created by YES on 2020/3/27.
//  Copyright © 2020 YES. All rights reserved.
//

import Foundation
import CoreData
import Combine
import UIKit

class ToDoItemController: ObservableObject {
    
    // ToDoItem的数组
    @Published var ToDoItemDataStore: [ToDoItem] = []
    
    //初始化时就把所有数据显先读到DataStore中
    init() {
        getAllToDoItems()
    }
    
    //读取
    func getAllToDoItems() {
        let fetchRequest: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            //获取所有的ToDoItem到这里来
            ToDoItemDataStore = try moc.fetch(fetchRequest)
             
        } catch {
            NSLog("Error fetching tasks: \(error)")

        }
    }
    
    //保存
    func saveToPersistentStore() {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try moc.save()
            getAllToDoItems()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    //查询
    func searchToDoItems(contain:String) {
        let fetchRequest: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        
        //ToDoItem.fetchRequest() 就是 NSFetchRequest<ToDoItem>(entityName: "ToDoItem"）
        let pre =  NSPredicate(format: "content contains[c] %@", "\(contain)")
        fetchRequest.predicate = pre
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do {
            //获取所有的ToDoItem到这里来
            ToDoItemDataStore = try moc.fetch(fetchRequest)
             
        } catch {
            NSLog("Error fetching tasks: \(error)")

        }
    }
    
    
    //创建,传参后直接保存
    func createToDoItem(content: String) {
        _ = ToDoItem(content: content)
        saveToPersistentStore()
    }
    
    //创建,传参后直接保存
    func createToDoItem(content: String, done:Bool) {
        _ = ToDoItem(content: content, done: done)
        saveToPersistentStore()
    }
    
    //更新， 传入一个ToDoItem实例对象
    func updateToDoItem(ToDoItemInstance: ToDoItem, content: String) {
        ToDoItemInstance.content = content
        saveToPersistentStore()
    }
    
    //更新， 传入一个ToDoItem实例对象
    func updateToDoItem(ToDoItemInstance: ToDoItem, done:Bool) {
        ToDoItemInstance.done = done
        saveToPersistentStore()
    }
    
    //删除，直接删除对象
    func deleteToDoItem(ToDoItemInstance: ToDoItem) {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        moc.delete(ToDoItemInstance)
        saveToPersistentStore()
    }
    
    //删除，根据索引删除
    func deleteToDoItem(at indexSet: IndexSet) {
        guard let index = Array(indexSet).first else { return }
        //找到索引后定义对象
        let ToDoItem = self.ToDoItemDataStore[index]
        
        deleteToDoItem(ToDoItemInstance: ToDoItem)
    }
    
    //删除
    func deleteAllToDoItem() {
        for toDoItem in self.ToDoItemDataStore {
            deleteToDoItem(ToDoItemInstance: toDoItem)
        }
    }
}
