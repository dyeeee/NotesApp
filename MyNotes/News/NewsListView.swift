//
//  NewsListView.swift
//  MyNotes
//
//  Created by YES on 2020/4/20.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct NewsListView: View {

    
    @ObservedObject var store = NewsStore()
    
    var body: some View {
        NavigationView(){
            List(store.newsStore) { item in
                NewsRowView(news: item)
            }
            .onAppear(perform: { self.store.fetch() })
            .navigationBarTitle(Text("Subscribe"))
            .navigationBarItems(trailing: Button(action:{self.store.fetch()}){
                Image(systemName: "exclamationmark.square")
                    .font(.largeTitle)
            })
        }
    }
}

struct NewsListView_Previews: PreviewProvider {
    static var previews: some View {
        NewsListView()
    }
}
