//
//  ContentfulLogin.swift
//  MyNotes
//
//  Created by YES on 2020/4/15.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct ContentfulLoginView: View {
    
    @State private var username = ""
    @State private var pass = ""
    @ObservedObject var tool = MincloudTools()
    @State var showRegister = false
    
    @Binding var isLogged:Bool
    @State private var loggedUsername = UserDefaults.standard.string(forKey: "username")
    
    @State var loginError:Bool = false
    @State var isLoading = false
    
    @State var isSyncing = false
    
    func login(){
        self.tool.userlogin(name: self.username, pass: self.pass)
        self.isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.isLoading = false
            self.isLogged = UserDefaults.standard.isLoggedIn()
            if !self.isLogged{
                self.loginError = true
            }
            //print(self.isLogged)
            self.loggedUsername = self.username
        }
    }
    func logout() {
        self.isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.isLoading = false
            UserDefaults.standard.setLoggedIn(value: false)
            self.isLogged = UserDefaults.standard.isLoggedIn()
        }
    }
    
    func download() {
        self.isSyncing = true
        self.tool.userDownload()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.isSyncing = false
        }
    }
    
    func upload() {
        self.isSyncing = true
        self.tool.userUpload()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.isSyncing = false
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            if isLogged {
                ZStack(alignment: .top) {
                    Color.black
                        .edgesIgnoringSafeArea(.all)
                    
                    Color("background2")
                        .edgesIgnoringSafeArea(.bottom)
                    
                    VStack(alignment: .center, spacing: 20) {
                        
                        Text("User Information")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 40)
                            .multilineTextAlignment(.center)
                        
                        VStack(spacing: 5) {
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    Image(systemName: "person.crop.circle.fill")
                                        .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                                        .frame(width: 30, height: 30)
                                        .background(Color("background3"))
                                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                        .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.1), radius: 5, x: 0, y: 5)
                                    Text("Username")
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                                Text(loggedUsername ?? "unknow")
                                    .font(.system(size: 18))
                                    .padding(.leading,55)
                                
                            }
                            .padding(.leading)
                            
                            Divider()
                                .padding(.leading, 60)
                                .padding(.trailing, 20)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Image(systemName: "timer")
                                        .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                                        .frame(width: 30, height: 30)
                                        .background(Color("background3"))
                                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                        .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.1), radius: 5, x: 0, y: 5)
                                    Text("Total Focused Time")
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                                Text("\(timerControllerGlobal.timeCount / 60)"  )
                                    .font(.system(size: 18))
                                    .padding(.leading,55)
                                
                            }
                            .padding(.leading)
                            
                            Divider()
                                .padding(.leading, 60)
                                .padding(.trailing, 20)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Image(systemName: "sum")
                                        .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                                        .frame(width: 30, height: 30)
                                        .background(Color("background3"))
                                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                        .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.1), radius: 5, x: 0, y: 5)
                                    Text("Cloud ToDos")
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                                Text("\(UserDefaults.standard.integer(forKey:"totalToDos"))" )
                                    .font(.system(size: 18))
                                    .padding(.leading,55)
                                
                            }
                            .padding(.leading)
                            
                            Divider()
                                .padding(.leading, 60)
                                .padding(.trailing, 20)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Image(systemName: "sum")
                                        .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                                        .frame(width: 30, height: 30)
                                        .background(Color("background3"))
                                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                        .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.1), radius: 5, x: 0, y: 5)
                                    Text("Cloud Notes")
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                                Text("\(UserDefaults.standard.integer(forKey:"totalNotes"))" )
                                    .font(.system(size: 18))
                                    .padding(.leading,55)
                                
                            }
                            .padding(.leading)
                            
                            Divider()
                                .padding(.leading, 60)
                                .padding(.trailing, 20)
                            
                            
                        }
                        .frame(width: 343, height: 300)
                        .background(BlurView(style: .systemMaterial))
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.2), radius: 20, x: 0, y: 20)
                        
                        
                        HStack {
                            Button(action: {
                                self.upload()
                            }) {
                                Text("Upload".uppercased())
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .padding(12)
                            .frame(width: 160)
                                
                            .background(Color(.systemTeal))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.2), radius: 20, x: 0, y: 20)
                            
                            Spacer()
                            
                            Button(action: {
                                self.download()
                            }) {
                                Text("Download".uppercased())
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .padding(12)
                            .frame(width: 160)
                            .background(Color(.systemTeal))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.2), radius: 20, x: 0, y: 20)
                            
                            
                        }
                        .padding(.horizontal, 30)
                        .frame(maxWidth: 400)
                        
                        
                        HStack {
                            Button(action: {
                                self.logout()
                            }) {
                                Text("Log out".uppercased())
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .padding(12)
                            .frame(width: 160)
                                
                            .background(Color(.systemRed))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.2), radius: 20, x: 0, y: 20)
                            
                        }
                        .padding(.horizontal, 30)
                        .frame(maxWidth: 400)
                        Spacer()
                        
                        
                        
                        //
                        //                        Image("learn")
                        //                            .resizable()
                        //                            .aspectRatio(contentMode: .fill)
                        //                            .scaleEffect(0.7)
                        //                            .offset(y:-50)
                        
                    }.frame(maxWidth:screen.width,maxHeight: screen.height)
                        .background(Color("LogColor"))
                        .edgesIgnoringSafeArea(.bottom)
                }
                
            }
            
            if !isLogged {
                ZStack(alignment: .top) {
                    Color.black
                        .edgesIgnoringSafeArea(.all)
                    
                    Color("background2")
                        .edgesIgnoringSafeArea(.bottom)
                    
                    VStack(spacing:30) {
                        Text("Take Your\nToDos and Notes\nGracefully")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 40)
                            .multilineTextAlignment(.center)
                        
                        VStack {
                            HStack {
                                Image(systemName: "person.crop.circle.fill")
                                    .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                                    .frame(width: 44, height: 44)
                                    .background(Color("background3"))
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.1), radius: 5, x: 0, y: 5)
                                    .padding(.leading)
                                TextField("Username".uppercased(), text: $username)
                                    .font(.subheadline)
                                    .padding(.leading)
                                Spacer()
                            }
                            Divider()
                                .padding(.leading, 80)
                                .padding(.trailing, 20)
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                                    .frame(width: 44, height: 44)
                                    .background(Color("background3"))
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.1), radius: 5, x: 0, y: 5)
                                    .padding(.leading)
                                SecureField("Password".uppercased(), text: $pass)
                                    .font(.subheadline)
                                    .padding(.leading)
                                Spacer()
                            }
                        }
                        .frame(width: 343, height: 136)
                        .background(BlurView(style: .systemMaterial))
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.2), radius: 20, x: 0, y: 20)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                self.showRegister = true
                            }) {
                                Text("Register".uppercased())
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .padding(12)
                            .padding(.horizontal, 20)
                                
                            .background(Color(.systemGreen))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.2), radius: 20, x: 0, y: 20)
                            .sheet(isPresented: $showRegister, content: {ContentfulRegisterView(show: self.$showRegister)})
                            
                            Button(action: {
                                self.login()}) {
                                    Text("Log in".uppercased())
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                            }
                            .padding(12)
                            .padding(.horizontal, 30)
                                
                            .background(Color(.systemBlue))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.2), radius: 20, x: 0, y: 20)
                            .alert(isPresented: $loginError) {
                                Alert(title: Text("Login Failed"), message: Text("Check Your Username and Password."), dismissButton: .default(Text("OK")))
                            }
                        }
                        .padding(.horizontal, 30)
                        .frame(maxWidth: 400)
                        
                        
                        
                        Spacer()
                        
                        
                        Image("done")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .scaleEffect(0.7)
                            .offset(y:-70)
                        
                        
                    }.frame(maxWidth:screen.width)
                        .background(Color("LogColor"))
                        .edgesIgnoringSafeArea(.bottom)
                }
            }
            
            if isLoading {
                LottieUserLoadingView()
            }
            
            if isSyncing {
                LottieSyncView()
            }
        }
    }
}


struct ContentfulLoginView_Previews: PreviewProvider {
    static var previews: some View {
        ContentfulLoginView(isLogged: .constant(true))
    }
}
