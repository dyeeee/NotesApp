//
//  NoteRowView.swift
//  MyNotes
//
//  Created by YES on 2020/3/25.
//  Copyright © 2020 YES. All rights reserved.
//


import SwiftUI
import UIKit

struct NoteCardView: View {
    
    var noteItemController: NoteItemController
    @State var noteItem: NoteItem
    
    @Binding var showFullView: Bool
    @Binding var active: Bool // 状态栏显示与否的绑定
    var index: Int
    @State var showEditView = false
    
    @Binding var activeIndex: Int
    
    // 卡片展开时的手势拖动
    @Binding var activeView: CGSize
    
    var colorOfRowIndex: Int
    
    var colors = [#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)]
    
    @Environment(\.presentationMode) var presentationMode
    
    var timeFormatter: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd, HH:mm"
        let dateString = formatter.string(from: noteItem.createdAt ?? Date())
        
        let returnString = "\(dateString)"
        return returnString
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10.0) {
                HStack{
                    Text("Content")
                        .font(.system(size: 24, weight: .bold))
                    Spacer()
                }
                HStack {
                    Text(noteItem.content ?? "content")
                    Spacer()
                }
                
            }
            .padding(30)
            .offset(y : showFullView ? 240 : 0)
                //不showFullView的时候文本藏在上面的VStack下
                .frame(maxWidth: showFullView ? .infinity : screen.width - 60, maxHeight: showFullView ? .infinity : 200, alignment: .top)
                .background(Color("RowAnyColor"))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color("ShadowColor"), radius: 20, x: 0, y: 20)
                .opacity(showFullView ? 1 : 0)
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8.0) {
                        Text(noteItem.title ?? "no title")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.white)
                            .offset(x: 0, y: showFullView ? 20 : 0)
                            
                        
                        Text(showFullView ? timeFormatter : noteItem.content ?? "no content")
                            .offset(x: 0, y: showFullView ? 20 : 0)
                            .foregroundColor(Color.white)
                        
                    }
                    Spacer()
                    
//                    ZStack {
//                        HStack {
//                            VStack {
//                                Image(systemName: "xmark")
//                                    .font(.system(size: 16, weight: .medium))
//                                    .foregroundColor(.white)
//                            }
//                            .frame(width: 36, height: 36)
//                            .background(Color.black)
//                            .clipShape(Circle())
//                            .opacity(showFullView ? 1 : 0)
//                        }
//                    }
                }
                Spacer()
            }
            .padding(showFullView ? 30 : 20)
            .padding(.top, showFullView ? 30 : 0)
            .frame(maxWidth: showFullView ? .infinity : screen.width - 60 , maxHeight: showFullView ? 240 : 180)
            .background(Color(self.colors[colorOfRowIndex]))
            .clipShape(RoundedRectangle(cornerRadius: showFullView ? 10 :30, style: .continuous))
            .shadow(color: Color(self.colors[colorOfRowIndex]).opacity(0.3), radius: 20, x: 0, y: 20)
            .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
            .gesture(
                showFullView ?
                    DragGesture()
                        .onChanged{
                            value in
                            guard value.translation.height < 150 else{ return }
                            guard value.translation.height > 0 else{ return }
                            self.activeView = value.translation
                    }
                    .onEnded{
                        value in
                        if self.activeView.height > 50 {
                            self.showFullView = false
                            self.active = false
                            self.activeIndex = -1
                        }
                        self.activeView = .zero
                    }
                    : nil  //showFullView时开启手势，否则无
            )
                .onTapGesture {
                    self.showFullView.toggle()
                    self.active.toggle()
                    
                    // 获取当前活动状态的卡片索引
                    if self.showFullView {
                        print(self.index)
                        self.activeIndex = self.index
                    }
                    else{
                        self.activeIndex = -1
                    }
            }
        }
        .frame(height: showFullView ? screen.height : 280)
        .scaleEffect(1 - self.activeView.height / 1000 )
        .rotation3DEffect(Angle(degrees: Double(self.activeView.height / 10)), axis: (x: 0, y: 10, z: 0))
        .hueRotation(Angle(degrees: Double(self.activeView.height)))
        .edgesIgnoringSafeArea(.all)
        .gesture(
            showFullView ?
                DragGesture()
                    .onChanged{
                        value in
                        guard value.translation.height < 150 else{ return }
                        guard value.translation.height > 0 else{ return }
                        self.activeView = value.translation
                }
                .onEnded{
                    value in
                    if self.activeView.height > 50 {
                        self.showFullView = false
                        self.active = false
                        self.activeIndex = -1
                    }
                    self.activeView = .zero
                }
                : nil  //showFullView时开启手势，否则无
        )
            .animation(.spring(response: 0.5, dampingFraction: 0.9, blendDuration: 0))
    }
}
//struct NoteRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteRowView()
//    }
//}

extension Array {
    /// 从数组中返回一个随机元素
    public var sample: Element? {
        //如果数组为空，则返回nil
        guard count > 0 else { return nil }
        let randomIndex = Int(arc4random_uniform(UInt32(count)))
        return self[randomIndex]
    }
    
    /// 从数组中从返回指定个数的元素
    ///
    /// - Parameters:
    ///   - size: 希望返回的元素个数
    ///   - noRepeat: 返回的元素是否不可以重复（默认为false，可以重复）
    public func sample(size: Int, noRepeat: Bool = false) -> [Element]? {
        //如果数组为空，则返回nil
        guard !isEmpty else { return nil }
        
        var sampleElements: [Element] = []
        
        //返回的元素可以重复的情况
        if !noRepeat {
            for _ in 0..<size {
                sampleElements.append(sample!)
            }
        }
            //返回的元素不可以重复的情况
        else{
            //先复制一个新数组
            var copy = self.map { $0 }
            for _ in 0..<size {
                //当元素不能重复时，最多只能返回原数组个数的元素
                if copy.isEmpty { break }
                let randomIndex = Int(arc4random_uniform(UInt32(copy.count)))
                let element = copy[randomIndex]
                sampleElements.append(element)
                //每取出一个元素则将其从复制出来的新数组中移除
                copy.remove(at: randomIndex)
            }
        }
        
        return sampleElements
    }
}
