//
//  CalendarView.swift
//  Moody
//
//  Created by Josh Smith on 11/2/22.
//

import SwiftUI

struct CalendarView: View {
    
    var frame: GeometryProxy
    
    @State private var date = Date.now
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                Text(date.monthName)
                    .font(.title.weight(.bold))
                Spacer()
            }
            .padding(.horizontal, 10)
            .frame(height: 50)
            
            HStack(spacing: 0) {
                ForEach(date.extendedMonthRange[0...6], id: \.self) { day in
                    Text(day.start, formatter: DayLetter)
                        .frame(width: size, height: 20)
                }
            }
            .padding(.bottom, 5)
                        
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(date.extendedMonthRange, id: \.self) { day in
                    VStack(spacing: 10) {
                        
                        Text(day.start, formatter: DayNumber)
                        
                    }
                    .foregroundColor(day.start.monthNumber == date.monthNumber ? .primary : .secondary)
                    .frame(width: size, height: size)
                }
            }
            
        }
        .padding()
        
    }
    
    var size: CGFloat {
        return ((frame.size.width - 30) / 7)
    }
    
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    
}

private let DayNumber: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d"
    return formatter
}()

private let DayLetter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "E"
    return formatter
}()

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            CalendarView(frame: proxy)
        }
    }
}
