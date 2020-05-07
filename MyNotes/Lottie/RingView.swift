//
//  RingView.swift
//  MyPlan
//
//  Created by YES on 2020/2/28.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct RingView: View {
    var color1 = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    var color2 = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    var width: CGFloat = 55
    var height: CGFloat = 55
    var percent: CGFloat = 88
    // var multiplier = width / 44  不能定义在这里
    @Binding var show: Bool   // 要在文件外部也可以动画，要声明绑定而不是状态来接收具体的状态
    
    var body: some View {
        let multiplier = width / 44
        let progress = 1 - percent / 100
        
        return ZStack {
            Circle()
                .stroke(Color.black.opacity(0.1),style: StrokeStyle(lineWidth: 5 * multiplier))
                .frame(width: width, height: height)
            
            Circle()
                // 圆形开口
                .trim(from: show ? progress : 1, to: 1)
                // 圆形的样式设计，渐变+笔刷
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [Color(color1),Color(color2)]), startPoint: .topTrailing, endPoint: .bottomLeading),
                    style: StrokeStyle(lineWidth: 5 * multiplier, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [20,0], dashPhase: 0))
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x:1, y:0, z:0))
                .frame(width: width, height: height)
                .shadow(color: Color(color2).opacity(0.1), radius: 3 * multiplier, x: 0, y: 3 * multiplier)
                .animation(.easeInOut) //在外部使用动画更好
            
            Text("\(Int(percent))")
                .font(.system(size: 14 * multiplier))
                .fontWeight(.bold)
                .onTapGesture {
                    self.show.toggle()
            }
        }
    }
}

struct RingView_Previews: PreviewProvider {
    static var previews: some View {
        RingView(show: .constant(true))
    }
}
