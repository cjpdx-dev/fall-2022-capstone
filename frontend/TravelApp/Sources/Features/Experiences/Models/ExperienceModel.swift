//
//  ExperienceModel.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/25/23.
//

import Foundation
import SwiftUI
import CoreLocation

struct Location: Hashable, Codable {
    var city: String = ""
    var state: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
}

struct Experience: Hashable, Codable, Identifiable{

    var id: String
    var title: String
    var description: String
    var rating: Int
    var keywords: [String]
    var date: Int
    var location: Location
    var imageUrl: String
    var userID: String
}


