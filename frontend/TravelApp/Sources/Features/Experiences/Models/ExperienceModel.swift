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
    
    
    
//    var image: AsyncImage {
//        AsyncImage(url: imageURL)
//    }
//    private var coordinates: Coordinates
//    var locationCoordinate: CLLocationCoordinate2D {
//            CLLocationCoordinate2D(
//                latitude: coordinates.latitude,
//                longitude: coordinates.longitude)
//    }
    
//    AsyncImage(url: URL(string: "http://localhost:5000/")) { phase in
//        if let image = phase.image {
//            image
//                .resizable()
//                .scaledToFit()
//        } else if phase.error != nil {
//            Text("There was an error loading the image.")
//        } else {
//            ProgressView()
//        }
//    }
//    .frame(width: 200, height: 200)
//    private var imageName: String
        
    
//    struct Coordinates: Hashable, Codable {
//        var longitude: Double
//        var latitude: Double
//    }
}


