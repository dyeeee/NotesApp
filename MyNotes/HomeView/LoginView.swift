//
//  LoginView.swift
//  MyNotes
//
//  Created by YES on 2020/4/14.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI


struct LoginVieiw: View {
    @State private var username = ""
    @State private var pass = ""
    @ObservedObject var tool = MincloudTools()
    @State var showRegister = false
    
    @Binding var isLogged:Bool
    @State private var loggedUsername = UserDefaults.standard.string(forKey: "username")
    
    var body: some View {
        ZStack {
            if isLogged {
                VStack(spacing:20) {
                    Text("Userinfo")
                    Text(loggedUsername ?? "unknow")
                        .padding(10)
                        .background(Color(red: 247/255, green: 247/255, blue: 247/255))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .shadow(color: Color.black.opacity(0.2), radius: 2)

                    Button(action: {
                        self.tool.userUpload()
                    }) {
                        Text("上传本地数据")
                    }
                    
                    Button(action: {
                                           self.tool.userDownload()
                                }) {
                                           Text("同步云端数据")
                                       }
                    

                    
                    Button(action: {
                            UserDefaults.standard.setLoggedIn(value: false)
                                self.isLogged = UserDefaults.standard.isLoggedIn()
                        }) {
                            Text("登出")
                        }
                    
                    
                }
                
            }
            
            if !isLogged {
                VStack {
                    Text("Login")
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
                    
                    HStack {
                        Button(action: {
                            self.tool.userlogin(name: self.username, pass: self.pass)
                            
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                self.isLogged = UserDefaults.standard.isLoggedIn()
                                                           print(self.isLogged)
                                self.loggedUsername = self.username
                            }
                           
                        }) {
                            Text("登录")
                        }
                        
                        Button(action: {
                            self.showRegister = true
                        },label: {Text("注册")})
                            .sheet(isPresented: $showRegister, content: {RegisterView(show: self.$showRegister)})
                    }
                }
            }
        }
    }
    
}

struct LoginVieiw_Previews: PreviewProvider {
    static var previews: some View {
        LoginVieiw(isLogged: .constant(true))
    }
}
