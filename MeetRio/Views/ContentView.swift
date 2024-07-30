//
//  ContentView.swift
//  MeetRio
//
//  Created by Felipe on 30/07/24.
//

import SwiftUI
import MapKit

// Estrutura para envolver um CLLocationCoordinate2D que seja Hashable sempre
struct HashableCoordinate: Identifiable, Hashable {
    let id: UUID = UUID()
    var coordinate: CLLocationCoordinate2D
    
    static func == (lhs: HashableCoordinate, rhs: HashableCoordinate) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }
}

struct ContentView: View {
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    @State private var routeDisplaying = false
    @State private var mapSelection: MKMapItem?
    @State private var routes: [MKRoute] = []
    @State private var waypointCoordinates: [HashableCoordinate] = [] // Armazenamento dos waypoints como HashableCoordinate

    var body: some View {
        Map(position: $cameraPosition, selection: $mapSelection) {
            // Anotações para cada waypoint
            ForEach(waypointCoordinates) { hashableCoord in
                Annotation("", coordinate: hashableCoord.coordinate) {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.red)
                }
            }
            
            // Polilinhas das rotas
            ForEach(routes, id: \.polyline) { route in
                MapPolyline(route.polyline)
                    .stroke(.blue, lineWidth: 6)
            }
        }
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
        .overlay(alignment: .bottom) {
            Button(action: fetchRoute) {
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(width: 150, height: 50)
                    .foregroundStyle(.gray.opacity(0.75))
            }
        }
    }

    func fetchRoute() {
        let userLocationItem = MKMapItem(placemark: MKPlacemark(coordinate: .userLocation))
        let localWaypoints = [
            userLocationItem,
            MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: -22.977896, longitude: -43.230160))),
            MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: -22.973772, longitude: -43.223122))),
            MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: -22.963785, longitude: -43.222283)))
        ]

        // Limpar o estado atual antes de recalcular
        routes.removeAll()
        waypointCoordinates.removeAll()
        
        // Adiciona os pontos dos waypoints para anotações como HashableCoordinate
        waypointCoordinates = localWaypoints.map { HashableCoordinate(coordinate: $0.placemark.coordinate) }

        for index in 0..<localWaypoints.count - 1 {
            let source = localWaypoints[index]
            let destination = localWaypoints[index + 1]

            Task {
                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: source.placemark.coordinate))
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination.placemark.coordinate))

                let directions = MKDirections(request: request)
                if let result = try? await directions.calculate(), let routeSegment = result.routes.first {
                    DispatchQueue.main.async {
                        self.routes.append(routeSegment)
                        withAnimation(.snappy) {
                            self.routeDisplaying = true
                            let rect = routeSegment.polyline.boundingMapRect
                            self.cameraPosition = .region(MKCoordinateRegion(rect))
                        }
                    }
                }
            }
        }
    }
}

extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: -22.977726, longitude: -43.232090)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation, latitudinalMeters: 2000, longitudinalMeters: 2000)
    }
}

#Preview {
    ContentView()
}
