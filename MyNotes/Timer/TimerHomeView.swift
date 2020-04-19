//
//  TimerHomeView.swift
//  MyNotes
//
//  Created by YES on 2020/3/28.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI
import UIKit



struct TimerHomeView: View {
    
    init(){
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    @ObservedObject var timerController = timerControllerGlobal
    
    @State var selectedPickerIndex = 0
    
    let availableMinutes = [1,5,10,15,20]
    
    var timeCount = 0
    @State var showDoneAlert = false
    @State var runningTimer = false
    var currentBrightness = UIScreen.main.brightness
    
    let generator = UINotificationFeedbackGenerator()
    
    
    var body: some View {
        VStack {
            VStack (spacing:40){
                VStack {
                    Text("Focus Timer")
                        .font(.system(size: 40))
                        .padding(.top, 20)
                        .foregroundColor(runningTimer ? Color(.white):Color(.black))
                    
                    Text("今天已经专注了\(timerController.timeCount / 60)分钟")
                                       .font(.system(size: 20))
                                       .foregroundColor(runningTimer ? Color(.white):Color(.black))
                }
                
//
                Text(secondsToMinutesAndSeconds(seconds: timerController.secondsLeft))
                    .font(.system(size: 50))
                    .padding(.top, 10)
                    .foregroundColor(runningTimer ? Color(.white):Color(.black))
                .animation(.none)
                
                if timerController.timerMode != .done{
                    Image(systemName: timerController.timerMode == .running ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .foregroundColor(runningTimer ? Color(.white):Color(.orange))
                        .clipShape(Circle())
                        .onTapGesture(perform: {
                            self.runningTimer.toggle()
                            self.generator.notificationOccurred(.success)
                            UIScreen.main.brightness = self.runningTimer ? CGFloat(0.4):self.currentBrightness
                            if self.timerController.timerMode == .initial {
                                self.timerController.setTimerLength(minutes: self.availableMinutes[self.selectedPickerIndex]*60)
                            }
                            self.timerController.timerMode == .running ? self.timerController.pause() : self.timerController.start()
                        })
                }else{
                    Image(systemName:  "hand.thumbsup" )
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(0.7)
                        .frame(width: 150, height: 150)
                        .foregroundColor(.white)
                        .background(Color(.orange))
                        .clipShape(Circle())
                        .onTapGesture(perform: {
                            self.timerController.reset()
                            self.showDoneAlert.toggle()
                            self.runningTimer.toggle()
                        })
                }
                if timerController.timerMode == .paused {
                    Image(systemName: "gobackward")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .padding(.top, 40)
                        .onTapGesture(perform: {
                            self.timerController.reset()
                        })
                }
                if timerController.timerMode == .initial {
                    Picker(selection: $selectedPickerIndex, label: Text("How Long?")) {
                        ForEach(0 ..< availableMinutes.count) {
                            Text("\(self.availableMinutes[$0]) min")
                        }
                    }
                    .labelsHidden()
                .offset(x: 0, y: -60)
                }
                
                if timerController.timerMode == .running {
                    Text("认真完成待办事项吧")
                    .font(.system(size: 30))
                    .padding(.top, 20)
                    .foregroundColor(Color(.white))
                }
                
                
                Spacer()
            }
            .alert(isPresented: $showDoneAlert) {
                Alert(title: Text("完成啦"), message: Text("今天已经专注了\(timerController.timeCount / 60)分钟"), dismissButton: .default(Text("OK!")))}
        }
        .padding(.top,40)
        .frame(maxWidth: .infinity)
        .background(runningTimer ? Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)):Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
        .edgesIgnoringSafeArea(.all)
        .animation(.timingCurve(0.7, 1, 0.3, 1, duration: 1))
    }
    
}


var timerControllerGlobal = TimerController()



struct TimerHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TimerHomeView()
    }
}
