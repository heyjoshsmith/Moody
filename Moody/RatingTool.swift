//
//  TodayView.swift
//  Moody
//
//  Created by Josh Smith on 11/2/22.
//

import SwiftUI

struct RatingTool: View {
    
    let onSelect: (Int) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        VStack(spacing: 0) {
            ForEach((1...5).reversed(), id: \.self) { number in
                Button {
                    onSelect(number)
                    dismiss()
                } label: {
                    ZStack {
                        number.color
                        Text("\(number)")
                            .font(.system(size: 50, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .ignoresSafeArea()
        
    }
    
}

struct RatingTool_Previews: PreviewProvider {
    static var previews: some View {
        RatingTool() { _ in }
    }
}
