//
//  NoteItem+Convenience.swift
//  MyNotes
//
//  Created by YES on 2020/3/24.
//  Copyright © 2020 YES. All rights reserved.
//

import UIKit
import Foundation
import CoreData

extension NoteItem {
//取消如果不使用返回值的警告
    @discardableResult convenience init(id: UUID = UUID(), createdAt: Date,title: String, content: String, modifiedAt: Date = Date(), showFullView: Bool = false,context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {

       self.init(context: context)

       self.id = id
       self.title = title
       self.content = content
       self.createdAt = createdAt
       self.modifiedAt = modifiedAt
   }
}
