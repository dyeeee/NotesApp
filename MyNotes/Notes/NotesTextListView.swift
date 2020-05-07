//
//  NotesTextListView.swift
//  MyNotes
//
//  Created by YES on 2020/3/21.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct NotesTextListView: View {
    
    init() {
        // To remove only extra separators below the list:
        UITableView.appearance().tableFooterView = UIView()
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
    }
    
    //@ObservedObject var store = NotesStore()
    @State private var currentContent:String = ""
    @ObservedObject var noteItemController = noteItemControllerGlobal
    @State private var showAddView: Bool = false
    @State var showSearch = false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(noteItemController.NoteItemDataStore, id:\.self){
                    noteItem in
                    NavigationLink(destination: NoteDetailView(noteItemController: self.noteItemController, noteItem: noteItem))
                    {NoteRowView(noteItem: noteItem)}.padding(.trailing, -60.0)
                }.onDelete(perform: self.noteItemController.deleteNoteItem)
                    .padding(.vertical,-5)
                
                Image("think")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .padding()
                
                
            }.navigationBarTitle("Note List")
                .navigationBarItems(trailing: HStack(spacing:10){
                    Button(action:{self.showSearch = true},
                           label:{Image(systemName: "doc.text.magnifyingglass").scaleEffect(0.9)
                            .font(.largeTitle)}).sheet(isPresented: $showSearch, content: {NotesSearchView()})
                    Button(action: {self.showAddView = true},
                           label: {Image(systemName: "square.and.pencil")
                        .font(.largeTitle)}).offset(x: 0, y: -6)
                        .sheet(isPresented: $showAddView, content: {NoteAddView(noteItemController: self.noteItemController)})
                })
            //                .navigationBarItems(trailing:
            //                    Button(action: {self.showAddView = true},
            //                           label: {Image(systemName: "square.and.pencil")
            //                            .font(.largeTitle)})
            //                        .sheet(isPresented: $showAddView, content: {NoteAddView(noteItemController: self.noteItemController)}))
            //            .navigationBarItems(leading:
            //            Button(action:{self.showSearch = true},
            //                   label:{Image(systemName: "doc.text.magnifyingglass")
            //                    .font(.title)}).sheet(isPresented: $showSearch, content: {NotesSearchView()}))
            
            
        }.onAppear{self.noteItemController.getAllNoteItems()}
    }
}



struct NotesTextListView_Previews: PreviewProvider {
    static var previews: some View {
        NotesTextListView()
    }
}
