//
//  TimerController.swift
//  MyNotes
//
//  Created by YES on 2020/3/28.
//  Copyright © 2020 YES. All rights reserved.
//

import Foundation
import SwiftUI

class TimerController: ObservableObject {
    
    @Published var timerMode: TimerMode = .initial
    @Published var secondsLeft = UserDefaults.standard.integer(forKey: "timerLength")
    
    @State var showDoneAlert = false
    
    var timeCount = UserDefaults.standard.integer(forKey: "timeCount_test")
    var currentLength = 0
    
    var timer = Timer()
    
    
    func start() {
        timerMode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            if self.secondsLeft == 1 {
                timer.invalidate()
                self.done()
            }
            self.secondsLeft -= 1
        })
    }
    
    func reset() {
        self.timerMode = .initial
        self.secondsLeft = UserDefaults.standard.integer(forKey: "timerLength")
        timer.invalidate()
    }
    
    func pause() {
        self.timerMode = .paused
        timer.invalidate()
    }
    
    func done(){
        self.timerMode = .done
        self.timeCount += self.currentLength
        UserDefaults.standard.set(self.timeCount, forKey: "timeCount_test")
        self.timeCount = UserDefaults.standard.integer(forKey: "timeCount_test")
        
        print(self.timeCount)
    }
    
    func setTimerLength(minutes: Int) {
        let defaults = UserDefaults.standard
        defaults.set(minutes, forKey: "timerLength")
        secondsLeft = minutes
        currentLength = minutes
    }
    
}


enum TimerMode {
    case running
    case paused
    case initial
    case done
}

func secondsToMinutesAndSeconds (seconds : Int) -> String {
    
    let minutes = "\((seconds % 3600) / 60)"
    let seconds = "\((seconds % 3600) % 60)"
    let minuteStamp = minutes.count > 1 ? minutes : "0" + minutes
    let secondStamp = seconds.count > 1 ? seconds : "0" + seconds

    return "\(minuteStamp):\(secondStamp)"
}
