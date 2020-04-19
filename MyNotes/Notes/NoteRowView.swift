//
//  NotesRowView.swift
//  MyNotes
//
//  Created by YES on 2020/3/26.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct NoteRowView: View {
    
    @ObservedObject var noteItem: NoteItem
    
    
    var timeFormatter: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd, HH:mm"
        let dateString = formatter.string(from: noteItem.modifiedAt ?? Date())
        
        let returnString = "\(dateString)"
        return returnString
    }
    
    var body: some View {
        ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 100)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        
            VStack(alignment: .leading) {
            HStack {
                Text(noteItem.title ?? "There is no title")
                    .font(.title)
                Spacer()
                Text(timeFormatter)

            }.padding(.bottom)
                Text(noteItem.content ?? "No content")
                    .font(.subheadline)
                    .lineLimit(1)
            }.padding(30)
        
        }   .padding(.trailing,64)
    }
}

struct NoteRowView_Previews: PreviewProvider {
    static var previews: some View {
        NoteRowView(noteItem: NoteItem(title: "Test", content: "My IteMy ItemMy ItemMy ItemMy ItemMy ItemMy ItemMy ItemMy Itemm"))
    }
}
