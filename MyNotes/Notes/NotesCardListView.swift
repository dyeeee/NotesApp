//
//  NotesListView.swift
//  MyNotes
//
//  Created by YES on 2020/3/25.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct NotesCardListView: View {
    //@State var notes = NotesData   // 用的是实际的数据
    
    @State var active = false
    @State var activeIndex = -1
    @State var activeView = CGSize.zero
    
    @State var addNote = false
    
    //借助控制器获取数据库
    @ObservedObject var noteItemController = noteItemControllerGlobal
    @Environment(\.presentationMode) var presentationMode
    
    @State var selected = 0
    
    //@State var indices = noteItemController.NoteItemDataStore.indices

    var body: some View {
        
        ZStack {
            Color.black.opacity(Double(self.activeView.height / 500))
                .animation(.linear)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Text("NoteCard List")
                            .font(.largeTitle)
                            .bold()
                            .offset(y: 15)
                        Spacer()
                        
                        Button(action:{
                            self.addNote.toggle()}) {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(.blue)
                                    .font(.largeTitle)
                                    .frame(width:45, height: 45)
                                    .background(Color.white)
                                    //.shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                                    .offset(x: 20, y: -31)
                        }
                        .sheet(isPresented: $addNote, content:{NoteAddView(noteItemController: self.noteItemController)})
                    }.blur(radius: active ? 30 : 0)//卡片激活时，标题模糊
                        .padding(.top,30)
                        .padding(.leading,20)
                        .padding(.trailing,30)
                        //.shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 4)
                    
                    // 使用了数组索引
                    ForEach(noteItemController.NoteItemDataStore.indices, id: \.self) {
                        index in
                        GeometryReader {
                            gemotry in
                            NoteCardView(noteItemController: self.noteItemController,
                                         noteItem: self.noteItemController.NoteItemDataStore[index],
                                         showFullView: self.$noteItemController.NoteItemDataStore[index].showFullView,
                                         active: self.$active,
                                         index: index,
                                         activeIndex: self.$activeIndex,
                                         activeView: self.$activeView,  colorOfRowIndex: index)  //在GeometrReader中，添加self
                                .offset(y: self.noteItemController.NoteItemDataStore[index].showFullView ? -gemotry.frame(in: .global).minY : 0)  //如果show，就移动 -gemotry.xxx的距离，抵消当前gemotry.xx.minY
                                .opacity(self.activeIndex != index && self.active ? 0 : 1)
                                .scaleEffect(self.activeIndex != index && self.active ? 0.5 : 1)
                                .offset(x: self.activeIndex != index && self.active ? screen.width : 0)
                        }
                        .frame(height: 180)
                        .frame(maxWidth: self.noteItemController.NoteItemDataStore[index].showFullView ? .infinity : screen.width - 60)
                            .zIndex(self.noteItemController.NoteItemDataStore[index].showFullView ? 1 : 0) //show时为z轴索引为1，在0的上面
                    }
                }
                    .frame(width: screen.width)  //ScrollView的宽度
                    .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                    // 卡片激活时，隐藏状态栏
                    .statusBar(hidden: active ? true : false)
                    .animation(.linear)
//                .onAppear{
//                    self.noteItemController.
//                    self.presentationMode.wrappedValue.dismiss()
//               }
            }
        }
    }
}

struct NotesCardListView_Previews: PreviewProvider {
    static var previews: some View {
        NotesCardListView()
    }
}


struct Topbar : View {
    @Binding var selected : Int
    
    var body : some View{
        HStack{
            Button(action: {
                self.selected = 0
            }) {
                Image("msg")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(.vertical,12)
                    .padding(.horizontal,30)
                    .background(self.selected == 0 ? Color.white : Color.clear)
                    .clipShape(Capsule())
            }
            .foregroundColor(self.selected == 0 ? .pink : .gray)
            Button(action: {
                self.selected = 1
            }) {
                Image("acc")
                .resizable()
                .frame(width: 25, height: 25)
                .padding(.vertical,12)
                .padding(.horizontal,30)
                .background(self.selected == 1 ? Color.white : Color.clear)
                .clipShape(Capsule())
            }
            .foregroundColor(self.selected == 1 ? .pink : .gray)
            }.padding(8)
            .background(Color(.red))
            .clipShape(Capsule())
            .animation(.default)
    }
}
