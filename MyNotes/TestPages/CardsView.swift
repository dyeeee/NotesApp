//
//  CardsView.swift
//  MyNotes
//
//  Created by YES on 2020/3/20.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI
import UIKit

struct CardsView: View {
    @State var show = false //声明状态，在动画状态间切换
    @State var viewState = CGSize.zero  //声明状态，使手势可用.CGSize包含一个width和一个height
    @State var showCard = false
    @State var bottomState = CGSize.zero //底部状态
    @State var showFull = false // 底部信息拉开的状态
    
    @State private var newTodoItem = "Input here"
    
    @Environment(\.managedObjectContext) var managedObjectContext
//    @FetchRequest(fetchRequest: ToDoItem.getAllToDoItems()) var toDoItems:FetchedResults<ToDoItem>
    
    
    var body: some View {
        ZStack { //三维堆叠
            TitleView()
                .blur(radius: show ? 20: 0 )
                .opacity(showCard ? 0.4 : 1)
                .offset(y:showCard ? -200 : 0)
                .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8)) //时序曲线动画
            
            
            CardView()
                .frame(width: showCard ? 375 : 340.0, height: 220.0) //设置Stack大小
                .background(Color.black) //设置Stack颜色
                //.cornerRadius(20) //设置Stack圆角
                .clipShape(RoundedRectangle(cornerRadius: showCard ? 30: 20, style: .continuous))
                //.shadow(radius: 20) //阴影
                .offset(x:viewState.width,y:viewState.height) // 卡片位置由状态决定，状态随着拖动被改变
                .offset(y:showCard ? -100: 0)
                .blendMode(.hardLight) //混合模式（类似PS）
                .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0)) //.spring 动画，有点反弹的意思，response是响应时间
                .onTapGesture { // 单击卡片的手势
                    //self.show.toggle()   //show变量切换
                    self.showCard.toggle()   //showCard变量切换
            }
            .gesture(
                DragGesture().onChanged{ //拖动时更新值
                    value in
                    self.viewState = value.translation  //用state存储位置
                    self.show = true // 拖动时展开+模糊
                }
                .onEnded{  //结束拖动时归零
                    value in
                    self.viewState = .zero
                    self.show = false // 结束时复原
                }
            )
            
            
            //底部信息栏，可以拖动并悬停在具体位置-用文本实时显示位置
            //Text("\(bottomState.height)").offset(y:-300)
            BottomCardView(show: $showCard, text: $newTodoItem)
                .offset(x:0, y: showCard ? 360 : 1000)
                .offset(y:bottomState.height) // 卡片位置由状态决定，状态随着拖动被改变
                .blur(radius: show ? 20 : 0 )
                .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8)) //时序曲线动画
            .gesture(
                DragGesture().onChanged{ //拖动时更新值
                    value in
                    self.bottomState = value.translation
                    if self.showFull{
                        self.bottomState.height += -300 // 如果是在full状态，则从-300开始而不是从0开始
                    }
                    if self.bottomState.height < -300 {
                        self.bottomState.height = -300  //不允许拖动超过上限
                    }
                }
                .onEnded{  //结束拖动时归零
                    value in
                    if self.bottomState.height > 50{ //拖动点向上为负
                        self.showCard = false  //向下拖动到一定就解除
                    }
                    if (self.bottomState.height < -100 && !self.showFull) || (self.bottomState.height < -250 && self.showFull) {
                        self.bottomState.height = -300
                        self.showFull = true
                    }else{
                        self.bottomState = .zero // 注意这里要else时归回原位
                        self.showFull = false
                    }
                    

                }
            )
            
            
        }
    }
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView()
    }
}

struct CardView: View {
    var body: some View {
        VStack { //这个VStackb是第一层
            HStack {
                VStack(alignment: .leading) {
                    Text("UI Design")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                    Text("Certificates")
                        .foregroundColor(Color("accent"))
                }
                Spacer()
                Image("Logo1")
            }
                .padding(.horizontal,20)//左右外框边距
                .padding(.top,20)//上外框边距
            Spacer()
            Image("Card1")
                .resizable() //图片适应Stack
                .aspectRatio(contentMode: .fill) //图片保持比例,并且设置格式fill
                .frame(width: 300, height: 110, alignment: .top) //图片填充时的限制
        }
    }
}

struct BackCardView: View {
    var body: some View {
        VStack{
            Spacer() //占位先
        }
    }
}

struct TitleView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Notes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            Image("Background1")
            Spacer()
        }
    }
}

struct BottomCardView: View {
    // showCard 的时候才显示进度
    @Binding var show: Bool
    @Binding var text:String
    
    @Environment(\.managedObjectContext) var managedObjectContext
//    @FetchRequest(fetchRequest: ToDoItem.getAllToDoItems()) var toDoItems:FetchedResults<ToDoItem>
    
    var body: some View {
        VStack(spacing: 20){
            //(spacing:20)为堆栈中的每个元素设置间隔
            Rectangle() //小home键
                .frame(width: 40, height: 5)
                .cornerRadius(3)
                .opacity(0.8)
        
            
            VStack(alignment:.leading) {
                HStack() {
                    multiLineTextField(text: $text)
                    .frame(height: 150)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.purple, lineWidth: 2))
                    Button(action:{
                              print(self.text)
                            let toDoItem = ToDoItem(context: self.managedObjectContext)
                            //可以获取到字段
//                        toDoItem.title = self.text
                            toDoItem.createdAt = Date()
                            do{
                                //保存被管理对象内容
                                try self.managedObjectContext.save()
                            }catch{print(error)}
                            
                            self.text = "Done"
                        
                        
                          }){Image(systemName: "plus.circle.fill")
                              .foregroundColor(.green)
                              .imageScale(.large)
                    }.frame(height: 100)
                }
                Text(self.text)
                .multilineTextAlignment(.leading)
                .font(.subheadline)
                .lineSpacing(4)
            }
            //
            
                
            Spacer()
            
            
        }
        .padding(.top,8)
        .padding(.horizontal,20)
        .frame(maxWidth:.infinity) //将这个VStack推到最大宽度
            .background(BlurView(style: .systemThinMaterial))
        .cornerRadius(30)
        .shadow(radius: 20)
    }
}

