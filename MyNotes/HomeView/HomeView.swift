//
//  HomeView.swift
//  MyNotes
//
//  Created by YES on 2020/4/14.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State var showTimer = false
    
        //借助控制器获取数据库
    @ObservedObject var toDoItemController = toDoItemControllerGLobal
    @ObservedObject var noteItemController = NoteItemController()
    @Environment(\.presentationMode) var presentationMode
    
    //@State private var timeCount = timerControllerGlobal.timeCount / 60
    
    @State var isLogged = UserDefaults.standard.isLoggedIn()
    @State var showUser = false
    
    @State var showRing = false
    
    var body: some View {
            NavigationView{
                List{
                    Text("HomeView")
                    
                    HStack {
                        Text("focus time: \(timerControllerGlobal.timeCount / 60)")
                        
                        RingView(percent: CGFloat(Double(timerControllerGlobal.timeCount / 60) / 0.6),show: $showRing)
                    }
                      
                    
                    
                        Button(action: {self.showTimer = true},
                           label: {Image(systemName: "timer")
                            .font(.largeTitle)})
                            .sheet(isPresented: $showTimer, content: {TimerHomeView()})
                        

                    
                    
                Section(header:Text("最新待办").font(.system(size: 15))){
                    
                    ForEach(toDoItemController.ToDoItemDataStore, id:\.id){todo in
                        Group{
                            if todo.done == false{ //这里可以加个日期的条件
                                Button(action: {}){
                                    ToDoRowView(toDoItemController: self.toDoItemController, toDoItem: todo, done: todo.done)}
                            }
                        }
                    }.onDelete(perform: self.toDoItemController.deleteToDoItem)

                }
                    
                    
                }.navigationBarTitle("Home")
                .navigationBarItems(trailing:
                        Button(action: {
                            self.showUser = true
                        },label: {Image(systemName: "person.crop.square").font(.largeTitle)})
                            .sheet(isPresented: $showUser, content: {ContentfulLoginView(isLogged: self.$isLogged)})
                )
                .onAppear{
                    self.showRing = true
                }
        }
    }
}

    
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
