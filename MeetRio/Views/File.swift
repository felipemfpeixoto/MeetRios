//
//  File.swift
//  MeetRio
//
//  Created by Luiz on 31/07/24.
//

import SwiftUI
import MapKit

// Exemplo de instâncias de Location
let location1 = Location(
    name: "Museu do Flamengo",
    isFavorite: true,
    coordinates: LocationCoordinates(latitude: -22.97828748980269, longitude: -43.218489847602584),
    label: .touristicSpot,
    address: LocationAddress(street: "Parque Nacional da Tijuca", neighborhood: "Alto da Boa Vista", postalCode: "22241-125", number: nil, complement: nil),
    aditionalData: LocationAditionalData(description: "Famoso ponto turístico do Rio de Janeiro.", images: [], feedbacks: [])
)

let location2 = Location(
    name: "Maracanã",
    isFavorite: false,
    coordinates: LocationCoordinates(latitude: -22.913399773849797, longitude: -43.22777413090763),
    label: .touristicSpot,
    address: LocationAddress(street: "Av. Pasteur", neighborhood: "Urca", postalCode: "22290-240", number: "520", complement: nil),
    aditionalData: LocationAditionalData(description: "Outro famoso ponto turístico.", images: [], feedbacks: [])
)

// Exemplo de uma rota
let route1 = Routes(
    name: "Tour do MENGAO PORRA",
    description: "Rota que vai do museu do Flamengo ao Maracanã (Casa do Flamengo)",
    waypoints: [location1, location2],
    feedbacks: RouteFeedbacks(),
    images: []
)

let location3 = Location(
    name: "Posto 10 - Loblon",
    isFavorite: true,
    coordinates: LocationCoordinates(latitude: -22.986658707779327, longitude: -43.22122970608272),
    label: .touristicSpot,
    address: LocationAddress(street: "Parque Nacional da Tijuca", neighborhood: "Alto da Boa Vista", postalCode: "22241-125", number: nil, complement: nil),
    aditionalData: LocationAditionalData(description: "Famoso ponto turístico do Rio de Janeiro.", images: [], feedbacks: [])
)

let location4 = Location(
    name: "Planetário",
    isFavorite: false,
    coordinates: LocationCoordinates(latitude: -22.977527982304824, longitude: -43.23015132616435),
    label: .touristicSpot,
    address: LocationAddress(street: "Av. Pasteur", neighborhood: "Urca", postalCode: "22290-240", number: "520", complement: nil),
    aditionalData: LocationAditionalData(description: "Outro famoso ponto turístico.", images: [], feedbacks: [])
)

// Exemplo de uma rota
let route2 = Routes(
    name: "Da praia ao planetário",
    description: "Rota que vai da praia ao planetário",
    waypoints: [location3, location4],
    feedbacks: RouteFeedbacks(),
    images: []
)

// Array de rotas
let routesArray: [Routes] = [route1, route2]

// Exemplo de visualização em SwiftUI para mostrar as rotas no mapa
struct MapView: View {
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    @State private var mapSelection: MKMapItem?
    
    @State var waypointCoordinates: [HashableCoordinate] = []
    
    @State var routes: [[MKRoute]] = []
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition, selection: $mapSelection) {
                // Polilinhas das rotas
                
                ForEach(routes, id: \.self) { route in
                    ForEach(route, id: \.polyline) { smallRoute in
                        MapPolyline(smallRoute.polyline)
                            .stroke(.blue, lineWidth: 3)
                        
                        
                        Annotation("", coordinate: smallRoute.polyline.coordinate){
                            Button(action: {
                                print("hi")
                            }, label: {
                                //smallRoute.polyline.boundingMapRect
                            })
                        }
                       
                    }
                }
            }
            
            VStack {
                Spacer()
                Button(action: {
                    fetchRoute()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .foregroundStyle(.cyan)
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(lineWidth: 4)
                            .foregroundStyle(.black)
                        Text("Mostrar Rota")
                            .foregroundStyle(.black)
                            .font(.system(size: 20).weight(.semibold))
                    }
                })
                .frame(width: 300, height: 43)
            }
        }
    }
    
    func fetchRoute() {
        for route in routesArray {
            var localWaypoints: [MKMapItem] = []
            for point in route.waypoints {
                print(point.name)
                localWaypoints.append(MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: point.coordinates.latitude, longitude: point.coordinates.longitude))))
            }
            
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
                            var routeAux: [MKRoute] = []
                            withAnimation(.snappy) {
                                routeAux.append(routeSegment)
                                self.routes.append(routeAux)
                                
                            }
                        }
                    }
                    
                }
            }
        }
    }
}

#Preview {
    MapView()
}


