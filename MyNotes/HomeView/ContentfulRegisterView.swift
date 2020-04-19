//
//  ContentfulRegisterView.swift
//  MyNotes
//
//  Created by YES on 2020/4/18.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct ContentfulRegisterView: View {
    
    @State private var username = ""
    @State private var pass = ""
    @ObservedObject var tool = MincloudTools()
    @Binding var show:Bool
    
    @State var isLoading = false
    
    func register(){
        self.tool.userregister(name: self.username, pass: self.pass)
        self.isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.isLoading = false
            self.show.toggle()
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            Color("background2")
                .edgesIgnoringSafeArea(.bottom)
            
            VStack(spacing:20) {
                Text("Register \n StartRight Now")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    .multilineTextAlignment(.center)
                
                VStack {
                    HStack {
                        TextField("Input your username", text: ($username))
                            .font(.title)
                            .padding(.leading)
                        Spacer()
                    }

                    Divider()
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    HStack {
                        
                        TextField("Input your passward", text: ($pass))
                            .font(.title)
                            .padding(.leading)
                        Spacer()
                    }
                    
                    
                }
                .frame(width: 343, height: 150)
                .background(BlurView(style: .systemMaterial))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.2), radius: 20, x: 0, y: 20)
                
                
                HStack {
                    Button(action: {
                        self.register()
                    }) {
                        Text("Register".uppercased())
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .padding(12)
                    .frame(width: 160)
                        
                    .background(Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.2), radius: 20, x: 0, y: 20)
                    
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: 400)
                
                
                Spacer()
                
                
                Image("done")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaleEffect(0.6)
                    .offset(y:-75)
                
            }.frame(maxWidth:screen.width)
                .background(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                .edgesIgnoringSafeArea(.bottom)
            
            if isLoading {
                LottieTestView()
            }
        }
        
        
    }
}

struct ContentfulRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        ContentfulRegisterView(show: .constant(true))
    }
}
