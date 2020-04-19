//
//  ContentView.swift
//  MyNotes
//
//  Created by YES on 2020/3/20.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var newTodoItem = "good"
    
    @State var showTimer = false
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            
            
            Button(action: {self.showTimer = true},
               label: {Image(systemName: "timer")
                .font(.largeTitle)})
            .sheet(isPresented: $showTimer, content: {TimerHomeView()})
            
        }
        //.navigationBarTitle("ContentView")
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

