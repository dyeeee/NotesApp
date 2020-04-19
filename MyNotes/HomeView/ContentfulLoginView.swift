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
    
    
    var body: some View {
        ZStack(alignment: .top) {
            
            if isLogged {
                ZStack(alignment: .top) {
                    Color.black
                        .edgesIgnoringSafeArea(.all)
                    
                    Color("background2")
                        .edgesIgnoringSafeArea(.bottom)
                    
                    VStack(spacing:20) {
                        Text("User Information")
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
                                Text(loggedUsername ?? "unknow")
                                    .font(.subheadline)
                                    .padding(.leading)
                                Spacer()
                            }
                            Divider()
                                .padding(.leading, 80)
                                .padding(.trailing, 20)
                            HStack {
                                Image(systemName: "timer")
                                    .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                                    .frame(width: 44, height: 44)
                                    .background(Color("background3"))
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.1), radius: 5, x: 0, y: 5)
                                    .padding(.leading)
                                Text("\(timerControllerGlobal.timeCount / 60)" )
                                    .font(.subheadline)
                                    .padding(.leading)
                                Spacer()
                            }
                            
                        }
                        .frame(width: 343, height: 200)
                        .background(BlurView(style: .systemMaterial))
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.2), radius: 20, x: 0, y: 20)
                        
                        HStack {
                            Button(action: {
                                self.tool.userUpload()
                            }) {
                                Text("Upload".uppercased())
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .padding(12)
                            .frame(width: 160)
                                
                            .background(Color(#colorLiteral(red: 0, green: 0.7529411765, blue: 1, alpha: 1)))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.2), radius: 20, x: 0, y: 20)
                            
                            Spacer()
                            
                            Button(action: {
                                self.tool.userDownload()
                            }) {
                                Text("Download".uppercased())
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .padding(12)
                            .frame(width: 160)
                            .background(Color(#colorLiteral(red: 0, green: 0.7529411765, blue: 1, alpha: 1)))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.2), radius: 20, x: 0, y: 20)
                            
//                            Spacer()
//                            
//                            Image("done")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .scaleEffect(0.7)
//                            .offset(y:-85)
                            
                        }
                        .padding(.horizontal, 30)
                        .frame(maxWidth: 400)
                        
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                self.logout()
                            }) {
                                Text("Log out".uppercased())
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .padding(12)
                            .frame(width: 160)
                                
                            .background(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.2), radius: 20, x: 0, y: 20)
                            
                        }
                        .padding(.horizontal, 30)
                        .frame(maxWidth: 400)
                        
                        
                        Spacer()
                        
                        
                        Image("learn")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .scaleEffect(0.7)
                            .offset(y:-70)
                        
                    }.frame(maxWidth:screen.width)
                        .background(Color(#colorLiteral(red: 0.4117647059, green: 0.4705882353, blue: 0.9725490196, alpha: 1)))
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
                                
                            .background(Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)))
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
                                
                            .background(Color(#colorLiteral(red: 0, green: 0.7529411765, blue: 1, alpha: 1)))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.2), radius: 20, x: 0, y: 20)
                            .alert(isPresented: $loginError) {
                                Alert(title: Text("Bad login"), message: Text("登录失败"), dismissButton: .default(Text("OK")))
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
                        .background(Color(#colorLiteral(red: 0.4117647059, green: 0.4705882353, blue: 0.9725490196, alpha: 1)))
                        .edgesIgnoringSafeArea(.bottom)
                }
            }
            
            if isLoading {
                LottieTestView()
            }
        }
    }
}


struct ContentfulLoginView_Previews: PreviewProvider {
    static var previews: some View {
        ContentfulLoginView(isLogged: .constant(true))
    }
}
