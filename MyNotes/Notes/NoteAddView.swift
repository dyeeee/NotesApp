//
//  NoteAddView.swift
//  MyNotes
//
//  Created by YES on 2020/3/25.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct NoteAddView: View {
    @ObservedObject var noteItemController: NoteItemController
    
    @State private var title = ""
    @State private var content = "Write something?"
    @State private var isShowingAlert = false
    @State private var contentInputTips = "Write something?"
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            VStack(spacing:20){
                VStack(spacing:1) {
                    HStack {
                        Text("Title")
                            .font(.system(size: 25))
                        Spacer()
                    }
                    TextField("Note title", text: ($title))
                    .padding(10)
                        .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                }
                VStack(spacing:1) {
                    HStack {
                        Text("Content")
                            .font(.system(size: 25))
                        Spacer()
                    }
                    
                    multiLineTextField(text: $content)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                Spacer()
                
                Button(action:{
                    //非空则保存
                    if !self.title.isEmpty && !self.content.isEmpty{
                        self.noteItemController.createNoteItem(title: self.title, content: self.content)
                        //重置
                        self.title = ""
                        self.content = ""
                        //?
                        self.presentationMode.wrappedValue.dismiss()
                    }else {
                        self.isShowingAlert = true
                    }
                }){
                    Text("Add Note")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                    .frame(width: 300, height: 50, alignment: .center)
                }
            .padding()
                    .frame(width: 300, height: 50, alignment: .center)
                    .background(Color(.blue))
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .shadow(color: Color(.blue).opacity(0.3), radius: 5, x: 0, y: 5)
            }.padding()
            .navigationBarTitle("Add a Note", displayMode: .automatic)
            .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Warning"), message: Text("好像还没写完"), dismissButton: .default(Text("知道了")))
            }
        }
    }
}

struct NoteAddView_Previews: PreviewProvider {
    static var previews: some View {
        NoteAddView(noteItemController: NoteItemController())
    }
}
