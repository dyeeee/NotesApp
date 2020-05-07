//
//  NewsController.swift
//  MyNotes
//
//  Created by YES on 2020/4/19.
//  Copyright © 2020 YES. All rights reserved.
//

import Foundation
import Combine
import MinCloud

struct Book: Identifiable {
    let id: String
    var name: String
    var author: String
    var price: Float
    var content: String
    var coverUrl: String
}


struct News: Identifiable {
    let id: String
    var publicTime: String
    var title: String
    var content: String
}


final class NewsStore: ObservableObject {
    let newsTable = Table(tableId: "Subscribe")  // 建立一个 Table 对象，bookshelf 是知晓云的一个数据表，通过 bookTable 可以操作 bookshelf 表。
    
    @Published var newsStore: [News] = []   // 书籍列表

    
    func fetch() {
        let query = Query()
        query.orderBy = ["-created_at"]

        newsTable.find(query: query)  { (recordList, error) in
            var newsStore: [News] = []
            recordList?.records?.forEach({ (record) in
                let id = record.Id!
                let publicTime = record.get("time") as! String
                let title = record.get("title") as! String
                let content = record.get("content") as! String
                let news = News(id: id, publicTime: publicTime, title: title, content: content)
                newsStore.append(news)
                //print(id)
            })
            
            DispatchQueue.main.async {
                self.newsStore = newsStore
            }
        }
        
    }
}
