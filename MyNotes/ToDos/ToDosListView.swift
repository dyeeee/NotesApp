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
    @State var showUndoneOnly = true
    
    @State var test = false
    
    var body: some View {
        NavigationView{
            List{
                Section(header: Text("What to do?").font(.system(size: 15))){
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
                            .foregroundColor(.blue)
                            .font(.largeTitle)
                                .padding(.leading,5)
                        }
                        TextField("Thing", text: ($content))
                            .padding(10)
                            .background(Color(red: 247/255, green: 247/255, blue: 247/255))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .shadow(color: Color.black.opacity(0.2), radius: 2)
                    }.alert(isPresented: $emptyAlert) {
                        Alert(title: Text("Warning"), message: Text("No content"), dismissButton: .default(Text("OK!")))}
                }
                Section(header:Text("Need To Do").font(.system(size: 15))){

                        Toggle(isOn: $showUndoneOnly) {
                            Text("Hide Done Things")
                                .foregroundColor(.gray)
                    }.toggleStyle(SwitchToggleStyle())
                    ForEach(toDoItemController.ToDoItemDataStore, id:\.id){todo in
                        Group{
                            if !self.showUndoneOnly || todo.done == false{
                                Button(action: {}){
                                    ToDoRowView(toDoItemController: self.toDoItemController, toDoItem: todo, done: todo.done)}
                            }
                        }
                    }.onDelete(perform: self.toDoItemController.deleteToDoItem)

                }
                
            }.navigationBarTitle("ToDos")
                .navigationBarItems(trailing:
                    Button(action:{self.showUndoneOnly.toggle()},
                           label:{Image(systemName: self.showUndoneOnly ? "tray.2":"tray.2.fill")
                            .font(.title)}))
        }.onAppear{self.toDoItemController.getAllToDoItems()}
    }
}

struct ToDosListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDosListView()
    }
}
