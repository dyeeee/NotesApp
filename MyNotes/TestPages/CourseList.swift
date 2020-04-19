//
//  CourseList.swift
//  MyPlan
//
//  Created by YES on 2020/2/28.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI
//let screen = UIScreen.main.bounds  //以后可以调用视图的尺寸信息，不用像素值

struct CourseList: View {
    @State var courses = courseData
    @State var active = false
    @State var activeIndex = -1
    @State var activeView = CGSize.zero
    
    @State var content = "ContentContentContentContentContentContentContentContentContentContentContent"
    
    var body: some View {
        ZStack {
            Color.black.opacity(Double(self.activeView.height / 500))
                .animation(.linear)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 30) {
                    Text("Notes").font(.largeTitle).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                        .padding(.top, 30)
                        .blur(radius: active ? 30 : 0)  //卡片激活时，标题模糊
                    
                    // 使用了数组索引
                    ForEach(courses.indices, id: \.self) {
                        index in
                        GeometryReader {
                            gemotry in
                            CourseView(
                                show: self.$courses[index].show,
                                course: self.courses[index],
                                active: self.$active,
                                index: index,
                                activeIndex: self.$activeIndex,
                                activeView: self.$activeView,
                                text: self.$content)  //在GeometrReader中，添加self
                            .offset(y: self.courses[index].show ? -gemotry.frame(in: .global).minY : 0)  //如果show，就移动 -gemotry.xxx的距离，抵消当前gemotry.xx.minY
                            .opacity(self.activeIndex != index && self.active ? 0 : 1)
                            .scaleEffect(self.activeIndex != index && self.active ? 0.5 : 1)
                            .offset(x: self.activeIndex != index && self.active ? screen.width : 0)
                        }
                        //.frame(height: self.courses[index].show ? screen.height : 280)
                        .frame(height: 280)
                        .frame(maxWidth: self.courses[index].show ? .infinity : screen.width - 60)
                        .zIndex(self.courses[index].show ? 1 : 0) //show时为z轴索引为1，在0的上面
                    }
                }
                .frame(width: screen.width)  //ScrollView的宽度
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                // 卡片激活时，隐藏状态栏
                .statusBar(hidden: active ? true : false)
                .animation(.linear)
            }
        }
    }
}


struct CourseList_Previews: PreviewProvider {
    static var previews: some View {
            CourseList()
    }
}

struct CourseView: View {
    @Binding var show: Bool
    var course: Course
    @Binding var active: Bool // 状态栏显示与否的绑定
    
    var index: Int
    @Binding var activeIndex: Int
    
    // 卡片展开时的手势拖动
    @Binding var activeView: CGSize
    @Binding var text: String
    @State var showDetail = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10.0) {
                Text("Content")
                    .font(.title).bold()
                
                HStack {
                    Text(text)
                    Spacer()
                }
                
                Button(action:{self.showDetail.toggle()}) {
                    Image(systemName: "bell")
                        .renderingMode(.original)
                        .font(.system(size: 16, weight: .medium))
                        .frame(width:36, height: 36)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                }
                .sheet(isPresented: $showDetail){ //单击按钮时展示内容
                    ContentView()
                }
            


            }
                .padding(30)
                .offset(y : show ? 330 : 0)
                //不show的时候文本藏在上面的VStack下
                .frame(maxWidth: show ? .infinity : screen.width - 60, maxHeight: show ? .infinity : 200, alignment: .top)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                .opacity(show ? 1 : 0)
            
            
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8.0) {
                        Text(course.title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.white)
                        Text(course.subtitle)
                            .foregroundColor(Color.white.opacity(0.7))
                    }
                    Spacer()
                    
                    ZStack {
                        Image(uiImage: course.logo)
                            .opacity(show ? 0 : 1)
                        
                        VStack {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                
                        }
                        .frame(width: 36, height: 36)
                        .background(Color.black)
                        .clipShape(Circle())
                        .opacity(show ? 1 : 0)
                    }
                }
                Spacer()
                Image(uiImage: course.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .frame(height: 140, alignment: .top)
                
                
            }
            .padding(show ? 30 : 20)
            .padding(.top, show ? 30 : 0)
    //        .frame(width: show ? screen.width : screen.width - 60 , height: show ? screen.height : 280)
            .frame(maxWidth: show ? .infinity : screen.width - 60 , maxHeight: show ? 330 : 280)
            .background(Color(course.color))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color(course.color).opacity(0.3), radius: 20, x: 0, y: 20)
            .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0))
            .gesture(
                show ?
                DragGesture()
                    .onChanged{
                        value in
                        // 保证手势拖动值小于 200，否则结束代码；执行self.activeView = value.translation, 让值保持为translation
                        guard value.translation.height < 100 else{ return }
                        
                        // 保证只能向下拖动
                        guard value.translation.height > 0 else{ return }
                        self.activeView = value.translation
//                        if value.translation.height < 200 {
//                            self.activeView = value.translation
//                        }
                    }
                    .onEnded{
                        value in
                        if self.activeView.height > 50 {
                            self.show = false
                            self.active = false
                            self.activeIndex = -1
                        }
                        self.activeView = .zero
                    }
                : nil  //show时开启手势，否则无
            )
            .onTapGesture {
                self.show.toggle()
                self.active.toggle()
                
                // 获取当前活动状态的卡片索引
                if self.show {
                    self.activeIndex = self.index
                }
                else{
                    self.activeIndex = -1
                }
            }
        }
        .frame(height: show ? screen.height : 280)
        .scaleEffect(1 - self.activeView.height / 1000 )
        .rotation3DEffect(Angle(degrees: Double(self.activeView.height / 10)), axis: (x: 0, y: 10, z: 0))
        .hueRotation(Angle(degrees: Double(self.activeView.height)))
        .edgesIgnoringSafeArea(.all)
        .gesture(
            show ?
                DragGesture()
                    .onChanged{
                        value in
                        guard value.translation.height < 100 else{ return }
                        
                        // 保证只能向下拖动
                        guard value.translation.height > 0 else{ return }
                        self.activeView = value.translation

                }
                .onEnded{
                    value in
                    if self.activeView.height > 50 {
                        self.show = false
                        self.active = false
                        self.activeIndex = -1
                    }
                    self.activeView = .zero
                }
                : nil  //show时开启手势，否则无
        )
        .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0))
        
    }
}

struct Course: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var image: UIImage
    var logo: UIImage
    var color: UIColor
    var show: Bool   //每张卡的状态
}

var courseData = [
    Course(title: "Prototype Designs in SwiftUI", subtitle: "18 section", image: #imageLiteral(resourceName: "Card4"), logo: #imageLiteral(resourceName: "Logo1"), color: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
, show: false),
    Course(title: "SwiftUI Advanced", subtitle: "20 section", image: #imageLiteral(resourceName: "Card5"), logo: #imageLiteral(resourceName: "Logo1"), color: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    , show: false),
    Course(title: "UI Design for Developer", subtitle: "20 section", image: #imageLiteral(resourceName: "Card2"), logo: #imageLiteral(resourceName: "Logo2"), color: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    , show: false)
]

