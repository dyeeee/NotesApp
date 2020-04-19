//
//  ToDoItem+CoreDataProperties.swift
//  MyNotes
//
//  Created by YES on 2020/3/27.
//  Copyright © 2020 YES. All rights reserved.
//
//

import Foundation
import CoreData


extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var content: String?
    @NSManaged public var done: Bool
    @NSManaged public var id: UUID?

}
