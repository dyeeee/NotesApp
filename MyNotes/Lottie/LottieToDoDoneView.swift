//
//  LottieToDoDoneView.swift
//  MyNotes
//
//  Created by YES on 2020/4/21.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct LottieToDoDoneView: View {
    var body: some View {
        VStack {
            LottieView(filename: "done")
                .frame(width: 400, height: 400)
                
                
        }
        .padding(-80)
        //.background(Color(.gray).opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .offset(y: -100)
        .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
    }
}

struct LottieToDoDoneView_Previews: PreviewProvider {
    static var previews: some View {
        LottieToDoDoneView()
    }
}
