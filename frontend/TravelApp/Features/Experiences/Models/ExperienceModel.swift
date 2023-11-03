//
//  ExperienceModel.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/25/23.
//

import Foundation
import SwiftUI
import CoreLocation

struct Experience: Hashable, Codable, Identifiable{

    var id: Int
    var title: String
    var description: String
    var rating: Int
    
    private var coordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(
                latitude: coordinates.latitude,
                longitude: coordinates.longitude)
        }
    
    private var imageName: String
        var image: Image {
            Image(imageName)
        }
    
    struct Coordinates: Hashable, Codable {
        var longitude: Double
        var latitude: Double
    }
    
    
}
