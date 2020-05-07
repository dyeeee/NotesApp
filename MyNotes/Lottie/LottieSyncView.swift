//
//  LottieSyncView.swift
//  MyNotes
//
//  Created by YES on 2020/4/21.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI

struct LottieSyncView: View {
    var body: some View {
                VStack {
                LottieView(filename: "sync")
                    .frame(width: 400, height: 400)
                    .foregroundColor(.white)
                    
            }
            .padding(-90)
                .background(Color(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.968627451, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .shadow(color: Color(.black).opacity(0.5), radius: 3, x: 0, y: 0)
            .offset(y: -100)
            .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
        }
    }

struct LottieSyncView_Previews: PreviewProvider {
    static var previews: some View {
        LottieSyncView()
    }
}
