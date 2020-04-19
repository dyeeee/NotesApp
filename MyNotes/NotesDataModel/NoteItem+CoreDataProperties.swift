//
//  NoteItem+CoreDataProperties.swift
//  MyNotes
//
//  Created by YES on 2020/3/24.
//  Copyright © 2020 YES. All rights reserved.
//
//

import Foundation
import CoreData


extension NoteItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteItem> {
        return NSFetchRequest<NoteItem>(entityName: "NoteItem")
    }

    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var modifiedAt: Date?
    @NSManaged public var showFullView: Bool
}
