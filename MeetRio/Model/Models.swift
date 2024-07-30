//
//  Models.swift
//  MeetRio
//
//  Created by Felipe on 30/07/24.
//

import Foundation

// Locais
enum LocationLabel: Codable {
    case restaurant, bar, waterfall, touristicSpot
}

struct Location: Codable {
    var id: UUID = UUID()
    var name: String
    var isFavorite: Bool
    var coordinates: LocationCoordinates
    var label: LocationLabel
    var address: LocationAddress
    var aditionalData: LocationAditionalData
}

struct LocationAverages: Codable {
    var averageTime: String
    var averageBudget: Double
}

struct LocationCoordinates: Codable {
    var latitude: Double
    var longitude: Double
}

struct LocationAddress: Codable {
    var street: String?
    var neighborhood: String?
    var postalCode: String?
    var number: String?
    var complement: String?
}

struct LocationAditionalData: Codable {
    var description: String
    var images: [Data]
    var feedbacks: [LocationFeedbacks] = []
}

struct LocationFeedbacks: Codable {
    // vai vir depois
}


// Rotas
struct Routes: Codable {
    var id: UUID = UUID()
    var name: String
    var description: String
    var waypoints: [Location]
    var feedbacks: RouteFeedbacks
    var images: [Data]
}

struct RouteFeedbacks: Codable {
    //
}
