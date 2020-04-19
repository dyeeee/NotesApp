//
//  BlurView.swift
//  MyPlan
//
//  Created by YES on 2020/2/29.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIView
    var style: UIBlurEffect.Style  //可以自定义
    
    // 创建基本UI
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: CGRect.zero)  //普通swift视图
        view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            //blurView的约束等于view的宽度和高度
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    // 动画、绑定等内容的UI
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<BlurView>) {
    }


}
