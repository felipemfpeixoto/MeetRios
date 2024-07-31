//
//  UserLocationView.swift
//  MeetRio
//
//  Created by Felipe on 31/07/24.
//

import SwiftUI
import MapKit

struct UserLocationView: View {
    
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var mapSelection: Location?
    
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition) {
                UserAnnotation()
            }
        }
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
    
    
}


#Preview {
    UserLocationView()
}
