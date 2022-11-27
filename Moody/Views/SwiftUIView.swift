//
//  SwiftUIView.swift
//  Moody
//
//  Created by Josh Smith on 11/25/22.
//

import SwiftUI
import VTabView

struct SwiftUIView: View {
    var body: some View {
        VTabView {
            ForEach(0...10, id: \.self) { index in
                Text("\(index + 1). Hello, World!")
                    .font(.largeTitle.weight(.bold))
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background(.mint)
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
