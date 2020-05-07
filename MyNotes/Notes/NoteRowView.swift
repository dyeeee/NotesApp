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
                .fill(Color("RowAnyColor"))
                .frame(width: UIScreen.main.bounds.width - 32, height: 100)
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 3)
            
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(noteItem.title ?? "There is no title")
                            .font(.title)
                            .foregroundColor(Color("TextColor"))
                            .lineLimit(1)
                        Spacer()
                        
                    }.padding(.bottom)
                    Text(noteItem.content ?? "No content")
                        .font(.subheadline)
                        .lineLimit(1)
                }.padding(20)
                
                VStack(spacing:1) {
                    HStack {
                        Spacer()
                        Text("Modified at")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                        
                    }
                    HStack {
                        Spacer()
                        Text(timeFormatter)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                }.padding(.trailing,20)
            }
            
        }   .padding(.trailing,64)
    }
}

struct NoteRowView_Previews: PreviewProvider {
    static var previews: some View {
        NoteRowView(noteItem: NoteItem(createdAt: Date(), title: "Test", content: "My IteMy ItemMy ItemMy ItemMy ItemMy ItemMy ItemMy ItemMy Itemm"))
    }
}
