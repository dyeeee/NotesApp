//
//  LottieUserLoadingView.swift
//  MyNotes
//
//  Created by YES on 2020/4/21.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct LottieUserLoadingView: View {
    var body: some View {
        VStack {
            LottieView(filename: "card-loading")
                .frame(width: 120, height: 120)
                
                
        }
        .padding(10)
        .background(Color(.gray).opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .offset(y: -100)
    }
}

struct LottieUserLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LottieUserLoadingView()
    }
}
