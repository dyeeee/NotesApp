//
//  NotesStore.swift
//  MyNotes
//
//  Created by YES on 2020/3/21.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI
import Combine

class NotesStore: ObservableObject{
    @Published var notes: [tmpNote] = tmpNotesData
}



//数据模型（结构体）
struct tmpNote: Identifiable {
    var id = UUID()
    var image:String
    var title:String
    var subtitle:String
    var content:String
    var date:Date
}

let tmpNotesData = [tmpNote(image: "Card1", title: "SwiftUI Advanced", subtitle: "subtitle1",content: "Take your SwiftUI app to the App Store with advanced techniques like API data, packages and CMS.", date: Date()),
                    tmpNote(image: "Card2", title: "Note 3", subtitle: "subtitle2",content: "Design and animate a high converting landing page with advanced interactions, payments and CMS.", date: Date()),
                    tmpNote(image: "Card1", title: "Note 3", subtitle: "subtitle3",content: "Quickly prototype advanced animations and interactions for mobile and Web.", date: Date())]


struct Note: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var content: String
    var color: UIColor
    var show: Bool   //每张卡的状态
}

var NotesData = [
    Note(title: "Note 1", subtitle: "My note 1", content: "This is the content of note1", color: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), show: false)]
//,
//    Note(title: "Note 2", subtitle: "My note 2", content: "This is the content of note2", color: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), show: false),
//    Note(title: "Note 3", subtitle: "My note 3", content: "This is the content of note1", color: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), show: false),
//    Note(title: "Note 3", subtitle: "My note 4", content: "This is the content of note1", color: #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), show: false),
//    Note(title: "Note 3", subtitle: "My note 5", content: "This is the content of note1", color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), show: false)]
