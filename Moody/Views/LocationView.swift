//
//  LocationView.swift
//  Moody
//
//  Created by Josh Smith on 11/16/22.
//

import SwiftUI
import MapKit

struct LocationView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var locationManager: LocationManager
    
    @State private var region: MKCoordinateRegion?
    
    var body: some View {
        Group {
            if let region {
                Map(coordinateRegion: .constant(region))
            } else {
                Button("Close") {
                    dismiss()
                }
            }
        }
        .onAppear {
            region = MKCoordinateRegion(center: locationManager.location, latitudinalMeters: 3, longitudinalMeters: 3)
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
