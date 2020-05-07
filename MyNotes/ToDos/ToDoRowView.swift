//
//  ToDoRowView.swift
//  MyNotes
//
//  Created by YES on 2020/3/27.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct ToDoRowView: View {
    
    @ObservedObject var toDoItemController: ToDoItemController
    @ObservedObject var toDoItem: ToDoItem
    
    
    @State var done:Bool = false
    @Binding var showDone:Bool
    
    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        HStack(spacing:0){
                            Button(action:{
                                self.done.toggle()
                                self.toDoItemController.updateToDoItem(ToDoItemInstance: self.toDoItem, done: self.done)
                                print(self.toDoItem)
                                if self.done{
                                    self.showDone = true
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                                        self.showDone = false
                                    }
                                }
                            }){
                                Image(systemName: done ? "checkmark.square.fill":"square")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(done ? Color(.systemIndigo): Color(.systemIndigo))
                            }.padding(.trailing,15)
                            
                            
                            Text(toDoItem.content ?? "There is no content")
                                .font(.system(size: 18))
                                .foregroundColor(done ? Color(.systemGray2): Color("TextColor"))
                                .strikethrough(done ? true:false, color: Color.black)
                                .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
                            
                            Spacer()
                            Text(done ? "done" : countInterval(date: toDoItem.createdAt ?? Date()))
                                .font(.system(size: 13))
                                .foregroundColor(done ? Color(.systemGray2): Color("TextColor"))
                                .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
                            
                        }
                        .padding(10)
                        .frame(minHeight:50)
                        .background(self.done ? Color("RowDoneColor"):Color("RowAnyColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .shadow(color: Color("ShadowColor"), radius: 2)
                        .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
                        
                    }
                }
            }
        }}
    
    func countInterval(date:Date) -> String {
        let day = (date.timeIntervalSinceNow) / 86400
        var result:String
        let hour:Double
        
        if Int(day) == 0{
            hour = (date.timeIntervalSinceNow) / 3600
            if Int(hour) == 0{
                result = "Just"
            }
            else{
                result = "\(-Int(hour)) hours ago"}
        }else{
            result = "\(-Int(day)) days ago"
        }
        
        return result
    }
    
}

struct ToDoRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ToDoRowView(toDoItemController: ToDoItemController(), toDoItem: ToDoItem(createdAt: Date(), content: "content"), showDone: .constant(false))
                .environment(\.colorScheme, .light)
            
            ToDoRowView(toDoItemController: ToDoItemController(), toDoItem: ToDoItem(createdAt: Date(), content: "content"), showDone: .constant(false))
                .environment(\.colorScheme, .dark)
        }
    }
}
