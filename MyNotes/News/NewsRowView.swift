//
//  NewsRow.swift
//  MyNotes
//
//  Created by YES on 2020/4/20.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct NewsRowView: View {
    var news: News
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "hexagon")
                Text(news.publicTime)
                Spacer()
            }
            .foregroundColor(Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)))
            
            HStack {
                Text(news.title)
                    .font(.headline)
                Spacer()
            }.padding(.leading,30)
            
            HStack {
                Text(news.content)
                    .font(.subheadline)
                Spacer()
            }.padding(.leading,30)
                .foregroundColor(Color(.systemGray2))
            .offset(x: 0, y: 10)
        }.padding(.bottom,30)
    }
}

struct NewsRowView_Previews: PreviewProvider {
    static var previews: some View {
        NewsRowView(news: News(id: "123", publicTime: "14:32", title: "基于CRISPR的新冠病毒快速诊断技术出现", content: "据科技日报，英国《自然·生物技术》杂志近日公开的一项生物医学研究，美国科学家报告了一种基于 CRISPR 的诊断工具可以快速检测出新冠病毒。"))
    }
}
