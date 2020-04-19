//
//  NoteItemController.swift
//  MyNotes
//
//  Created by YES on 2020/3/24.
//  Copyright © 2020 YES. All rights reserved.
//

import Foundation
import CoreData
import Combine
import UIKit

class NoteItemController: ObservableObject {
    @Published var NoteItemDataStore: [NoteItem] = []
    
    init(){
        //初始化的时候直接从CoreData获取这个实体的数据，然后把所有内容读入到DataStore数组中
        getAllNoteItems()
    }
    
    //获取所有数据
    func getAllNoteItems(){
        let fetchRequest: NSFetchRequest<NoteItem> =
        NoteItem.fetchRequest()
        
        // moc是ManagedObjectContext 受托上下文
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            NoteItemDataStore = try moc.fetch(fetchRequest)
        } catch{
            NSLog("Error fetching tasks: \(error)")
        }
    }
    
    //保存
    func saveToPersistentStore() {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try moc.save()
            getAllNoteItems()
            //保存后再读取
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    //条件查询
    func searchNoteItems(contain:String) {
        let fetchRequest: NSFetchRequest<NoteItem> = NoteItem.fetchRequest()
        
        //查询条件，包含传入的字符串的项放入DataStore
        let pre =  NSPredicate(format: "content contains[c] %@", "\(contain)")
        fetchRequest.predicate = pre
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do {
            //获取所有的Item到这里来
            NoteItemDataStore = try moc.fetch(fetchRequest)
             
        } catch {
            NSLog("Error fetching tasks: \(error)")

        }
    }
    
    //创建后直接保存
    func createNoteItem(title: String, content: String) {
        _ = NoteItem(title: title, content: content)
        saveToPersistentStore()
    }
    
    //更新， 传入一个Item实例对象, 修改这个实例
    func updateNoteItem(noteItemInstance: NoteItem, title: String, content: String) {
        let date = Date()
        noteItemInstance.title = title
        noteItemInstance.content = content
        noteItemInstance.modifiedAt = date
        saveToPersistentStore()
    }
    
    //删除，直接删除实例对象
    func deleteNoteItem(noteItemInstance: NoteItem) {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        moc.delete(noteItemInstance)
        print("here???")
        saveToPersistentStore()
    }
    
    //删除，根据索引删除
    func deleteNoteItem(at indexSet: IndexSet) {
        guard let index = Array(indexSet).first else { return }
        //找到索引后定义对象
        let noteItemInstance = self.NoteItemDataStore[index]
        
        deleteNoteItem(noteItemInstance: noteItemInstance)
    }
}
