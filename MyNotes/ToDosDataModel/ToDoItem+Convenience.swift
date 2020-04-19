//
//  ToDoItem+Convenience.swift
//  MyNotes
//
//  Created by YES on 2020/3/27.
//  Copyright © 2020 YES. All rights reserved.
//

import UIKit
import Foundation
import CoreData

extension ToDoItem {
//取消如果不使用返回值的警告
    @discardableResult convenience init(id: UUID = UUID(), createdAt: Date = Date(), content: String, done: Bool = false, context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {

       self.init(context: context)

       self.id = id
       self.content = content
       self.createdAt = createdAt
       self.done = done
   }
}
