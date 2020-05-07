//
//  ToDosListView.swift
//  MyNotes
//
//  Created by YES on 2020/3/27.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI
import UIKit

struct ToDosListView: View {
    
    let generator = UINotificationFeedbackGenerator()
    
    init() {
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
    }
    
    @ObservedObject var toDoItemController = toDoItemControllerGLobal
    @Environment(\.presentationMode) var presentationMode
    
    @State private var content = ""
    @State private var emptyAlert = false
    @State var showUndoneOnly = UserDefaults.standard.bool(forKey: "showUndoneOnly")
    @State var showSearch = false
    @State var showDone = false
    
    var body: some View {
        ZStack {
            NavigationView{
                List(){
                    Section(header: Text("What to do?").font(.system(size: 15)).foregroundColor(Color(.systemGray))){
                        HStack{
                            Button(action:{
                                if !self.content.isEmpty{
                                    self.toDoItemController.createToDoItem(content: self.content)
                                    self.generator.notificationOccurred(.success)
                                    self.content = ""
                                    self.presentationMode.wrappedValue.dismiss()
                                }else{
                                    self.generator.notificationOccurred(.warning)
                                    self.emptyAlert = true
                                }
                            }){
                                Image(systemName: "plus.app")
                                    .foregroundColor(Color(.systemIndigo))
                                    .font(.largeTitle)
                                    .padding(.leading,5)
                            }
                            TextField("Thing", text: ($content))
                                .padding(10)
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .shadow(color: Color("ShadowColor"), radius: 2)
                        }.padding(.vertical,10)
                            .alert(isPresented: $emptyAlert) {
                                Alert(title: Text("Warning"), message: Text("No content"), dismissButton: .default(Text("OK!")))}
                    }
                    Section(header:Text("Things to do.").font(.system(size: 15)).foregroundColor(Color(.systemGray)))
                    {
                        Toggle(isOn: $showUndoneOnly) {
                            Text("Hide Done Things")
                                .foregroundColor(.gray)
                        }.toggleStyle(SwitchToggleStyle())
                        
                        ForEach(toDoItemController.ToDoItemDataStore, id:\.id){todo in
                            Group{
                                if !self.showUndoneOnly || todo.done == false{
                                    Button(action: {}){
                                        ToDoRowView(toDoItemController: self.toDoItemController, toDoItem: todo, done: todo.done,showDone: self.$showDone)}
                                }
                            }
                        }.onDelete(perform: self.toDoItemController.deleteToDoItem)
                            .padding(.vertical,-3)
                        
                    }
                    
                    Image("things")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .padding()
                    
                }.navigationBarTitle("ToDos")
                    .navigationBarItems(trailing:
                        Button(action:{self.showSearch = true},
                               label:{Image(systemName: "doc.text.magnifyingglass")
                                .font(.largeTitle)}).sheet(isPresented: $showSearch, content: {ToDosSearchView()}))
                
            }.onAppear{self.toDoItemController.getAllToDoItems()
                UserDefaults.standard.set(self.showUndoneOnly,forKey: "showUndoneOnly")
            }
            
            if showDone {
                LottieToDoDoneView()
            }
        }
    }
}

struct ToDosListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ToDosListView()
                .environment(\.colorScheme, .light)
            
            ToDosListView()
                .environment(\.colorScheme, .dark)
        }
    }
}
