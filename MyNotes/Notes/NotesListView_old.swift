//
//  NotesList.swift
//  MyNotes
//
//  Created by YES on 2020/3/20.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

let screen = UIScreen.main.bounds  //以后可以调用视图的尺寸信息，不用像素值

struct NotesListView_old: View {
    @State var notes = NotesData   // 用的是实际的数据
    @State var active = false
    @State var activeIndex = -1
    @State var activeView = CGSize.zero
    
    @State var tmpContent = "ContentContentContentContentContentContentContentContentContentContentContent"
    
    @State var addNote = false
    
    //借助控制器获取数据库
    @ObservedObject var noteItemController = NoteItemController()
    
    var body: some View {
        ZStack {
            Color.black.opacity(Double(self.activeView.height / 500))
                .animation(.linear)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Text("Notes").font(.largeTitle).bold()
                        Spacer()
                        
                        Button(action:{self.addNote.toggle()}) {
                            Image(systemName: "square.and.pencil")
                                .renderingMode(.original)
                                .font(.system(size: 25, weight: .medium))
                                .frame(width:45, height: 45)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                        }
                        .sheet(isPresented: $addNote, content:{NoteAddView(noteItemController: self.noteItemController)})
                    }.blur(radius: active ? 30 : 0)//卡片激活时，标题模糊
                    .padding(.top,30)
                    .padding(.leading,30)
                    .padding(.trailing,30)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 4)
                    
                    // 使用了数组索引
                    ForEach(notes.indices, id: \.self) {
                        index in
                        GeometryReader {
                            gemotry in
                            NoteView(
                                show: self.$notes[index].show,
                                note: self.notes[index],
                                active: self.$active,
                                index: index,
                                activeIndex: self.$activeIndex,
                                activeView: self.$activeView,
                                text: self.$tmpContent)  //在GeometrReader中，添加self
                            .offset(y: self.notes[index].show ? -gemotry.frame(in: .global).minY : 0)  //如果show，就移动 -gemotry.xxx的距离，抵消当前gemotry.xx.minY
                            .opacity(self.activeIndex != index && self.active ? 0 : 1)
                            .scaleEffect(self.activeIndex != index && self.active ? 0.5 : 1)
                            .offset(x: self.activeIndex != index && self.active ? screen.width : 0)
                        }
                        .frame(height: 180)
                        .frame(maxWidth: self.notes[index].show ? .infinity : screen.width - 60)
                        .zIndex(self.notes[index].show ? 1 : 0) //show时为z轴索引为1，在0的上面
                    }
                }
                .frame(width: screen.width)  //ScrollView的宽度
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                // 卡片激活时，隐藏状态栏
                .statusBar(hidden: active ? true : false)
                .animation(.linear)
            }
        }
    }
}


struct NotesListView_old_Previews: PreviewProvider {
    static var previews: some View {
            NotesListView_old()
    }
}


struct NoteView: View {
    @Binding var show: Bool
    var note: Note
    
    @Binding var active: Bool // 状态栏显示与否的绑定
    
    var index: Int

    @Binding var activeIndex: Int
    
    // 卡片展开时的手势拖动
    @Binding var activeView: CGSize
    @State var showDetail = false
    
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10.0) {
                        HStack{
                        Text("Content")
                            .font(.title).bold()
                        Spacer()
                        Button(action:{self.showDetail.toggle()}) {
                            Image(systemName: "pencil.and.ellipsis.rectangle")
                                .renderingMode(.original)
                                .font(.system(size: 16, weight: .medium))
                                .frame(width:36, height: 36)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                        }
                            
                    }
                        HStack {
                            Text(text)
                            Spacer()
                        }

                    }
                        .padding(30)
                        .offset(y : show ? 240 : 0)
                        //不show的时候文本藏在上面的VStack下
                        .frame(maxWidth: show ? .infinity : screen.width - 60, maxHeight: show ? .infinity : 200, alignment: .top)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                        .opacity(show ? 1 : 0)
                    
                    
                    VStack {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 8.0) {
                                Text(note.title)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color.white)
                                Text(note.subtitle)
                                    .foregroundColor(Color.white.opacity(0.7))
                                
                            }
                            Spacer()
                            
                            ZStack {
                                VStack {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 36, height: 36)
                                .background(Color.black)
                                .clipShape(Circle())
                                .opacity(show ? 1 : 0)
                            }
                        }
                        Spacer()
                    }
                    .padding(show ? 30 : 20)
                    .padding(.top, show ? 30 : 0)
                    .frame(maxWidth: show ? .infinity : screen.width - 60 , maxHeight: show ? 240 : 180)
                    .background(Color(note.color))
                    .clipShape(RoundedRectangle(cornerRadius: show ? 10 :30, style: .continuous))
                    .shadow(color: Color(note.color).opacity(0.3), radius: 20, x: 0, y: 20)
                    .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
                    .gesture(
                        show ?
                        DragGesture()
                            .onChanged{
                                value in
                                // 保证手势拖动值小于 200，否则结束代码；执行self.activeView = value.translation, 让值保持为translation
                                guard value.translation.height < 100 else{ return }
                                
                                // 保证只能向下拖动
                                guard value.translation.height > 0 else{ return }
                                self.activeView = value.translation
                            }
                            .onEnded{
                                value in
                                if self.activeView.height > 50 {
                                    self.show = false
                                    self.active = false
                                    self.activeIndex = -1
                                }
                                self.activeView = .zero
                            }
                        : nil  //show时开启手势，否则无
                    )
                    .onTapGesture {
                        self.show.toggle()
                        self.active.toggle()
                        
                        // 获取当前活动状态的卡片索引
                        if self.show {
                            self.activeIndex = self.index
                        }
                        else{
                            self.activeIndex = -1
                        }
                    }
                }
                .frame(height: show ? screen.height : 280)
                .scaleEffect(1 - self.activeView.height / 1000 )
                .rotation3DEffect(Angle(degrees: Double(self.activeView.height / 10)), axis: (x: 0, y: 10, z: 0))
                .hueRotation(Angle(degrees: Double(self.activeView.height)))
                .edgesIgnoringSafeArea(.all)
                .gesture(
                    show ?
                        DragGesture()
                            .onChanged{
                                value in
                                guard value.translation.height < 100 else{ return }
                                // 保证只能向下拖动
                                guard value.translation.height > 0 else{ return }
                                self.activeView = value.translation

                        }
                        .onEnded{
                            value in
                            if self.activeView.height > 50 {
                                self.show = false
                                self.active = false
                                self.activeIndex = -1
                            }
                            self.activeView = .zero
                        }
                        : nil  //show时开启手势，否则无
                )
                .animation(.spring(response: 0.5, dampingFraction: 0.9, blendDuration: 0))
    }
}

