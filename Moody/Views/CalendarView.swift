//
//  CalendarView.swift
//  Moody
//
//  Created by Josh Smith on 11/2/22.
//

import SwiftUI

struct CalendarView: View {
    
    var frame: GeometryProxy
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Mood.dateValue, ascending: true)],
        animation: .default)
    private var moods: FetchedResults<Mood>
    
    @State private var date = Date.now
    @State private var selection: DateInterval?
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                Text("My Moods")
                    .font(.largeTitle.weight(.bold))
                Spacer()
            }
            .padding(.bottom)
            .padding(.top, 55)
            .foregroundColor(.white)
            
            VStack {
                
                HStack {
                    Text(date.monthName)
                        .font(.title.weight(.bold))
                    Spacer()
                }
                .frame(height: 50)
                .padding(.horizontal, 10)
                
                HStack(spacing: 0) {
                    ForEach(date.extendedMonthRange[0...6], id: \.self) { day in
                        Text(day.start, formatter: DayLetter)
                            .frame(width: size, height: 20)
                    }
                }
                .padding(.bottom, 5)
                            
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(date.extendedMonthRange, id: \.self) { day in
                        Button {
                            selection = day
                        } label: {
                            VStack(spacing: 10) {
                                
                                Text(day.start, formatter: DayNumber)
                                
                                Circle()
                                    .fill(selection == day ? .white : mood(for: day))
                                    .frame(width: 10, height: 10)
                                
                            }
                            .foregroundColor(day.start.monthNumber == date.monthNumber ? .primary : .secondary)
                            .frame(width: size, height: size)
                            .background(selection == day ? mood(for: day) : .clear)
                            .cornerRadius(5)
                        }
                    }
                }
            }
            .padding(5)
            .background(Color(uiColor: .systemGroupedBackground))
            .cornerRadius(10)
            
            Spacer()
            
            if let selection {
                let mood = moods.first { mood in
                    selection.contains(mood.date)
                }
                Group {
                    if let mood {
                        Image(systemName: "\(mood.rating).circle.fill")
                    } else {
                        Image(systemName: "questionmark.circle.fill")
                    }
                }
                .font(.system(size: 150))
                .foregroundColor(.white)
            }
            
            Spacer()
            
        }
        .padding()
        .background(background)
        
    }
    
    var background: Color {
        if let selection {
            let mood = moods.first { mood in
                selection.contains(mood.date)
            }
            if let mood {
                return mood.color
            }
        }
        return .blue
    }
    
    func mood(for day: DateInterval) -> Color {
        let mood = moods.first { mood in
            day.contains(mood.date)
        }
        return mood?.color ?? .clear
    }
    
    var size: CGFloat {
        return ((frame.size.width - 40) / 7)
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
        .edgesIgnoringSafeArea(.vertical)
    }
}
