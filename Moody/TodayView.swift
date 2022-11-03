//
//  TodayView.swift
//  Moody
//
//  Created by Josh Smith on 11/2/22.
//

import SwiftUI

struct TodayView: View {
    
    @EnvironmentObject private var mind: Mind
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Mood.dateAddedValue, ascending: true)],
        animation: .default)
    private var moods: FetchedResults<Mood>
    
    @State private var date = Date.now
    @State private var showRatingTool = false
    @State private var viewing = 0
    
    var body: some View {
        Group {
            
            if !showRatingTool {
                
                TabView(selection: $viewing) {
                    ForEach(moods) { mood in
                        Button(action: toggleRatingTool) {
                            buttonView(mood)
                        }
                        .tag(moods.firstIndex(of: mood)!)
                    }
                    if todaysMood == nil {
                        Button(action: toggleRatingTool) {
                            buttonView()
                        }
                        .tag(moods.count)
                    }
                }
                .tabViewStyle(.page)
                .ignoresSafeArea()
                .transition(.move(edge: .top))
                
            }
            
            if showRatingTool {
                RatingTool(onSelect: addRating)
                    .transition(.move(edge: .bottom))
            }
        }
    }
    
    func toggleRatingTool() {
        withAnimation {
            showRatingTool.toggle()
        }
    }
    
    var todaysMood: Mood? {
        let moods = self.moods.filter { mood in
            mood.dateValue != nil
        }
        let today = moods.filter { mood in
            mood.date.wholeDay.contains(.now)
        }.first
        if let today {
            return today
        } else {
            return nil
        }
    }
    
    func buttonView(_ mood: Mood? = nil) -> some View {
        VStack {
            Spacer()
            
            Group {
                if let mood {
                    Image(systemName: "\(mood.rating).circle.fill")
                        .resizable()
                } else {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                }
            }
            .foregroundColor(.white)
            .scaledToFit()
            .padding(100)
            
            Spacer()
            
            Text(mood?.dateValue ?? .now, style: .date)
                .foregroundColor(.white)
            
        }
        .padding()
        .background(mood?.rating.color ?? .blue)
    }
    
    func addRating(_ value: Int) {
        withAnimation {
            if let todaysMood {
                todaysMood.rating = value
            } else {
                let mood = Mood(context: mind.container.viewContext)
                mood.rating = value
                mood.date = .now
                mood.dateAdded = .now
            }
            mind.save()
            showRatingTool = false
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
