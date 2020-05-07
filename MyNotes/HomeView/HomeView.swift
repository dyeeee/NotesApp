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
                Button(action:{}){
                    HStack(spacing: 20) {
                        RingView(color1: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), color2: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), width: 75, height: 75, percent: CGFloat(Double(timerControllerGlobal.dailyTimeCount / 60)),show: $showRing)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Focused \(timerControllerGlobal.timeCount / 60) mins Totally")
                                .font(.system(size: 15))
                            Text("Focused \(timerControllerGlobal.dailyTimeCount / 60) mins Today")
                                .font(.system(size: 17))
                                .bold()
                            Button(action:{
                                self.showTimer.toggle()
                            }){
                                HStack {
                                    Text("Start Focus")
                                        .foregroundColor(.white)
                                        .font(.system(size: 17))
                                    Image(systemName: "timer")
                                        .foregroundColor(.white)
                                }.padding(.horizontal,20)
                                
                            }.sheet(isPresented: $showTimer, content: {TimerHomeView()})
                                .frame(height: 40, alignment: .leading)
                                .background(Color(.systemGreen))
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .shadow(color: Color("ShadowColor"), radius: 2, x: 0, y: 0)
                                .padding(.top,5)
                        }
                        Spacer()
                    }
                    .frame(maxWidth:screen.width)
                    .frame(height:120)
                    .padding(10)
                    .padding(.horizontal,10)
                    .background(Color("RowAnyColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: Color("ShadowColor"), radius: 3, x: 0, y: 0)
                    .padding(.bottom,5)
                }.sheet(isPresented: $showTimer, content: {TimerHomeView()})
                
                
                
                Section(header:Text("ToDos").font(.system(size: 15)).foregroundColor(Color(.systemGray))){
                    
                    ForEach(toDoItemController.ToDoItemDataStore, id:\.id){todo in
                        Group{
                            if todo.done == false{ //这里可以加个日期的条件
                                Button(action: {}){
                                    ToDoRowView(toDoItemController: self.toDoItemController, toDoItem: todo, done: todo.done, showDone: .constant(false))}
                            }
                        }
                    }.padding(.bottom,-6)
                    
                }
                
                Image("time")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .padding()
                
                
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
            .environment(\.colorScheme, .dark)
    }
}
