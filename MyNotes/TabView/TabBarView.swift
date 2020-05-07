//
//  TabBarView.swift
//  MyNotes
//
//  Created by YES on 2020/3/20.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection){
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
            }
            .tag(0)
            
            ToDosListView()
            .tabItem {
                VStack {
                    Image(systemName: "flag")
                    Text("Todo")
                }
            }
            .tag(1)
            
            
            NotesTextListView()
            .tabItem {
                VStack {
                    Image(systemName: "pencil.and.outline")
                    Text("Note")
                }
            }
            .tag(3)
            
            NotesCardListView()
            .tabItem {
                VStack {
                    Image(systemName: "creditcard")
                    Text("NoteCard")
                }
            }
            .tag(4)
            
            NewsListView()
            .tabItem {
                VStack {
                    Image(systemName: "cube.box")
                    Text("Subscribe")
                }
            }
            .tag(5)
            
        }
        //.edgesIgnoringSafeArea(.top)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
