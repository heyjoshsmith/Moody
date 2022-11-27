//
//  TodayView.swift
//  Moody
//
//  Created by Josh Smith on 11/2/22.
//

import SwiftUI
import UserNotifications
import MapKit
import CoreLocation

struct TodayView: View {
    
    @EnvironmentObject private var mind: Mind
    @EnvironmentObject private var locationManager: LocationManager
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Mood.dateValue, ascending: true)],
        animation: .default)
    private var moods: FetchedResults<Mood>
    
    @State private var date = Date.now
    @State private var showRatingTool = false
    @State private var showCalendar = false
    @State private var viewing = 0
    @State private var showingLocationScreen = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            if !showRatingTool {
                
                TabView(selection: $viewing) {
                    ForEach(moods) { mood in
                        Button(action: toggleRatingTool) {
                            buttonView(mood)
                        }
                        .contextMenu {
                            Button {
                                showingLocationScreen.toggle()
                            } label: {
                                Label("View Location", systemImage: "location")
                            }
                            Button(action: requestNotification) {
                                Label("Request Notifications", systemImage: "bell.badge")
                            }
                            Button(role: .destructive) {
                                mind.container.viewContext.delete(mood)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
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
                .padding(.bottom, 10)
                
            }
            
            if showRatingTool {
                ZStack(alignment: .topTrailing) {
                    
                    RatingTool(onSelect: addRating)
                    
                    Button {
                        withAnimation {
                            showRatingTool.toggle()
                        }
                    } label: {
                        Image(systemName: "chevron.down.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50, alignment: .center)
                            .foregroundStyle(.white, .black)
                    }
                    .padding()
                    
                }
                .transition(.move(edge: .bottom))
            }
        }
        .background(background)
        .sheet(isPresented: $showCalendar) {
            NavigationStack {
                
                DatePicker("Date", selection: $date, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(.graphical)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Text("Selected Date")
                                .font(.title3.weight(.bold))
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                showCalendar.toggle()
                            }
                        }
                    }
                
            }
            .presentationDetents([.medium])
        }
        .fullScreenCover(isPresented: $showingLocationScreen) {
            NavigationStack {
                LocationView()
                    .navigationTitle("Location")
                    .toolbar {
                        Button("Close") {
                            showingLocationScreen.toggle()
                        }
                    }
            }
        }
        .onAppear {
            withAnimation {
                if todaysMood != nil {
                    viewing = moods.count - 1
                } else {
                    viewing = moods.count
                }
            }
        }
    }
    
    var background: Color {
        if moods.count == 0 || viewing >= moods.count {
            return .blue
        } else {
            return moods[viewing].color
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
            
            Button {
                withAnimation {
                    showCalendar.toggle()
                }
            } label: {
                Text(mood?.dateValue ?? date, style: .date)
                    .foregroundColor(.white)
            }
            .disabled(mood != nil)
            .padding(.bottom, 45)
            
        }
        .padding()
//        .background(mood?.rating.color ?? .blue)
    }
    
    func addRating(_ value: Int) {
        withAnimation {
            if viewing < moods.count {
                let mood = moods[viewing]
                mood.rating = value
            } else if let todaysMood {
                todaysMood.rating = value
            } else {
                let mood = Mood(context: mind.container.viewContext)
                mood.rating = value
                mood.date = date
                mood.dateAdded = .now
            }
            mind.save()
            showRatingTool = false
            date = .now
        }
    }
    
    func requestNotification() {
      locationManager.validateLocationAuthorizationStatus()
    }
    
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
