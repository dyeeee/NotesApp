//
//  RegisterView.swift
//  MyNotes
//
//  Created by YES on 2020/4/14.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    
    @State private var username = ""
    @State private var pass = ""
    @ObservedObject var tool = MincloudTools()
    @Binding var show:Bool
    
    var body: some View {
        VStack {
            Text("Register")
            TextField("username", text: ($username))
                .padding(10)
                .background(Color(red: 247/255, green: 247/255, blue: 247/255))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(color: Color.black.opacity(0.2), radius: 2)
            TextField("passward", text: ($pass))
                .padding(10)
                .background(Color(red: 247/255, green: 247/255, blue: 247/255))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(color: Color.black.opacity(0.2), radius: 2)
            Button(action: {
                self.tool.userregister(name: self.username, pass: self.pass)
                self.show.toggle()
            }) {
            Text("注册")
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(show: .constant(true))
    }
}
