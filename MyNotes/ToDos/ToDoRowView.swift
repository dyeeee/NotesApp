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
    var colors = [#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)]
    
    var body: some View {
        VStack {
                VStack(alignment: .leading) {
                    HStack {
                        HStack(spacing:0){
                        Button(action:{
                            self.done.toggle()
                            self.toDoItemController.updateToDoItem(ToDoItemInstance: self.toDoItem, done: self.done)
                            print(self.toDoItem)
                        }){
                            Image(systemName: done ? "checkmark.square.fill":"square")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(done ? .white: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                        }.padding(.trailing,15)
                        
                        
                        Text(toDoItem.content ?? "There is no content")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(done ? .white: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                            .strikethrough(done ? true:false, color: Color.black)
                            .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
                            
                        Spacer()
                        Text(done ? "done" : countInterval(date: toDoItem.createdAt ?? Date()))
                            .font(.system(size: 13))
                            .foregroundColor(done ? .white: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                            .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
                        
                    }
                .padding(10)
                    .frame(minHeight:50)
                        .background(self.done ? Color(red: 200/255, green: 200/255, blue: 200/255):Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .shadow(color: done ? Color.black.opacity(0.2
                            ):Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)).opacity(0.8), radius: 3)
                    .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
                    
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
                result = "\(-Int(hour))hours ago"}
        }else{
            result = "\(-Int(day))days ago"
        }
        
        return result
    }
    
}

struct ToDoRowView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoRowView(toDoItemController: ToDoItemController(), toDoItem: ToDoItem(content: "content"))
    }
}
