//
//  Place.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 11/21/23.
//

import Foundation
import MapKit

struct Place: Identifiable {
    let id = UUID()
    private var mapItem: MKMapItem
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    var name: String {
        self.mapItem.name ?? ""
    }
    
    var state: String {
        self.mapItem.placemark.administrativeArea ?? ""
    }
    
    var city: String {
        self.mapItem.placemark.locality ?? ""
    }
    
    var latitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.latitude
    }
    
    var longitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.longitude
    }
}

