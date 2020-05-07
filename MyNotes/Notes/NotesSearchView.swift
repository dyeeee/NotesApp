//
//  NotesSearchView.swift
//  MyNotes
//
//  Created by YES on 2020/4/22.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct NotesSearchView: View {
    let generator = UINotificationFeedbackGenerator()
    
    init() {
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
    }
    
    @ObservedObject var noteItemController = noteItemControllerGlobal
    //@Environment(\.presentationMode) var presentationMode
    
    @State private var emptyAlert = false
    //    @State var showUndoneOnly = true
    
    @State private var match:String  = ""
    @State private var searchText = ""
    @State private var searchPredicate: NSPredicate? = NSPredicate(format: "name contains[c] %@", "")
    @State var refresh: Bool = false
    

    
    @State private var currentContent:String = ""
    @State private var showAddView: Bool = false
    
    
    var body: some View {
        NavigationView{
            List{
                Section(header: Text("What to do?").font(.system(size: 15)).foregroundColor(Color(.systemGray))){
                    HStack{
                        Button(action:{
                            if !self.match.isEmpty{
                                self.noteItemController.searchNoteItems(contain: self.match)
                                self.generator.notificationOccurred(.success)
                                self.match = ""
                                //self.presentationMode.wrappedValue.dismiss()
                                self.refresh.toggle()
                            }else{
                                self.generator.notificationOccurred(.warning)
                                self.emptyAlert = true
                            }
                        }){
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(.systemIndigo))
                                .font(.largeTitle)
                                .padding(.leading,5)
                        }
                        TextField("Search", text: ($match))
                            .padding(10)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .shadow(color: Color("ShadowColor"), radius: 2)
                    }.padding(.vertical,10)
                        .alert(isPresented: $emptyAlert) {
                            Alert(title: Text("Warning"), message: Text("No content."), dismissButton: .default(Text("OK!")))}
                }
                Section(header:Text("Results").font(.system(size: 15)).foregroundColor(Color(.systemGray))){
                    if refresh{
                        ForEach(noteItemController.NoteItemDataStore, id:\.id){
                            note in
                            NoteSearchResultRowView(noteItem: note, input: self.$match)
                        }.onDelete(perform: self.noteItemController.deleteNoteItem)
                            .padding(.vertical,-3)
                    }
                }
                
                Image("find")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .padding()
                
            }.navigationBarTitle("Search Your ToDos")
        }
    }
}

struct NotesSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NotesSearchView()
    }
}
