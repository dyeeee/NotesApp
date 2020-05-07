//
//  NoteEditView.swift
//  MyNotes
//
//  Created by YES on 2020/3/28.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct NoteEditView: View {
    @ObservedObject var noteItemController: NoteItemController
    
    @State var noteItem: NoteItem
    @State private var title = ""
    @Binding var content: String
    
    @State private var isShowingAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("\(noteItem.title ?? "NO title.")", text: $title)
                    .font(.system(size: 20))
                    .padding(10)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                
                multiLineTextField(text: $content)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                
                Button(action:{
                    if !self.title.isEmpty && !self.content.isEmpty {
                        self.noteItemController.updateNoteItem(noteItemInstance: self.noteItem, title: self.title, content: self.content)
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        self.isShowingAlert = true
                    }
                }){
                    Text("Save")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .frame(width: 300, height: 50, alignment: .center)
                }.padding()
                    .frame(width: 300, height: 50, alignment: .center)
                    .background(Color(.blue))
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .shadow(color: Color(.blue).opacity(0.3), radius: 5, x: 0, y: 5)
                
                Spacer()
                
            }.onAppear { //弹出时默认显示当前item的内容
                self.title = self.noteItem.title!
                self.content = self.noteItem.content!
            }.padding()
                .navigationBarTitle("Edit Note")
                .alert(isPresented: $isShowingAlert) {
                    Alert(title: Text("Warning"), message: Text("No content"), dismissButton: .default(Text("OK!")))
            }
        }
    }
}

struct NoteEditView_Previews: PreviewProvider {
    static var previews: some View {
        NoteEditView(noteItemController: NoteItemController(), noteItem: NoteItem(createdAt: Date(), title: "title", content: "content"), content: .constant("Testing"))
    }
}
