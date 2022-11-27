//
//  HomeView.swift
//  Moody
//
//  Created by Josh Smith on 11/25/22.
//

import SwiftUI
import VTabView

struct HomeView: View {
    
    @State private var selection = 1
    
    var body: some View {
        GeometryReader { screen in
            VTabView(selection: $selection) {
                CalendarView(frame: screen)
                    .padding(.leading, 15)
                    .padding(.trailing, -15)
                    .tag(0)
                TodayView()
                    .padding(.leading, 10)
                    .padding(.trailing, -15)
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
