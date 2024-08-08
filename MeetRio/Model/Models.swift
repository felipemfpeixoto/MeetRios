//
//  Models.swift
//  MeetRio
//
//  Created by Felipe on 30/07/24.
//

import Foundation

// Objetos
struct Hospede: Codable {
    var id = UUID()
    var name: String
    var country: CountryDetails
    var picture: Data
    var hostel: Hostel?
}

struct Hostel: Codable {
    var id = UUID()
    var name: String
    var email: String
    var password: String
    var location: LocationDetails
}

struct Event: Codable {
    var id = UUID()
    var name: String
    var date: Date
    var address: AddressDetails
}

// Relações
struct FavoriteEvent: Codable {
    var userID: UUID
    var eventID: UUID
}

struct GoingEvent: Codable {
    var userID: UUID
    var eventID: UUID
}

struct RecomendedEvent: Codable {
    var hostelID: UUID
    var eventID: UUID
}

// Componentes
struct CountryDetails: Codable {
    var name: String
    var flag: Data
}

struct LocationDetails: Codable {
    var latitude: String
    var longitude: String
}

struct AddressDetails: Codable {
    var street: String
    var number: String
    var details: String?
    var neighborhood: String
    var postalCode: String
}
