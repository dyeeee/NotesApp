//
//  NoteDetailView.swift
//  MyNotes
//
//  Created by YES on 2020/3/21.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI


struct NoteDetailView: View {
    
    //要求传入一个控制器
    @ObservedObject var noteItemController: NoteItemController
    //传入一个Item实例
    @State var noteItem: NoteItem
    //传入content字符串
    @State var content = ""
    @State private var showEditView: Bool = false
    
    var timeFormatter: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: noteItem.createdAt ?? Date())
        
        let returnString = "\(dateString)"
        return returnString
    }
    
    var body: some View {
        VStack {
            VStack(spacing:15){
                HStack {
                    VStack(spacing:1) {
                        HStack {
                            Text("Created at")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        HStack {
                            Text(timeFormatter)
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                    Button(action: {
                        self.showEditView = true
                    }) {
                        Image(systemName: "pencil.and.ellipsis.rectangle")
                            .foregroundColor(Color("TextColor"))
                            .font(.system(size: 25, weight: .medium))
                            .frame(width:40, height: 40)
                        
                    }
                        
                    .sheet(isPresented: $showEditView) {
                        NoteEditView(noteItemController: self.noteItemController, noteItem: self.noteItem, content: self.$content)}
                }.padding(.leading,5)
                    .padding(.trailing,5)
                VStack(spacing:1) {
                    multiLineTextField(text: $content,editable: false)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                
            }.padding(.horizontal,20)
            
        }.navigationBarTitle(Text(noteItem.title ?? "No title"))
            .onAppear{//在当前页面获取本item的content，作为绑定传入EditView
                self.content = self.noteItem.content ?? ""
        }.padding(.bottom,10)
    }
}




struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NoteDetailView(noteItemController: NoteItemController(), noteItem: NoteItem(createdAt: Date(), title: "DetailViewTest TITLE", content: "DetailViewTest This is content"))
    }
}
