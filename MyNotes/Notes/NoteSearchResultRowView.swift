//
//  NoteSearchResultRowView.swift
//  MyNotes
//
//  Created by YES on 2020/4/22.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct NoteSearchResultRowView: View {
    
    @ObservedObject var noteItem: NoteItem
    @Binding var input: String
    @State private var match = false
    
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
            
        }
        .padding(.trailing,64)
        .onAppear{
            if self.noteItem.content! == self.input{self.match = true}}
    }
}

//struct NoteSearchResultRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteSearchResultRowView()
//    }
//}
